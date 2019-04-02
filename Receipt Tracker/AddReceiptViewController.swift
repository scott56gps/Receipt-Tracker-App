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
    var receipt: Receipt?
    var receiptModel = ReceiptModel()
    var receiptInputTableViewController: ReceiptInputTableViewController?
    
    // MARK: Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addReceiptButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Populate the UI with the values from the receipt, if any exists
        if let receipt = self.receipt {
            addReceiptButton.setTitle("Update Receipt", for: .normal)
            if (receiptInputTableViewController != nil) {
                receiptInputTableViewController?.vendorNameTextField.text = receipt.vendorName
                receiptInputTableViewController?.totalTextField.text = String(receipt.total.suffix(receipt.total.count - 1)) // To account for '$'
                if let receiptDate = ISOStringToDate(isoString: receipt.date) {
                    receiptInputTableViewController?.datePicker.date = receiptDate
                } else {
                    receiptInputTableViewController?.datePicker.date = Date()
                }
            } else {
                // We have a new Receipt to be edited
                self.receipt = Receipt()
                receiptInputTableViewController?.datePicker.date = Date()
            }
        }
        
        // Enable the Add Receipt Button only if there is text in vendorNameTextField
        updateSaveButtonState()
    }
    
    // MARK: ReceiptInputTableViewControllerDelegate Methods
    func update(_ variable: ReceiptVariable, _ with: String) {
        switch variable {
        case .vendorName:
            receipt!.vendorName = with
        case .total:
            receipt!.total = with
        case .date:
            receipt!.date = with
        default:
            break
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "receiptInputTableViewEmbed":
            let receiptInputTableViewController = segue.destination as! ReceiptInputTableViewController
            receiptInputTableViewController.delegate = self
            
            self.receiptInputTableViewController = receiptInputTableViewController
        case "AddReceiptUnwindSegue":
            print(segue.identifier!)
            guard let button = sender as? UIButton, button === addReceiptButton else {
                os_log("The Add Receipt Button was not pressed.  Cancelling...", log: OSLog.default, type: .debug)
                return
            }
        default:
            fatalError("Unexpected Segue in prepare AddReceiptViewController: \(segue.identifier)")
        }
    }
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Public Functions
    func updateSaveButtonState() {
        // Disable the Add Receipt Button if the vendorName textField is empty
        let text = receiptInputTableViewController?.vendorNameTextField.text ?? ""
        addReceiptButton.isEnabled = !text.isEmpty
    }
    
    // MARK: Private Functions
    private func postReceipt(_ callback: @escaping(Receipt?) -> Void) {
        // Create parameters from Receipt Object
        let parameters: [String: AnyObject] = [
            "vendorName": receipt!.vendorName as AnyObject,
            "date": receipt!.date as AnyObject,
            "total": receipt!.total as AnyObject
        ]
        
        receiptModel.postReceipt(parameters) { (_ receipt: Receipt?) in
            callback(receipt)
        }
    }
    
    private func ISOStringToDate(isoString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: isoString)
    }

}
