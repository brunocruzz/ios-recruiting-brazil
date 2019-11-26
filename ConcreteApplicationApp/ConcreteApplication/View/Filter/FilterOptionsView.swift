//
//  FilterOptionsView.swift
//  ConcreteApplication
//
//  Created by Bruno Cruz on 02/11/19.
//  Copyright © 2019 Bruno Cruz. All rights reserved.
//

import UIKit
import SnapKit

protocol FilterOptionsDelegate: class {
    func didPressApplyButton()
}

class FilterOptionsView: UIView {
    
    weak var delegate: FilterOptionsDelegate?
    
    lazy var tableView: UITableView = {
        let tb = UITableView(frame: .zero, style: .grouped)
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    lazy var button: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func didPressButton() {
        self.delegate?.didPressApplyButton()
    }
    
}

extension FilterOptionsView: CodeView {
    
    func buildViewHierarchy() {
        addSubview(tableView)
        addSubview(button)
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(button.snp.top)
        }
        
        button.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(30)
            make.height.equalToSuperview().multipliedBy(0.07)
        }
    }
    
    func setupAdditionalConfiguration() {
        button.setTitle("Apply", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = Design.Colors.clearYellow
        button.layer.cornerRadius = 10.0
    }
    
}
