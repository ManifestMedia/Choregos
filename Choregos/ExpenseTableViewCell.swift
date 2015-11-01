//
//  ExpenseTableViewCell.swift
//  Choregos
//
//  Created by Šimun on 30.10.2015..
//  Copyright © 2015. Manifest Media ltd. All rights reserved.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {


    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
