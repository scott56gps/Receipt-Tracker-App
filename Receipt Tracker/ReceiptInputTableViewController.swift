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
    func updateTextValue(_ variable: ReceiptVariable, _ with: String)
    func updateDateValue(_ date: Date)
}

class ReceiptInputTableViewController: UITableViewController, UITextFieldDelegate {
    // MARK: Properties
    weak var delegate: ReceiptInputTableViewControllerDelegate?
    
    // MARK: Outlets
    @IBOutlet weak var vendorNameTextField: UITextField!
    @IBOutlet weak var totalTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vendorNameTextField.delegate = self
        totalTextField.delegate = self
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
                delegate?.updateTextValue(.vendorName, vendorName)
            }
        } else if (textField === totalTextField) {
            // Update the total
            if let total = textField.text {
                delegate?.updateTextValue(.total, total)
            }
        }
    }
    
    // MARK: Actions
    @IBAction func dateWasPicked(_ sender: UIDatePicker) {
        delegate?.updateDateValue(sender.date)
    }
}
