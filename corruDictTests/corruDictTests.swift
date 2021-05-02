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
    }

    override func tearDown() {
    }

    func testExample() {
    }

    func testExample2() {
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        
        self.measure {
            // Put the code you want to measure the time of here.
            

            let sema = DispatchSemaphore(value: 0)
            
            let source = NewsSource(itemType: .news)
            source.getNewsItems(offset: 0, count: 45) { (items, count, total, errString) in
                
                XCTAssertTrue(items?.count ?? 0 > 0)
                sema.signal()
            }
            sema.wait()
        }
    }

}
