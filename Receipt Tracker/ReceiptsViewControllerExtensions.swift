//
//  ReceiptsExtensions.swift
//  Receipt Tracker
//
//  Created by Scott Nicholes on 3/15/19.
//  Copyright © 2019 Scott Nicholes. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

extension ReceiptsViewController {
    // MARK: - TableViewDataSource delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return receiptSummaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ReceiptTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ReceiptTableViewCell else {
            fatalError("The dequed cell is not an instance of ReceiptTableViewCell")
        }
        
        // Get the ReceiptSummary at the indexedPath of the cell
        let receiptSummary = receiptSummaries[indexPath.row]
        
        // Map the ReceiptSummary Data Object onto the cell
        cell.name.text = receiptSummary.vendorName
        cell.date.text = receiptSummary.date
        cell.total.text = String(receiptSummary.total)
        
        return cell
    }
}

extension ReceiptsViewController: ReceiptSummaryFetches {
    
    // MARK: ReceiptSummaryFetches delegate methods
    func fetchReceiptSummaries() -> Void {
        getReceiptSummaries() { (fetchedReceiptSummaries) -> Void in
            self.receiptSummaries = fetchedReceiptSummaries
            self.receiptsTableView.reloadData()
        }
    }
    
    // MARK: Private Methods
    private func loadSampleReceiptSummaries() -> [ReceiptSummary] {
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
    
    private func requestReceiptSummaries(_ callback: @escaping ([Dictionary<String, Any>]) -> Void) {
        Alamofire.request("https://cs313-receipt-tracker.herokuapp.com/receipts").responseJSON { response in
            print("Result: \(response.result)")
            
            if let json = response.result.value {
                print("JSON: \(json)")
                
                let receiptDictionaries = json as! [Dictionary<String, Any>]
                
                callback(receiptDictionaries)
            }
        }
    }
    
    private func getReceiptSummaries(_ callback: @escaping ([ReceiptSummary]) -> Void) -> Void {
        // Get the ReceiptSummaries
        var fetchedReceiptSummaries = [ReceiptSummary]()
        requestReceiptSummaries() { (receiptDictionaries) -> Void in
            // Create Summary Objects from the retured Receipts
            for receiptDictionary in receiptDictionaries {
                guard let receiptSummary = ReceiptSummary(receiptDictionary: receiptDictionary) else {
                    print ("Did not instantiate ReceiptSummary for dictionary: \(receiptDictionary)")
                    continue
                }
                
                fetchedReceiptSummaries.append(receiptSummary)
            }
            
            callback(fetchedReceiptSummaries)
        }
    }
}