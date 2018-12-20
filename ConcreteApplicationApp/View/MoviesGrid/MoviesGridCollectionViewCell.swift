//
//  MoviesGridCollectionViewCell.swift
//  ConcreteApplication
//
//  Created by Bruno Cruz on 20/12/18.
//  Copyright © 2018 Bruno Cruz. All rights reserved.
//

import UIKit

class MoviesGridCollectionViewCell: UICollectionViewCell {
    
    var movie: Movie!
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func setup(movie: Movie){
        self.movie = movie
        //FIXME:- Extension to download Image
        setupView()
    }
}

extension MoviesGridCollectionViewCell: CodeView{
    func buildViewHierarchy() {
        contentView.addSubview(imageView)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
    }
    
    
}
