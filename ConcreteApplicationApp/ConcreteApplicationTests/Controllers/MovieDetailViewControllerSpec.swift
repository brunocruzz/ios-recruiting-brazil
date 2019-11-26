//
//  MovieDetailViewControllerSpec.swift
//  ConcreteApplicationTests
//
//  Created by Bruno Cruz on 25/11/19.
//  Copyright © 2019 Bruno Cruz. All rights reserved.
//

import Quick
import Nimble
import Nimble_Snapshots

@testable import ConcreteApplication

class MovieDetailTableViewControllerSpec: QuickSpec {
    
    override func spec() {
        
        var window: UIWindow!
        var sut: MovieDetailTableViewController!
        
        describe("MovieDetailTableViewController") {
            
            beforeEach {
                
                let movie = MoviesMock.getMovies().first!
                sut = MovieDetailTableViewController(movie: movie,
                                                     style: .grouped)
                
                window = UIWindow(frame: UIScreen.main.bounds)
                window.rootViewController = sut
                window.makeKeyAndVisible()
                _ = sut.view
            }
            
            afterEach {
                sut = nil
            }
            
            context("when initialized") {
                
                it("should not be nil") {
                    expect(sut).toNot(beNil())
                }
                
                it("should have the expected layout") {
                    expect(window) == snapshot("MovieDetailTableViewController")
                }
            }
        }
    }
}

