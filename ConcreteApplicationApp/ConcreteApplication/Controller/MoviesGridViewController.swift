//
//  MoviesGridViewController.swift
//  ConcreteApplication
//
//  Created by Bruno Cruz on 20/12/18.
//  Copyright © 2018 Bruno Cruz. All rights reserved.
//

import UIKit
import SnapKit

class MoviesGridViewController: UIViewController {
    
    //View
    var controllerView = MoviesGridView(frame: .zero)
    
    //Delegates and Datasources
    var collectionViewDataSource: MoviesGridCollectionDataSource?
    var collectionViewDelegate: MoviesGridCollectionDelegate?
    
    //SearchController
    let searchController = UISearchController(searchResultsController: nil)
    //TMDB API
    let tmdb = TMDBManager()
    //Properties
    var movies: [Movie] = []
    var genres: [Genre] = []
    var currentPage = 0
    
    fileprivate var presentationState: MoviesGridPresentationState = .loadingContent {
        didSet {
            DispatchQueue.main.async {
                self.controllerView.updateUI(for: self.presentationState)
            }
        }
    }
        
    override func loadView() {
        self.view = controllerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupRefreshControl()
        presentationState = .loadingContent
        self.fetchGenres()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presentationState = .loadingContent
        self.getMoviesFromRealm()
    }
    
    func fetchGenres() {
        tmdb.getGenres { (result) in
            self.presentationState = .loadingContent
            switch result {
            case .success(let genres):
                self.genres = genres
                self.fetchMovies(page: 1)
                self.currentPage = 1
            case .error:
                self.presentationState = .error
            }
        }
    }
    
    func fetchMovies(page: Int) {
        tmdb.getPopularMovies(page: page) { (result) in
            switch result {
            case .success(let movies):
                self.movies.append(contentsOf: movies)
                self.getMoviesFromRealm()
            case .error:
                self.presentationState = .error
            }
        }
    }
    
    func refreshMovies() {
        tmdb.getPopularMovies(page: 1) { (result) in
            switch result {
            case .success(let movies):
                self.movies = movies
                self.currentPage = 1
                self.getMoviesFromRealm()
            case .error:
                self.presentationState = .error
            }
        }
    }
    
    func getMoviesFromRealm() {
        self.clearFavoriteMovies()
        let favoritedMovies = RealmManager.shared.getAll(objectsOf: MovieRealm.self)
        for favoritedMovie in favoritedMovies {
            for (index,movie) in self.movies.enumerated() {
                if favoritedMovie.id == movie.id{
                    self.movies[index].isFavorite = true
                }
            }
        }
        self.handleFetchOf(movies: self.movies)
    }
    
    func clearFavoriteMovies() {
        for (index,_) in self.movies.enumerated() {
            self.movies[index].isFavorite = false
        }
    }
    
    
    func handleFetchOf(movies:[Movie]) {
        self.setupCollectionView(with: movies)
        self.presentationState = .displayingContent
    }
    
    
    func setupCollectionView(with movies: [Movie]) {
        collectionViewDataSource = MoviesGridCollectionDataSource(movies: movies,
                                                                  collectionView: controllerView.collectionView,
                                                                  pagingDelegate: self)
        controllerView.collectionView.dataSource = collectionViewDataSource
        collectionViewDelegate = MoviesGridCollectionDelegate(movies: movies, delegate: self)
        controllerView.collectionView.delegate = collectionViewDelegate
        controllerView.collectionView.reloadData()
    }
    
//MARK:- Pull to refresh
    func setupRefreshControl() {
        self.controllerView.collectionView.refreshControl?.addTarget(self,
                                                                     action: #selector(refreshItems),
                                                                     for: .valueChanged)
    }
    
    @objc
    func refreshItems() {
        self.refreshMovies()
        searchController.searchBar.text = ""
        searchController.dismiss(animated: true, completion: nil)
        self.controllerView.collectionView.refreshControl?.endRefreshing()
    }
    
}

//MARK:- delegates
extension MoviesGridViewController: MoviesSelectionDelegate {
    func didSelectMovie(movie: Movie) {
        var selectedMovie = movie
        var movieGenres:[Genre] = []
        for genre in movie.genres{
            movieGenres.append(contentsOf: self.genres.filter {$0.id == genre.id})
        }
        
        selectedMovie.genres = movieGenres
        let movieDetailController = MovieDetailTableViewController(movie: selectedMovie, style: .grouped)
        movieDetailController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(movieDetailController, animated: true)
    }
}

extension MoviesGridViewController: MoviesGridPagingDelegate {
    
    func shouldFetch(page: Int) {
        if page == self.currentPage + 1{
            self.currentPage += 1
            self.fetchMovies(page: self.currentPage)
        }
    }
    
}

extension MoviesGridViewController: UISearchBarDelegate {
    
    func setupSearchBar() {
        self.searchController.searchBar.delegate = self
        navigationItem.searchController = self.searchController
        definesPresentationContext = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty ?? true {
            handleFetchOf(movies: self.movies)
        } else {
        let filteredMovies = self.movies.filter({$0.title.range(of: searchBar.text ?? "",
                                                                options: .caseInsensitive) != nil })
            if filteredMovies.count == 0 {
                controllerView.emptySearchView.text = searchBar.text ?? ""
                self.presentationState = .emptySearch
            } else {
                handleFetchOf(movies: filteredMovies)
            }
        }
        searchController.dismiss(animated: true, completion: nil)
    }

}
