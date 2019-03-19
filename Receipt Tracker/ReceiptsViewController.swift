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
    @IBOutlet var ReceiptsView: UIView!
    @IBOutlet var receiptsTableView: UITableView!
    @IBOutlet weak var buttonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the Delegates
        self.receiptsTableView.delegate = self
        self.receiptsTableView.dataSource = self
        
        fetchReceiptSummaries()
    }

}
