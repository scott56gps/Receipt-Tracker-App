//
//  ReceiptInputTableViewController.swift
//  Receipt Tracker
//
//  Created by Scott Nicholes on 3/25/19.
//  Copyright © 2019 Scott Nicholes. All rights reserved.
//

import UIKit

/**
 * ReceiptInputTableViewControllerDelegate
 * AnyObject adopting this protocol must implement the following functionality
 */
protocol ReceiptInputTableViewControllerDelegate: AnyObject {
    func update(_ variable: ReceiptVariable, _ with: String)
}

class ReceiptInputTableViewController: UITableViewController, UITextFieldDelegate {
    // MARK: Properties
//    var receipt = Receipt()
    weak var delegate: ReceiptInputTableViewControllerDelegate?
    
    // MARK: Outlets
    @IBOutlet weak var vendorNameTextField: UITextField!
    @IBOutlet weak var totalTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vendorNameTextField.delegate = self
        totalTextField.delegate = self
        
        // Set initial date to the receipt, if there is any
//        let initialDate = dateToISOString(date: datePicker.date)
//        delegate?.update(.date, initialDate)
    }
    
    // UITableViewDelegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            vendorNameTextField.becomeFirstResponder()
        } else if (indexPath.section == 1) {
            totalTextField.becomeFirstResponder()
        } else if (indexPath.section == 2) {
            datePicker.becomeFirstResponder()
        }
    }
    
    // UITextFieldDelegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let addReceiptViewController = self.parent as? AddReceiptViewController {
            addReceiptViewController.addReceiptButton.isEnabled = false
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let addReceiptViewController = self.parent as? AddReceiptViewController {
            addReceiptViewController.updateSaveButtonState()
        }
        
        // Update the appropriate variable
        if (textField === vendorNameTextField) {
            // Update the vendorName
            if let vendorName = textField.text {
                delegate?.update(.vendorName, vendorName)
            }
        } else if (textField === totalTextField) {
            // Update the total
            if let total = textField.text {
                delegate?.update(.total, total)
            }
        }
    }
    
    // MARK: Actions
    @IBAction func dateWasPicked(_ sender: UIDatePicker) {
        let dateString = dateToISOString(date: sender.date)

        delegate?.update(.date, dateString)
    }
    
    // MARK: Private Functions
    private func dateToISOString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
