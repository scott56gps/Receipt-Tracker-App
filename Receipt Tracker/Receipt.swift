//
//  Receipt.swift
//  Receipt Tracker
//
//  Created by Scott Nicholes on 3/15/19.
//  Copyright © 2019 Scott Nicholes. All rights reserved.
//

import Foundation

class Receipt {
    var id: Int?
    var vendorName: String
    var date: String
    var total: String
    var items: [Item]?
    
    init() {
        self.id = nil
        self.vendorName = ""
        self.date = ""
        self.total = ""
        self.items = nil
    }
    
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
        let itemsAny = receiptDictionary["items"] as? [Dictionary<String, Any>]
        
        // Format the values for display
        let startIndex = date.index(date.startIndex, offsetBy: 10)
        date.removeSubrange(startIndex...)
        
        total.insert("$", at: total.startIndex)
        
        self.id = id
        
        if (itemsAny != nil) {
            var items: [Item] = []
            
            for itemAny in itemsAny! {
                // Create an Item object from this item dictionary
                guard let item = Item(itemDictionary: itemAny) else {
                    return nil
                }
                items.append(item)
            }
            
            self.items = items
        }
        self.vendorName = vendorName
        self.date = date
        self.total = total
    }
}
