//
//  CollectionViewCell.swift
//  Choregos
//
//  Created by Šimun on 30.10.2015..
//  Copyright © 2015. Manifest Media ltd. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var categoryTextfField: UITextField!
    @IBOutlet weak var inactiveCategoryView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryTextfField.delegate = self
    }
 }
