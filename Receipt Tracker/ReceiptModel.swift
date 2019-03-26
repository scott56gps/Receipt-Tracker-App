//
//  ReceiptModel.swift
//  Receipt Tracker
//
//  Created by Scott Nicholes on 3/20/19.
//  Copyright © 2019 Scott Nicholes. All rights reserved.
//

import Foundation
import Alamofire

/**
 * The Model that handles data manipulation and receiving data
 * from the API
 */
class ReceiptModel {
    // MARK: Properties
    var receiptsUrl = URL(string: "https://cs313-receipt-tracker.herokuapp.com/receipts")!
    var receiptUrl = URL(string: "https://cs313-receipt-tracker.herokuapp.com/receipt")!
    
    
    // MARK: Public Methods
    func getReceiptSummaries(_ callback: @escaping ([ReceiptSummary]) -> Void) {
        Alamofire.request(receiptsUrl).responseJSON { response in
            if let json = response.result.value {
                let receiptDictionaries = json as! [Dictionary<String, Any>]
                var receiptSummaries = [ReceiptSummary]()
                
                // Create Summary Objects from the retured Receipts
                for receiptDictionary in receiptDictionaries {
                    guard let receiptSummary = ReceiptSummary(receiptDictionary: receiptDictionary) else {
                        print ("Did not instantiate ReceiptSummary for dictionary: \(receiptDictionary)")
                        continue
                    }
                    
                    receiptSummaries.append(receiptSummary)
                }
                
                callback(receiptSummaries)
            }
        }
    }
    
    func postReceipt(_ parameters: [String: AnyObject], _ callback: @escaping (ReceiptSummary?) -> Void) {
        Alamofire.request(receiptUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if let json = response.result.value {
                let receiptDictionary = json as! Dictionary<String, Any>
                
                // Create Receipt Object from the returned receipt
                if let receiptSummary = ReceiptSummary(receiptDictionary: receiptDictionary) {
                    callback(receiptSummary)
                } else {
                    print("Did not instatiate Receipt for dictionary: \(receiptDictionary)")
                    callback(nil)
                }
            }
        }
    }
    
    func getSampleReceiptSummaries() -> [ReceiptSummary] {
        // Create Receipt Summary Objects
        guard let summary1 = ReceiptSummary(id: 1, vendorName: "Walmart", date: "01/26/19", total: "25.32") else {
            fatalError("Unable to instatiate summary1")
        }
        guard let summary2 = ReceiptSummary(id: 2, vendorName: "Winco", date: "01/12/19", total: "132.23") else {
            fatalError("Unable to instatiate summary2")
        }
        guard let summary3 = ReceiptSummary(id: 3, vendorName: "Walmart", date: "01/13/19", total: "20.12") else {
            fatalError("Unable to instatiate summary3")
        }
        
        // Add summaries to the receiptSummaries Array
        return [summary1, summary2, summary3]
    }
}
