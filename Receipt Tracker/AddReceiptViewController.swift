//
//  AddReceiptViewController.swift
//  Receipt Tracker
//
//  Created by Scott Nicholes on 3/22/19.
//  Copyright © 2019 Scott Nicholes. All rights reserved.
//

import UIKit
import os.log

enum ReceiptVariable {
    case vendorName
    case total
    case date
    case items
}

class AddReceiptViewController: UIViewController, ReceiptInputTableViewControllerDelegate {
    // MARK: Properties
    var receiptSummary = ReceiptSummary()
    var receiptModel = ReceiptModel()
    
    // MARK: Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addReceiptButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
    }
    
    // MARK: ReceiptInputTableViewControllerDelegate Methods
    func update(_ variable: ReceiptVariable, _ with: String) {
        switch variable {
        case .vendorName:
            receiptSummary.vendorName = with
        case .total:
            receiptSummary.total = with
        case .date:
            receiptSummary.date = with
        default:
            break
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if (segue.identifier == "receiptInputTableViewEmbed") {
            let receiptInputTableViewController = segue.destination as! ReceiptInputTableViewController
            receiptInputTableViewController.delegate = self
            return
        }
        
        guard let button = sender as? UIButton, button === addReceiptButton else {
            os_log("The Add Receipt Button was not pressed.  Cancelling...", log: OSLog.default, type: .debug)
            return
        }
        
        // Make a POST request to save the receipt
        postReceipt { (_ receiptSummary: ReceiptSummary?) in
            if let receiptSummary = receiptSummary {
                self.receiptSummary = receiptSummary
            }
        }
    }
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Private Functions
    private func postReceipt(_ callback: @escaping(ReceiptSummary?) -> Void) {
        // Create parameters from Receipt Object
        let parameters: [String: AnyObject] = [
            "vendorName": receiptSummary.vendorName as AnyObject,
            "date": receiptSummary.date as AnyObject,
            "total": receiptSummary.total as AnyObject
        ]
        
        receiptModel.postReceipt(parameters) { (_ receiptSummary: ReceiptSummary?) in
            callback(receiptSummary)
        }
    }

}
