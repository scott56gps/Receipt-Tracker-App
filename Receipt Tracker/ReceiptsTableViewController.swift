//
//  ReceiptsTableViewController.swift
//  Receipt Tracker
//
//  Created by Scott Nicholes on 3/14/19.
//  Copyright © 2019 Scott Nicholes. All rights reserved.
//

import UIKit

class ReceiptsTableViewController: UITableViewController {
    
    // MARK: Properties
    var receiptSummaries = [ReceiptSummary]()
    @IBOutlet var receiptsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchReceiptSummaries()
    }

}
