//
//  ReceiptTableViewCell.swift
//  Receipt Tracker
//
//  Created by Scott Nicholes on 3/14/19.
//  Copyright © 2019 Scott Nicholes. All rights reserved.
//

import UIKit

class ReceiptTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var total: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
