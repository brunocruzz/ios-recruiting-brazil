//
//  FavoriteMoviesViewController.swift
//  ConcreteApplication
//
//  Created by Bruno Cruz on 26/12/18.
//  Copyright © 2018 Bruno Cruz. All rights reserved.
//

import UIKit
import SnapKit

class FavoriteMoviesViewController: UIViewController {
    
    var controllerView = FavoriteMoviesView(frame: .zero, delegate: nil)
    var tableViewDelegate: FavoriteMoviesTableViewDelegate?
    var tableViewDataSource: FavoriteMoviesTableViewDataSource?
    
    var favoritedMovies: [Movie] = []
    var filteredMovies: [Movie] = []
    
    
    fileprivate var presentationState: PresentationState = .withoutFilter {
        didSet {
            controllerView.changePresentationState(to: presentationState)
        }
    }
    
    override func loadView() {
        self.controllerView.delegate = self
        self.view = controllerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presentationState = .withoutFilter
         navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "FilterIcon"),
                                                             style: .plain, target: self,
                                                             action: #selector(pushFilterOptions))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if presentationState == .withoutFilter {
            self.getFavoriteMovies()
        }
    }
    
    func getFavoriteMovies() {
        self.favoritedMovies = []
        let favoriteMoviesRealm = RealmManager.shared.getAll(objectsOf: MovieRealm.self)
        favoriteMoviesRealm.forEach({ self.favoritedMovies.append(Movie(realmObject: $0)) })
        self.setupTableView(with: self.favoritedMovies)
    }
    
    func setupTableView(with movies: [Movie]) {
        tableViewDelegate = FavoriteMoviesTableViewDelegate(favoritedMovies: movies,
                                                            delegate: self)
        self.controllerView.tableView.delegate = tableViewDelegate
        tableViewDataSource = FavoriteMoviesTableViewDataSource(favoritedMovies: movies,
                                                                tableView: self.controllerView.tableView)
        self.controllerView.tableView.dataSource = tableViewDataSource
        self.controllerView.tableView.reloadData()
    }
    
    @objc
    func pushFilterOptions() {
        let filterViewController = FilterOptionsViewController(movies: favoritedMovies, delegate: self)
        filterViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(filterViewController, animated: true)
    }
    
    func removeFilter() {
        self.presentationState = .withoutFilter
    }
    
}

extension FavoriteMoviesViewController: UnfavoriteMovieDelegate {
    
    func deleteRowAt(indexPath: IndexPath) {
        
        var movies:[Movie] = self.favoritedMovies
        if presentationState == .withFilter{
            movies = filteredMovies
        }
        if let movieToDelete = RealmManager.shared.get(objectOf: MovieRealm.self, with: movies[indexPath.row].id) {
            RealmManager.shared.delete(object: movieToDelete)
            tableViewDataSource?.favoritedMovies.remove(at: indexPath.row)
            self.controllerView.tableView.deleteRows(at: [indexPath],
                                                     with: .automatic)
        }
    }
    
}

extension FavoriteMoviesViewController: FilterDelegate {
    
    func updateMovies(with filteredMovies: [Movie]) {
        self.presentationState = .withFilter
        self.filteredMovies = filteredMovies
        self.setupTableView(with: filteredMovies)
        
        if filteredMovies.count == 0 {
            presentationState = .emptySearch
            return
        }
        
        self.controllerView.tableView.scrollToRow(at: IndexPath(row: 0, section: 0),
                                                  at: .top,
                                                  animated: true)
    }
}

extension FavoriteMoviesViewController: FavoriteMoviesDelegate {
    
    func didPressRemoveFilterButton() {
        self.removeFilter()
    }
    
    func reloadMovies() {
        self.getFavoriteMovies()
    }
}
