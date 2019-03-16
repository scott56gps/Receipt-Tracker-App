//
//  ReceiptSummary.swift
//  Receipt Tracker
//
//  Created by Scott Nicholes on 3/15/19.
//  Copyright © 2019 Scott Nicholes. All rights reserved.
//

import Foundation

class ReceiptSummary {
    var vendorName: String
    var date: String
    var total: Float
    
    init?(vendorName: String, date: String, total: Float) {
        if (vendorName.isEmpty || date.isEmpty || total < 0) {
            return nil
        }
        
        self.vendorName = vendorName
        self.date = date
        self.total = total
    }
}
