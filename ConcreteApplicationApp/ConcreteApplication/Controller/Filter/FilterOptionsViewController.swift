//
//  FilterOptionsViewController.swift
//  ConcreteApplication
//
//  Created by Bruno Cruz on 26/12/18.
//  Copyright © 2018 Bruno Cruz. All rights reserved.
//

import UIKit
import Reusable
import SnapKit

enum FilterOptions: String, CaseIterable {
    case date = "Date"
    case genre = "Genres"
}

class FilterOptionsViewController: UIViewController {
    
    var controllerView: FilterOptionsView
    let filterOptions = FilterOptions.allCases
    var parameters = ["1","2","3","4","5","6"]
    var genresParameters:[String] = []
    var releasedYearsParameters:[String] = []
    var filter = Filter()
    var movies: [Movie] = []
    weak var delegate: FilterDelegate?
    
    init(movies: [Movie],
         delegate: FilterDelegate) {
        
        self.controllerView = FilterOptionsView(frame: .zero)
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.getParameters(for: movies)
        self.movies = movies
    }
    
    override func loadView() {
        self.controllerView.delegate = self
        self.view = controllerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        self.title = "Filter"
        self.controllerView.tableView.delegate = self
        self.controllerView.tableView.dataSource = self
        self.controllerView.tableView.backgroundColor = .white
        self.view.backgroundColor = self.controllerView.tableView.backgroundColor
        self.controllerView.tableView.register(cellType: FilterTableViewCell.self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getParameters(for movies: [Movie]) {
        self.genresParameters = []
        self.releasedYearsParameters = []
        
        movies.forEach { (movie) in
            movie.genres.forEach({
                if !self.genresParameters.contains($0.name ?? "") {
                    self.genresParameters.append($0.name ?? "")
                }
            })
            if !self.releasedYearsParameters.contains(movie.releaseYear) {
                self.releasedYearsParameters.append(movie.releaseYear)
            }
        }
    }
    
    func applyFilter() {
        
        let filteredMovies = self.movies.filter({ (movie) -> Bool in
            var matchedYear = false
            var matchedGenre = false
            
            if let releasedYearFilter = self.filter.releaseYear {
                matchedYear = movie.releaseYear == releasedYearFilter
            } else {
                matchedYear = true
            }
            
            if let genreFilter = self.filter.genre {
                matchedGenre = movie.genres.contains(where: {$0.name?.lowercased() == genreFilter.lowercased()})
            } else {
                matchedGenre = true
            }
            
            return matchedYear && matchedGenre
        })
        self.delegate?.updateMovies(with: filteredMovies)
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension FilterOptionsViewController: FilterDelegate {
    
    func updateParameter(for option: FilterOptions, with value: String) {
        self.filter.updateParameter(of: option, with: value)
        self.controllerView.tableView.reloadData()
    }
    
}

extension FilterOptionsViewController: FilterOptionsDelegate {
    
    func didPressApplyButton() {
        self.applyFilter()
    }
    
}
