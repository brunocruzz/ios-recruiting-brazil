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
    
    //FIXME:- Create status of empty search
    
    //CollectionView
    let collectionView = MoviesGridCollectionView()
    var collectionViewDataSource: MoviesGridCollectionDataSource?
    var collectionViewDelegate: MoviesGridCollectionDelegate?
    //Auxiliar Views
    var activityIndicator = ActivityIndicator(frame: .zero)
    var errorView = ErrorView(frame: .zero)
    //TMDB API
    let tmdb = TMDBManager()
    //Properties
    var movies:[Movie] = []
    var genres:[Genre] = []
    
    fileprivate enum LoadingState{
        case loading
        case ready
    }
    
    fileprivate enum PresentationState{
        case loadingContent
        case displayingContent
        case error
    }
    
    fileprivate var loadingState: LoadingState = .ready {
        didSet{
            DispatchQueue.main.async {
                self.refreshLoading(state: self.loadingState)
            }
        }
    }
    
    fileprivate var presentationState: PresentationState = .loadingContent{
        didSet{
            DispatchQueue.main.async {
                self.refreshUI(for: self.presentationState)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        loadingState = .loading
        presentationState = .loadingContent
        
        self.fetchGenres()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadingState = .loading
        presentationState = .loadingContent
        
        self.getMoviesFromRealm()
    }
    
    func fetchGenres(){
        loadingState = .loading
        presentationState = .loadingContent
        tmdb.getGenres { (result) in
            self.loadingState = .ready
            switch result{
            case .success(let genres):
                self.genres = genres
                self.fetchMovies(page: 1)
            case .error:
                self.presentationState = .error
            }
        }
    }
    
    func fetchMovies(page: Int){
        tmdb.getPopularMovies(page: page) { (result) in
            self.loadingState = .ready
            switch result{
            case .success(let movies):
                self.movies = movies
                self.getMoviesFromRealm()
            case .error:
                self.presentationState = .error
            }
        }
    }
    
    func getMoviesFromRealm(){
        self.clearFavoriteMovies()
        let favoritedMovies = RealmManager.shared.getAll(objectsOf: MovieRealm.self)
        for favoritedMovie in favoritedMovies{
            for (index,movie) in self.movies.enumerated(){
                if favoritedMovie.id == movie.id{
                    self.movies[index].isFavorite = true
                }
            }
        }
        self.handleFetchOf(movies: self.movies)
    }
    
    func clearFavoriteMovies(){
        for (index,_) in self.movies.enumerated(){
                self.movies[index].isFavorite = false
        }
    }
    
    
    func handleFetchOf(movies:[Movie]){
        self.setupCollectionView(with: movies)
        self.presentationState = .displayingContent
        self.loadingState = .ready
    }
    
    
    func setupCollectionView(with movies: [Movie]){
        self.collectionView.isHidden = false
        collectionViewDataSource = MoviesGridCollectionDataSource(movies: movies, collectionView: self.collectionView)
        self.collectionView.dataSource = collectionViewDataSource
        collectionViewDelegate = MoviesGridCollectionDelegate(movies: movies, delegate: self)
        self.collectionView.delegate = collectionViewDelegate
        self.collectionView.reloadData()
    }
    
}

//MARK:- CodeView protocol
extension MoviesGridViewController: CodeView{
    
    func buildViewHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        view.addSubview(errorView)
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
    }
}

//MARK:- Handling with UI changings

extension MoviesGridViewController{
    
    fileprivate func refreshLoading(state: LoadingState){
        switch state{
        case .loading:
            self.activityIndicator.startAnimating()
        case .ready:
            self.activityIndicator.stopAnimating()
        }
    }
    
    fileprivate func refreshUI(for presentationState: PresentationState){
        switch presentationState{
        case .loadingContent:
            collectionView.isHidden = true
            activityIndicator.isHidden = false
            errorView.isHidden = true
        case .displayingContent:
            collectionView.isHidden = false
            activityIndicator.isHidden = true
            errorView.isHidden = true
        case .error:
            collectionView.isHidden = true
            activityIndicator.isHidden = true
            errorView.isHidden = false
        }
    }
}

extension MoviesGridViewController: MoviesSelectionDelegate{
    func didSelectMovie(movie: Movie) {
        var selectedMovie = movie
        var movieGenres:[Genre] = []
        for genre in movie.genres{
            movieGenres.append(contentsOf: self.genres.filter{$0.id == genre.id})
        }
        
        selectedMovie.genres = movieGenres
        let movieDetailController = MovieDetailTableViewController(movie: selectedMovie, style: .grouped)
        movieDetailController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(movieDetailController, animated: true)
    }
}
