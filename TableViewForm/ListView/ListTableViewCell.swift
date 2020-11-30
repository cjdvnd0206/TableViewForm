//
//  ListTableViewCell.swift
//  TableViewForm
//
//  Created by 윤병진 on 2020/11/30.
//

import UIKit
import SnapKit
import RxSwift

class ListTableViewCell: UITableViewCell {
    
    private let customView = UIView()
    public let labelReqNum = UILabel()
    public let labelExplain1 = UILabel()
    public let labelExplain2 = UILabel()
    public let labelExplain3 = UILabel()
    public let labelExplain4 = UILabel()
    public let inputExpand1 = UITextField()
    public let inputExpand2 = UITextField()
    public let inputExpand3 = UITextField()
    public let inputExpand4 = UITextField()
    public let inputExpand5 = UITextField()
    public let imageUpDown = UIImageView()
    public let buttonDocRec = UIButton()
    public let buttonDocView = UIButton()
    private let downloadImageView = UIImageView()
    private let shadowLayer = CAShapeLayer()
    private let conerRadius : CGFloat = 15
    public var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .pmsBackgroundColor
        addView()
        labelAttributes(labelReqNum, size: 13)
        labelAttributes(labelExplain1, size: 13)
        labelAttributes(labelExplain2, size: 13)
        labelAttributes(labelExplain3, size: 13)
        labelAttributes(labelExplain4, size: 13)
        
