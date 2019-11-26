//
//  MoviesMock.swift
//  ConcreteApplicationTests
//
//  Created by Bruno Cruz on 25/11/19.
//  Copyright © 2019 Bruno Cruz. All rights reserved.
//

import Foundation

@testable import ConcreteApplication

struct MoviesMock {
    
    static func getGenres() -> [Genre] {
        var genres: [Genre] = []
        
        let genre1 = Genre(id: 0, name: "Action")
        let genre2 = Genre(id: 1, name: "Terror")
        
        genres.append(genre1)
        genres.append(genre2)
        return genres
    }
    
    static func getMovies() -> [Movie] {
        var movies: [Movie] = []
        
        let movie1 = Movie(id: 1,
                           title: "movieTitle",
                           posterPath: "",
                           overview: "overview description",
                           releaseYear: "2019",
                           genres: self.getGenres())
        
        movies.append(movie1)
        return movies
    }
    
}
