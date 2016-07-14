//
//  StockTests.swift
//  Stock Quote Example
//
//  Created by Eugene on 7/13/16.
//  Copyright © 2016 Ievgenii Pavlov. All rights reserved.
//

import XCTest
@testable import Stock_Quote_Example

class StockTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIsURLNotEmpty() {
        XCTAssertNotNil(JsonDataManager.sharedInstance.JSON_URL)
    }
    
    func testStockValueIsNotNil() {
        JsonDataManager.sharedInstance.downloadData { (stockData) in
            dispatch_async(dispatch_get_main_queue(), {
                XCTAssertNotNil(stockData.stockValue)
            })
        }
    }
    
    func testStockLabelIsNotNil() {
        JsonDataManager.sharedInstance.downloadData { (stockData) in
            dispatch_async(dispatch_get_main_queue(), {
                XCTAssertNotNil(stockData.stockLabel)
            })
        }
    }
    
    func testTimestampIsNotNil() {
        JsonDataManager.sharedInstance.downloadData { (stockData) in
            dispatch_async(dispatch_get_main_queue(), {
                XCTAssertNotNil(stockData.timestamp)
            })
        }
    }
    
    func testErrorIsNil() {
        JsonDataManager.sharedInstance.downloadData { (stockData) in
            dispatch_async(dispatch_get_main_queue(), {
                XCTAssertNil(JsonDataManager.sharedInstance.errorReturned)
            })
        }
        
    }
    
}
