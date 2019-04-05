//
//  ReceiptsTableViewController.swift
//  Receipt Tracker
//
//  Created by Scott Nicholes on 3/14/19.
//  Copyright © 2019 Scott Nicholes. All rights reserved.
//

import UIKit
import os

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
        
        // Provide an edit button at the top left of the navController
        navigationItem.leftBarButtonItem = editButtonItem
        
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
    
    // MARK: - TableViewDelegate methods
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
        
        // Format the total for money display
        receiptSummary.total.insert("$", at: receiptSummary.total.startIndex)
        cell.total.text = receiptSummary.total
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedReceiptSummary = receiptSummaries[indexPath.row]
        
        // Get the Receipt for this ReceiptSummary
        model.getReceipt(receiptId: selectedReceiptSummary.id!) { (_ receipt: Receipt?) -> Void in
            if let receipt = receipt {
                self.performSegue(withIdentifier: "showReceiptDetail", sender: receipt)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            receiptSummaries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        receiptsTableView.setEditing(editing, animated: true)
    }
    
    // MARK: Actions
    @IBAction func unwindToReceiptList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddReceiptViewController {
            if let receipt = sourceViewController.receipt {
                if let selectedIndexPath = receiptsTableView.indexPathForSelectedRow {
                    // Update an existing meal
                    let parameters: [String: AnyObject] = [
                        "id": receipt.id! as AnyObject,
                        "vendorName": receipt.vendorName as AnyObject,
                        "date": receipt.date as AnyObject,
                        "total": receipt.total as AnyObject
                    ]
                    
                    model.updateReceipt(receipt.id!, parameters) { (_ receiptSummary: ReceiptSummary?) in
                        if let receiptSummary = receiptSummary {
                            self.receiptSummaries[selectedIndexPath.row] = receiptSummary
                            self.receiptsTableView.reloadRows(at: [selectedIndexPath], with: .none)
                        }
                        
                        self.receiptsTableView.deselectRow(at: selectedIndexPath, animated: true)
                    }
                } else {
                    // Make a POST request to save the receipt
                    // Create parameters from Receipt Object
                    let parameters: [String: AnyObject] = [
                        "vendorName": receipt.vendorName as AnyObject,
                        "date": receipt.date as AnyObject,
                        "total": receipt.total as AnyObject
                    ]
                    
                    model.postReceipt(parameters) { (_ receipt: Receipt?) in
                        if let receipt = receipt {
                            // Create a receiptSummary from the receipt in the sourceViewController
                            if let receiptSummary = ReceiptSummary(id: receipt.id!, vendorName: receipt.vendorName, date: receipt.date, total: receipt.total) {
                                // Insert a new Receipt Summary into the table
                                let newIndexPath = IndexPath(row: self.receiptSummaries.count, section: 0)
                                self.receiptSummaries.append(receiptSummary)
                                self.receiptsTableView.insertRows(at: [newIndexPath], with: .automatic)
                            } else {
                                os_log("Did not instatiate new ReceiptSummary for receipt", log: OSLog.default, type: .debug)
                            }
                        }
                    }
                }
            } else {
                os_log("Source View Controller Receipt was nil", log: OSLog.default, type: .debug)
            }
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "addReceipt":
            os_log("Opening Add Receipt View", log: OSLog.default, type: .debug)
        case "showReceiptDetail":
            guard let receiptDetailViewController = segue.destination as? AddReceiptViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let receipt = sender as? Receipt else {
                fatalError("Unexpected Sender type: \(sender)")
            }
            
            // Remove the '$' character from the total
            receipt.total = String(receipt.total.suffix(receipt.total.count - 1))
            
            receiptDetailViewController.receipt = receipt
        default:
            fatalError("Unexpected Segue Identifier: \(segue.identifier)")
        }
        
    }

}
