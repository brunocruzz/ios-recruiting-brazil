//
//  MoviesGridViewControllerSpec.swift
//  ConcreteApplicationTests
//
//  Created by Bruno Cruz on 05/11/19.
//  Copyright © 2019 Bruno Cruz. All rights reserved.
//

import Quick
import Nimble

@testable import ConcreteApplication

class MoviesGridViewControllerSpec: QuickSpec {
    
    override func spec() {
        
        var sut: MoviesGridViewController!
        
        beforeEach {
            sut = MoviesGridViewController()
            _ = sut.view
        }
        
        afterEach {
            sut = nil
        }
        
        context("when initializang controller") {
            it("should not be nil") {
                expect(sut).toNot(beNil())
            }
        }
        
    }
}
