//
//  Receipt_TrackerTests.swift
//  Receipt TrackerTests
//
//  Created by Scott Nicholes on 3/14/19.
//  Copyright © 2019 Scott Nicholes. All rights reserved.
//

import XCTest
@testable import Receipt_Tracker

class Receipt_TrackerTests: XCTestCase {
    // MARK: ReceiptModel tests
    func testReceiptGetRequest() {
        let expectation = XCTestExpectation(description: "Download a receipt")
        let model = ReceiptModel()
        
        model.getReceipt(receiptId: 1) { (_ receipt: Receipt?) -> Void in
            XCTAssertNotNil(receipt)
            for item in receipt!.items! {
                print(item.name)
                print(item.quantity)
                print(item.amount)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }

}
