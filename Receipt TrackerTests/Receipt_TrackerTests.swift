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
    
    func testDeleteReceiptIsSuccessful() {
        let expectation = XCTestExpectation(description: "Delete a receipt")
        let model = ReceiptModel()
        
        model.deleteReceipt(receiptId: 2) { (_ isSuccessful) -> Void in
            XCTAssertTrue(isSuccessful)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testUpdateReceiptIsSuccessful() {
        let expectation = XCTestExpectation(description: "Delete a receipt")
        let model = ReceiptModel()
        
        if let receipt = Receipt(id: 3, vendorName: "Hola Goods", date: "2019-03-19", total: "5.75", items: nil) {
            let parameters: [String: AnyObject] = [
                "id": receipt.id! as AnyObject,
                "vendorName": receipt.vendorName as AnyObject,
                "date": receipt.date as AnyObject,
                "total": receipt.total as AnyObject,
                "items": receipt.items as AnyObject
            ]
            
            model.updateReceipt(parameters) { (_ receiptSummary) -> Void in
                XCTAssertNotNil(receiptSummary)
                
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }

}
