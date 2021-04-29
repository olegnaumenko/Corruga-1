//
//  corruDictTests.swift
//  corruDictTests
//
//  Created by oleg.naumenko on 7/25/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import XCTest
@testable import Corruga

class corruDictTests: XCTestCase {

    static var classInstanceCounter = 0
    
    override func setUp() {
        corruDictTests.classInstanceCounter += 1
    }

    override func tearDown() {
        corruDictTests.classInstanceCounter -= 1
    }

    func testExample() {
        print("ctest 1: ", corruDictTests.classInstanceCounter)
    }

    func testExample2() {
        print("ctest 2: ", corruDictTests.classInstanceCounter)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
