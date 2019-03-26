//
//  ReceiptsTableViewController.swift
//  Receipt Tracker
//
//  Created by Scott Nicholes on 3/14/19.
//  Copyright © 2019 Scott Nicholes. All rights reserved.
//

import UIKit

class ReceiptsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    var receiptSummaries = [ReceiptSummary]()
    let model = ReceiptModel()
    
    // MARK: Outlets
    @IBOutlet var ReceiptsView: UIView!
    @IBOutlet var receiptsTableView: UITableView!
    @IBOutlet weak var buttonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the Delegates
        self.receiptsTableView.delegate = self
        self.receiptsTableView.dataSource = self
        
        // Get the Receipt Summaries
        model.getReceiptSummaries() { (receiptSummaries) -> Void in
            self.receiptSummaries = receiptSummaries
            self.receiptsTableView.reloadData()
        }
    }
    
    // MARK: - TableViewDataSource delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    // MARK: Actions
    @IBAction func unwindToReceiptList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddReceiptViewController {
            let receiptSummary = sourceViewController.receiptSummary
            let newIndexPath = IndexPath(row: receiptSummaries.count, section: 0)
            receiptSummaries.append(receiptSummary)
            receiptsTableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }

}
