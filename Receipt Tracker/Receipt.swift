//
//  Receipt.swift
//  Receipt Tracker
//
//  Created by Scott Nicholes on 3/15/19.
//  Copyright © 2019 Scott Nicholes. All rights reserved.
//

import Foundation

class Receipt {
    var id: Int
    var vendorName: String
    var date: String
    var total: String
    var items: [Item]?
    
    init?(id: Int, vendorName: String, date: String, total: String, items: [Item]?) {
        if (vendorName.isEmpty || date.isEmpty || total.isEmpty) {
            return nil
        }
        
        // Initialize Object Properties
        self.id = id
        if (items != nil) {
            self.items = items
        }
        self.vendorName = vendorName
        self.date = date
        self.total = total
    }
    
    init?(receiptDictionary: [String : Any]) {
        guard let id = receiptDictionary["id"]! as? Int else {
            return nil
        }
        guard let vendorName = receiptDictionary["vendor_name"]! as? String else {
            return nil
        }
        guard var date = receiptDictionary["date"]! as? String else {
            return nil
        }
        guard var total = receiptDictionary["total"] as? String else {
            return nil
        }
        let items = receiptDictionary["items"] as? [Item]
        
        // Format the values for display
        let startIndex = date.index(date.startIndex, offsetBy: 10)
        date.removeSubrange(startIndex...)
        
        total.insert("$", at: total.startIndex)
        
        self.id = id
        if (items != nil) {
            self.items = items
        }
        self.vendorName = vendorName
        self.date = date
        self.total = total
    }
}
