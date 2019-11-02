//
//  FavoriteMoviesView.swift
//  ConcreteApplication
//
//  Created by Bruno Cruz on 02/11/19.
//  Copyright © 2019 Bruno Cruz. All rights reserved.
//

import UIKit

protocol FavoriteMoviesDelegate: class {
    func didPressRemoveFilterButton()
    func reloadMovies()
}

enum PresentationState {
    case withFilter
    case withoutFilter
}

class FavoriteMoviesView: UIView {
    
    weak var delegate: FavoriteMoviesDelegate?
    fileprivate var presentationState: PresentationState = .withoutFilter
    
    lazy var tableView: FavoriteMoviesTableView = {
        let tb = FavoriteMoviesTableView(frame: .zero)
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    lazy var button: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
        return button
    }()
    
    init(frame: CGRect,
         delegate: FavoriteMoviesDelegate?) {
        super.init(frame: frame)
        self.delegate = delegate
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func didPressButton() {
        self.delegate?.didPressRemoveFilterButton()
    }
    
    func changePresentationState(to state: PresentationState){
        self.presentationState = state
        
        switch state {
        case .withFilter:
            setupView()
            break
        case .withoutFilter:
            self.delegate?.reloadMovies()
            self.setupView()
        }
    }
    
}

extension FavoriteMoviesView: CodeView {
    
    func buildViewHierarchy() {
        addSubview(button)
        addSubview(tableView)
    }
    
    func setupConstraints() {
        
        tableView.snp.removeConstraints()
        button.snp.removeConstraints()
        
        if self.presentationState == .withoutFilter {
            
            tableView.snp.makeConstraints { (make) in
                make.height.bottom.trailing.leading.equalToSuperview()
            }
            
            button.snp.makeConstraints { (make) in
                make.bottom.equalTo(tableView.snp.top)
                make.trailing.leading.equalToSuperview()
                make.height.equalTo(0)
            }
        } else {
            
            tableView.snp.makeConstraints { (make) in
                make.height.equalToSuperview().multipliedBy(0.8)
                make.bottom.trailing.leading.equalToSuperview()
            }
            
            button.snp.makeConstraints { (make) in
                make.bottom.equalTo(tableView.snp.top)
                make.trailing.leading.equalToSuperview()
                make.height.equalToSuperview().multipliedBy(0.1)
            }
        }
        
    }
    
    func setupAdditionalConfiguration() {
        
        button.setTitle("Remove Filter", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        button.setTitleColor(Design.Colors.darkYellow, for: .normal)
        button.backgroundColor = Design.Colors.darkBlue
    }
    
}
