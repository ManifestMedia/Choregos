//
//  ExpensesTableViewHeaderCell.swift
//  Choregos
//
//  Created by Šimun on 01.11.2015..
//  Copyright © 2015. Manifest Media ltd. All rights reserved.
//

import UIKit

class ExpensesTableViewHeaderCell: UITableViewCell {

    @IBOutlet weak var totalSum: UILabel!
    @IBOutlet weak var deleteAllRecordsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        deleteAllRecordsButton.hidden = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func deleteAllExpenses(sender: AnyObject) {
        
    }
}
