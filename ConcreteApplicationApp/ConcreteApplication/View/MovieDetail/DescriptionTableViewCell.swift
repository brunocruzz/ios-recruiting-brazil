//
//  DescriptionTableViewCell.swift
//  ConcreteApplication
//
//  Created by Bruno Cruz on 21/12/18.
//  Copyright © 2018 Bruno Cruz. All rights reserved.
//

import UIKit
import SnapKit
import Reusable

protocol FavoriteMovieDelegate: class {
    func changeFavorite(to status: Bool)
}

final class DescriptionTableViewCell: UITableViewCell, Reusable {
    
    var isFavorite: Bool = false
    var favoriteDelegate: FavoriteMovieDelegate?
    
    lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setup(movieDetail: String,
               isFavorite: Bool = false,
               delegate: FavoriteMovieDelegate? = nil) {
        
        self.isFavorite = isFavorite
        self.favoriteDelegate = delegate
        label.text = movieDetail
        button.isHidden = delegate == nil ? true : false
        setupView()
    }
    
    @objc
    func favoriteButtonTapped() {
        
        self.isFavorite = !self.isFavorite
        if self.isFavorite {
            button.setImage(UIImage(named: "favorite_full_icon"), for: .normal)
        } else {
            button.setImage(UIImage(named: "favorite_gray_icon"), for: .normal)
        }
        self.favoriteDelegate?.changeFavorite(to: self.isFavorite)
    }

    
}

extension DescriptionTableViewCell: CodeView {
    
    func buildViewHierarchy() {
        contentView.addSubview(label)
        contentView.addSubview(button)
    }
    
    func setupConstraints() {
        
        label.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        button.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
    }
    
    func setupAdditionalConfiguration() {
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16.0)
        
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        if isFavorite {
            button.setImage(UIImage(named: "favorite_full_icon"), for: .normal)
        } else {
            button.setImage(UIImage(named: "favorite_gray_icon"), for: .normal)
        }
        
    }
    
}
