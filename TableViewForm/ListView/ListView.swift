//
//  ListView.swift
//  TableViewForm
//
//  Created by 윤병진 on 2020/11/30.
//

import UIKit
import SnapKit

class ListView: UIView {
    
    public let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        tableViewAttributes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableViewConstraintsCondition()
    }
    
    private func addView() {
        addSubview(tableView)
    }
    
    private func tableViewAttributes() {
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = true
        tableView.tableFooterView = UIView()
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .pmsBackgroundColor
    }
    
    private func tableViewConstraintsCondition() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(30)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
}
