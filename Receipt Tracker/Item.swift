//
//  Item.swift
//  Receipt Tracker
//
//  Created by Scott Nicholes on 3/15/19.
//  Copyright © 2019 Scott Nicholes. All rights reserved.
//

import Foundation

class Item {
    var name: String
    var quantity: Int
    var amount: String
    
    init?(name: String, quantity: Int, amount: String) {
        if (name.isEmpty || quantity < 0 || amount.isEmpty) {
            return nil
        }
        
        // Initialize Item Properties
        self.name = name
        self.quantity = quantity
        self.amount = amount
    }
    
    init?(itemDictionary: Dictionary<String, Any>) {
        guard let name = itemDictionary["name"] as? String else {
            return nil
        }
        guard let quantity = itemDictionary["quantity"] as? Int else {
            return nil
        }
        guard let amount = itemDictionary["amount"] as? String else {
            return nil
        }
        
        self.name = name
        self.quantity = quantity
        self.amount = amount
    }
}