        inputAttributes(inputExpand1, size: 13)
        inputAttributes(inputExpand2, size: 13)
        inputAttributes(inputExpand3, size: 13)
        inputAttributes(inputExpand4, size: 13)
        inputAttributes(inputExpand5, size: 13)
        makeButtonDocumentReceptionAttributes()
        makeButtonDocumentViewAttributes()
        makeImageUpDownAttributes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        customViewConstraints()
        makeLabelRequestNumberConstraints()
        makeLabelExplain1Constraints()
        makeLabelExplain2Constraints()
        makeLabelExplain3Constraints()
        makeLabelExplain4Constraints()
        makeInputExpand1Constraints()
        makeInputExpand2Constraints()
        makeInputExpand3Constraints()
        makeInputExpand4Constraints()
        makeInputExpand5Constraints()
        makeButtonDocumentReceptionConstraints()
        makeButtonDocumentViewConstraints()
        makeImageUpDownConstraints()
    }
    
    override func draw(_ rect: CGRect) {
        setShadowConrnerRadius()
    }
    
    private func addView() {
        addSubview(customView)
        customView.addSubview(labelReqNum)
        customView.addSubview(labelExplain1)
        customView.addSubview(labelExplain2)
        customView.addSubview(labelExplain3)
        customView.addSubview(labelExplain4)
        customView.addSubview(inputExpand1)
        customView.addSubview(inputExpand2)
        customView.addSubview(inputExpand3)
        customView.addSubview(inputExpand4)
        customView.addSubview(inputExpand5)
        customView.addSubview(buttonDocRec)
        customView.addSubview(buttonDocView)
        customView.addSubview(imageUpDown)
    }
    
    private func setShadowConrnerRadius() {
        shadowLayer.path = UIBezierPath(roundedRect: customView.bounds, cornerRadius: conerRadius).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.rgbColor(43, 87, 91).cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        shadowLayer.shadowOpacity = 0
        shadowLayer.shadowRadius = 3
        customView.layer.insertSublayer(shadowLayer, at: 0)
    }
    
    private func labelAttributes(_ label : UILabel, size : CGFloat) {
        if label == labelReqNum {
            label.textColor = .rgbColor(94, 124, 226)
        }
        else {
            label.textColor = .rgbColor(69, 79, 99)
        }
        label.font = .boldSystemFont(ofSize: size)
    }
    
    private func inputAttributes(_ textField: UITextField, size: CGFloat) {
        textField.setLeftPaddingPoints(15)
        textField.font = .boldSystemFont(ofSize: size)
        textField.backgroundColor = .rgbColor(242, 245, 247)
        textField.isHidden = true
        textField.textColor = .rgbColor(69, 79, 99)
        textField.layer.cornerRadius = 5
        textField.isEnabled = false
    }
    
    private func makeButtonDocumentReceptionAttributes() {
        buttonDocRec.setTitle("반려", for: .normal)
        buttonDocRec.titleLabel?.font = .boldSystemFont(ofSize: 13)
        buttonDocRec.backgroundColor = .rgbColor(243, 134, 138)
        buttonDocRec.setTitleColor(.white, for: .normal)
        buttonDocRec.layer.cornerRadius = 3
        buttonDocRec.isHidden = true
    }
    
    private func makeButtonDocumentViewAttributes() {
        buttonDocView.setTitle("서류보기", for: .normal)
        buttonDocView.titleLabel?.font = .boldSystemFont(ofSize: 13)
        buttonDocView.backgroundColor = .rgbColor(94, 124, 226)
        buttonDocView.setTitleColor(.white, for: .normal)
        buttonDocView.layer.cornerRadius = 3
    }
    
    private func makeImageUpDownAttributes() {
        imageUpDown.image = UIImage(named: "TableViewCellDown")
    }
    
    private func customViewConstraints() {
        customView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.bottom.equalTo(self).offset(-10)
        }
    }
    
    private func makeLabelRequestNumberConstraints() {
        labelReqNum.snp.makeConstraints { make in
            make.top.equalTo(self).offset(20)
            make.leading.equalTo(self).offset(40)
            make.trailing.equalTo(self.snp.centerX).offset(-100)
        }
    }
    
    private func makeLabelExplain1Constraints() {
        labelExplain1.snp.makeConstraints { make in
            make.top.equalTo(labelReqNum.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(40)
            make.trailing.equalTo(self).offset(-40)
        }
    }
    
    private func makeLabelExplain2Constraints() {
        labelExplain2.snp.makeConstraints { make in
            make.top.equalTo(labelExplain1.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(40)
            make.trailing.equalTo(self).offset(-40)
        }
    }
    
    private func makeLabelExplain3Constraints() {
        labelExplain3.snp.makeConstraints { make in
            make.top.equalTo(labelExplain2.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(40)
            make.trailing.equalTo(self).offset(-40)
        }
    }
    
    private func makeLabelExplain4Constraints() {
        labelExplain4.snp.makeConstraints { make in
            make.top.equalTo(labelExplain3.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(40)
            make.trailing.equalTo(self).offset(-40)        }
    }
    
    private func makeInputExpand1Constraints() {
        inputExpand1.snp.makeConstraints { make in
            make.top.equalTo(buttonDocView.snp.bottom).offset(30)
            make.leading.equalTo(self).offset(40)
            make.trailing.equalTo(self).offset(-40)
            make.height.equalTo(20)
        }
    }
    
    private func makeInputExpand2Constraints() {
        inputExpand2.snp.makeConstraints { make in
            make.top.equalTo(inputExpand1.snp.bottom).offset(10)
            make.leading.equalTo(self).offset(40)
            make.trailing.equalTo(self).offset(-40)
            make.height.equalTo(20)
        }
    }
    
    private func makeInputExpand3Constraints() {
        inputExpand3.snp.makeConstraints { make in
            make.top.equalTo(inputExpand2.snp.bottom).offset(10)
            make.leading.equalTo(self).offset(40)
            make.trailing.equalTo(self).offset(-40)
            make.height.equalTo(20)
        }
    }
    
    private func makeInputExpand4Constraints() {
        inputExpand4.snp.makeConstraints { make in
            make.top.equalTo(inputExpand3.snp.bottom).offset(10)
            make.leading.equalTo(self).offset(40)
            make.trailing.equalTo(self).offset(-40)
            make.height.equalTo(20)
        }
    }
    
    private func makeInputExpand5Constraints() {
        inputExpand5.snp.makeConstraints { make in
            make.top.equalTo(inputExpand4.snp.bottom).offset(10)
            make.leading.equalTo(self).offset(40)
            make.trailing.equalTo(self).offset(-40)
            make.height.equalTo(20)
        }
    }
    
    private func makeButtonDocumentReceptionConstraints() {
        buttonDocRec.snp.makeConstraints { make in
            make.centerY.equalTo(labelReqNum)
            make.leading.equalTo(labelReqNum.snp.trailing).offset(10)
            make.trailing.equalTo(self.snp.centerX).offset(-20)
            make.height.equalTo(20)
        }
    }
    
    private func makeButtonDocumentViewConstraints() {
        buttonDocView.snp.makeConstraints { make in
            make.top.equalTo(labelExplain4.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(140)
            make.trailing.equalTo(self).offset(-140)
            make.height.equalTo(30)
        }
    }
    
    private func makeImageUpDownConstraints() {
        imageUpDown.snp.makeConstraints { make in
            make.bottom.equalTo(self).offset(-20)
            make.centerX.equalTo(self)
        }
    }
}
