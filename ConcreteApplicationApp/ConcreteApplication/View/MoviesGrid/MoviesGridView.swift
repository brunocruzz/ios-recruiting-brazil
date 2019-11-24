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
    
    lazy var emptySearchView: EmptySearchView = {
        let view = EmptySearchView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl(frame: .zero)
        refreshControl.translatesAutoresizingMaskIntoConstraints = false
        refreshControl.tintColor = Design.Colors.darkYellow
        return refreshControl
    }()
    
    lazy var errorView = ErrorView(frame: self.collectionView.frame)
    
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
            emptySearchView.isHidden = true
            collectionView.backgroundView = nil
        case .displayingContent:
            collectionView.isHidden = false
            activityIndicator.isHidden = true
            emptySearchView.isHidden = true
            collectionView.backgroundView = nil
        case .error:
            //TODO:- change error state
            collectionView.isHidden = false
            activityIndicator.isHidden = true
            emptySearchView.isHidden = true
            collectionView.backgroundView = errorView
        case .emptySearch:
            collectionView.isHidden = true
            activityIndicator.isHidden = true
            emptySearchView.isHidden = false
            collectionView.backgroundView = nil
        }
    }
}

extension MoviesGridView: CodeView {
    
    func buildViewHierarchy() {
        addSubview(collectionView)
        addSubview(activityIndicator)
        addSubview(emptySearchView)
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }

        emptySearchView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    func setupAdditionalConfiguration() {
        self.collectionView.refreshControl = self.refreshControl
    }
    
}
