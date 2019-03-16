//
//  Receipt.swift
//  Receipt Tracker
//
//  Created by Scott Nicholes on 3/15/19.
//  Copyright © 2019 Scott Nicholes. All rights reserved.
//

import Foundation

class Receipt {
    var vendorName: String
    var date: String
    var total: Float
    var items: [Item]?
    
    init?(vendorName: String, date: String, total: Float, items: [Item]?) {
        if (vendorName.isEmpty || date.isEmpty || total < 0) {
            return nil
        }
        
        // Initialize Item Properties
        if (items != nil) {
            self.items = items
        }
        self.vendorName = vendorName
        self.date = date
        self.total = total
    }
}
