//
//  ReceiptSummaryHandling.swift
//  Receipt Tracker
//
//  Created by Scott Nicholes on 3/15/19.
//  Copyright © 2019 Scott Nicholes. All rights reserved.
//

import Foundation

protocol ReceiptSummaryFetches: AnyObject {
    func fetchReceiptSummaries() -> Void
}
