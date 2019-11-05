//
//  MoviesGridView.swift
//  ConcreteApplication
//
//  Created by Bruno Cruz on 04/11/19.
//  Copyright © 2019 Bruno Cruz. All rights reserved.
//

import UIKit

enum MoviesGridPresentationState {
    case loadingContent
    case displayingContent
    case error
    case emptySearch
}

class MoviesGridView: UIView {
    
    lazy var collectionView: MoviesGridCollectionView = {
        let collection = MoviesGridCollectionView(frame: .zero)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    lazy var activityIndicator: ActivityIndicator = {
        let activity = ActivityIndicator(frame: .zero)
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()

    lazy var errorView: ErrorView = {
        let view = ErrorView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var emptySearchView: EmptySearchView = {
        let view = EmptySearchView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(for presentationState: MoviesGridPresentationState) {
        switch presentationState {
        case .loadingContent:
            collectionView.isHidden = true
            activityIndicator.isHidden = false
            errorView.isHidden = true
            emptySearchView.isHidden = true
        case .displayingContent:
            collectionView.isHidden = false
            activityIndicator.isHidden = true
            errorView.isHidden = true
            emptySearchView.isHidden = true
        case .error:
            collectionView.isHidden = true
            activityIndicator.isHidden = true
            errorView.isHidden = false
            emptySearchView.isHidden = true
        case .emptySearch:
            collectionView.isHidden = true
            activityIndicator.isHidden = true
            errorView.isHidden = true
            emptySearchView.isHidden = false
        }
    }
    
}

extension MoviesGridView: CodeView {
    
    func buildViewHierarchy() {
        addSubview(collectionView)
        addSubview(activityIndicator)
        addSubview(errorView)
        addSubview(emptySearchView)
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        errorView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        emptySearchView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}
