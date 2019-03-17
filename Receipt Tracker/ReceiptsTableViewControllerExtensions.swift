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

extension ReceiptsTableViewController {
    // MARK: - TableViewDataSource delegate methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return receiptSummaries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

extension ReceiptsTableViewController: ReceiptSummaryFetches {
    
    // MARK: ReceiptSummaryFetches delegate methods
    func fetchReceiptSummaries() -> [ReceiptSummary] {
        fetchReceipts()
        return loadSampleReceiptSummaries()
    }
    
    // MARK: Private Methods
    private func loadSampleReceiptSummaries() -> [ReceiptSummary] {
        // Create Receipt Summary Objects
        guard let summary1 = ReceiptSummary(vendorName: "Walmart", date: "01/26/19", total: 25.32) else {
            fatalError("Unable to instatiate summary1")
        }
        guard let summary2 = ReceiptSummary(vendorName: "Winco", date: "01/12/19", total: 132.23) else {
            fatalError("Unable to instatiate summary2")
        }
        guard let summary3 = ReceiptSummary(vendorName: "Walmart", date: "01/13/19", total: 20.12) else {
            fatalError("Unable to instatiate summary3")
        }
        
        // Add summaries to the receiptSummaries Array
        return [summary1, summary2, summary3]
    }
    
    private func fetchReceipts() {
        Alamofire.request("https://cs313-receipt-tracker.herokuapp.com/receipts").responseJSON { response in
            print("Result: \(response.result)")
            
            if let json = response.result.value {
                print("JSON: \(json)")
            }
        }
    }
}
