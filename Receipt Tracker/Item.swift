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
    var price: Float
    
    init?(name: String, quantity: Int, price: Float) {
        if (name.isEmpty || quantity < 0 || price < 0) {
            return nil
        }
        
        // Initialize Item Properties
        self.name = name
        self.quantity = quantity
        self.price = price
    }
}
