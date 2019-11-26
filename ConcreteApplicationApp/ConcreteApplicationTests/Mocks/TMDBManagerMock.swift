//
//  TMDBManagerMock.swift
//  ConcreteApplicationTests
//
//  Created by Bruno Cruz on 25/11/19.
//  Copyright © 2019 Bruno Cruz. All rights reserved.
//

import Foundation

@testable import ConcreteApplication

class TMDBManagerMock: TMDBManagerProtocol {
    
    func getPopularMovies(page: Int, completion: @escaping (Result<[Movie]>) -> Void) {
        completion(.success(MoviesMock.getMovies()))
    }
    
    func getGenres(completion: @escaping (Result<[Genre]>) -> Void) {
        completion(.success(MoviesMock.getGenres()))
    }
}
