//
//  MoviesGridViewControllerSpec.swift
//  ConcreteApplicationTests
//
//  Created by Bruno Cruz on 05/11/19.
//  Copyright © 2019 Bruno Cruz. All rights reserved.
//

import Quick
import Nimble
import Nimble_Snapshots

@testable import ConcreteApplication

class MoviesGridViewControllerSpec: QuickSpec {
    
    override func spec() {
        
        var window: UIWindow!
        var sut: MoviesGridViewController!
        
        describe("MoviesGridViewController") {
            
            beforeEach {
                
                sut = MoviesGridViewController()
                
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
                
                it("should have tge expected layout for first state") {
                    expect(window) == snapshot("MoviesGridViewController_empty_list")
                }
            }
        }
    }
}
