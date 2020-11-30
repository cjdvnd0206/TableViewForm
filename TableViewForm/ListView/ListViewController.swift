//
//  ListViewController.swift
//  TableViewForm
//
//  Created by 윤병진 on 2020/11/30.
//

import UIKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {
    
    private let registerListView = ListView()
    private let viewModel = ListViewViewModel()
    private var disposeBag = DisposeBag()
    private var cellIsSelected : IndexPath?
    
    deinit {
        print("Deinit \(String(describing: self.classForCoder))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        registerListViewConstraintsCondition()
        setObserver()
        setTableViewDelegate()
        setTableViewRefresh()
        mainBind()
        tableViewBind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setMainNavigationBarButton(backButton: true)
        setNavigationBar(labelTitle: "접수현황")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        IndicatorView.shared.show()
        viewModel.step.accept("1")
        viewModel.requestSubList()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let selectedImage = UIImage(named: "TabbarRegister")
        let unselectedImage = UIImage(named: "TabbarRegisterGray")
        self.tabBarItem = UITabBarItem(title: "접수현황", image: unselectedImage!.withRenderingMode(.alwaysOriginal), selectedImage: selectedImage!.withRenderingMode(.alwaysOriginal))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func addView() {
        view.backgroundColor = .pmsBackgroundColor
        view.addSubview(registerListView)
    }
    
    private func setTableViewDelegate() {
        registerListView.tableView.rx.setDelegate(self as UITableViewDelegate).disposed(by: disposeBag)
    }
    
    private func setTableViewRefresh() {
        registerListView.tableView.refreshControl = UIRefreshControl()
        registerListView.tableView.refreshControl?.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { _ in
                DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: {
                    DispatchQueue.main.sync {
                        self.viewModel.requestSubList()
                        self.registerListView.tableView.refreshControl?.endRefreshing()
                    }
                })
            }).disposed(by: disposeBag)
    }
    
    private func setObserver() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "refresh"), object: nil, queue: nil) { _ in
            self.viewModel.requestSubList()
        }
    }
    
    private func mainBind() {
        viewModel.model.asObservable()
            .map{$0}
            .subscribe(onNext: { response in
                IndicatorView.shared.hide()
                switch(response?.responseCode) {
                case 1:
                    print("조회성공!")
                    break
                case 2:
                    print("조회경과 없음(건수 없음)!")
                    self.alertHandler("데이터가 없습니다", actionButton: nil)
                    break
                case 0:
                    print("통신이상!")
                    self.alertHandler("서버통신에 이상있습니다. 관리자에게 문의하세요", actionButton: nil)
                    break
                default:
                    return
                }
                
            }).disposed(by: disposeBag)
        
        viewModel.responseError.asObservable()
            .debug("responseError")
            .subscribe(onNext: { error in
                if !error.isEmpty {
                    IndicatorView.shared.hide()
                    self.alertHandler("서버와의 통신이 원활하지 않습니다\n잠시 후에 시도해 주세요", actionButton: nil)
                }
            }).disposed(by: disposeBag)
    }
    
    private func tableViewBind(){
        viewModel.model
            .observeOn(MainScheduler.instance)
            .debug("TableView")
            .asObservable()
            .flatMap{Observable.from(optional: $0)}
            .map{$0.information!}
            .bind(to: registerListView.tableView.rx.items) { tableView, row, model in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RegisterListTableViewCell
                cell.selectionStyle = .none
                cell.labelReqNum.text = "No. \(String(tableView.numberOfRows(inSection: 0) - row))"
                cell.labelExplain1.text = ""
                cell.labelExplain2.text = "추천의사: \(model.reqFDrName)"
                cell.labelExplain3.text = "의료기관: \(model.reqFDrCName)"
                cell.labelExplain4.text = "연락처: \(model.reqFDrTel.addHypenFormat())"
                cell.inputExpand1.text = "요청일: \(model.reqDateReg.delDateSecondFormat())"
                //cell.inputExpand2.text = "추천일: \(model.reqDateDoc1.delDateSecondFormat())"
                //cell.inputExpand3.text = "협약일: \(model.reqDateDoc2.delDateSecondFormat())"
                //cell.inputExpand4.text = "촉탁기간: \(model.reqTerm.addHypenFormat())"
                //cell.inputExpand5.text = "등록비: \(model.reqFee)원 (\(model.reqFeeDate))"
                if model.reqStatus == "0" {
                    cell.buttonDocRec.isHidden = false
                }
                cell.buttonDocView.rx.tap
                    .asDriver()
                    .throttle(.seconds(1))
                    .debug("buttonDocView")
                    .drive(onNext: { _ in
                        Constants.Value.currentReqNum = model.reqNum
                        let allDocumentWebViewController = AllDocumentWebViewController(Url.webViewDoc)
                        allDocumentWebViewController.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(allDocumentWebViewController, animated: true)
                    }).disposed(by: cell.disposeBag)
                return cell
        }.disposed(by: disposeBag)
    }
    
    private func registerListViewConstraintsCondition() {
        registerListView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
        }
    }
}

extension RegisterListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellIsSelected == indexPath {
            return 360
        }
        return 190
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? RegisterListTableViewCell else { return }
        cellIsSelected = nil
        
        cell.inputExpand1.isHidden = true
        cell.inputExpand2.isHidden = true
        cell.inputExpand3.isHidden = true
        cell.inputExpand4.isHidden = true
        cell.inputExpand5.isHidden = true
        cell.imageUpDown.image = UIImage(named: "TableViewCellDown")
        
        cell.disposeBag = DisposeBag()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellIsSelected = cellIsSelected == indexPath ? nil : indexPath
        let cell = tableView.cellForRow(at: indexPath) as? RegisterListTableViewCell
        
        if cellIsSelected == indexPath {
            cell?.inputExpand1.isHidden = false
            cell?.inputExpand2.isHidden = false
            cell?.inputExpand3.isHidden = false
            cell?.inputExpand4.isHidden = false
            cell?.inputExpand5.isHidden = false
            cell?.imageUpDown.image = UIImage(named: "TableViewCellUp")
            
        }
        else{
            cell?.inputExpand1.isHidden = true
            cell?.inputExpand2.isHidden = true
            cell?.inputExpand3.isHidden = true
            cell?.inputExpand4.isHidden = true
            cell?.inputExpand5.isHidden = true
            cell?.imageUpDown.image = UIImage(named: "TableViewCellDown")
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? RegisterListTableViewCell
        cell?.inputExpand1.isHidden = true
        cell?.inputExpand2.isHidden = true
        cell?.inputExpand3.isHidden = true
        cell?.inputExpand4.isHidden = true
        cell?.inputExpand5.isHidden = true
        cell?.imageUpDown.image = UIImage(named: "TableViewCellDown")
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

