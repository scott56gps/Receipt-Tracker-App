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
    var receiptSummary: ReceiptSummary?
    
    // MARK: Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addReceiptButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        receiptSummary = ReceiptSummary()
    }
    
    // MARK: ReceiptInputTableViewControllerDelegate Methods
    func update(_ variable: ReceiptVariable, _ with: String) {
        print(with)
        switch variable {
        case .vendorName:
            receiptSummary?.vendorName = with
        case .total:
            receiptSummary?.total = with
        case .date:
            receiptSummary?.total = with
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
        
        // Gather the input data
        
    }

}
