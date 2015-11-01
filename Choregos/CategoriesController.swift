//
//  CategoriesController.swift
//  Choregos
//
//  Created by Šimun on 30.10.2015..
//  Copyright © 2015. Manifest Media ltd. All rights reserved.
//

import UIKit

class CategoriesController: UIViewController {
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    var colors: [UIColor] = [
        UIColor(red: 164/255, green: 3/255,   blue: 111/255, alpha: 1.0),
        UIColor(red: 4/255,   green: 139/255, blue: 168/255, alpha: 1.0),
        UIColor(red: 22/255,  green: 219/255, blue: 147/255, alpha: 1.0),
        UIColor(red: 239/255, green: 234/255, blue: 90/255, alpha: 1.0),
        UIColor(red: 242/255, green: 158/255, blue: 76/255, alpha: 1.0),
        UIColor(red: 175/255, green: 194/255, blue: 213/255, alpha: 1.0),
        UIColor(red: 107/255, green: 127/255, blue: 215/255, alpha: 1.0),
        UIColor(red: 208/255, green: 52/255, blue: 53/255, alpha: 1.0),

    ]
    
    var categories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = Category.all()
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        categories = Category.all()
        categoriesCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

extension CategoriesController {

    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: (keyboardSize.height-50), right: 0)
            categoriesCollectionView.contentInset = contentInsets
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        categoriesCollectionView.contentInset = contentInsets
    }
}



extension CategoriesController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0 
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let tabBarHeight = self.tabBarController!.tabBar.frame.size.height
        let collectionViewHeight = self.view.frame.size.height - tabBarHeight 
        let cellHeight = collectionViewHeight / 4
        let cellWidth = self.view.frame.size.width / 2
        return CGSizeMake(cellWidth, cellHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CategoryCell", forIndexPath: indexPath) as! CategoryCollectionViewCell
        let category = categories[indexPath.row]
    
        cell.backgroundColor = NSKeyedUnarchiver.unarchiveObjectWithData(category.color!) as? UIColor
        cell.inactiveCategoryView.hidden = category.isActive as! Bool
        cell.categoryTextfField.text = category.name
        cell.categoryTextfField.tag = indexPath.row
        cell.categoryTextfField.delegate = self
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CategoryCollectionViewCell
        let category = categories[indexPath.row]
        toggleActiveCell(cell, category: category)
    }

}

extension CategoriesController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let category: Category = categories[textField.tag]
        category.name = textField.text!
        category.save()
        textField.resignFirstResponder()
        return true
    }
}

extension CategoriesController {

    func toggleActiveCell(cell: CategoryCollectionViewCell, category: Category) {
        let categoryActive = category.isActive as! Bool

        category.isActive = !categoryActive as NSNumber
        category.save()
        
        cell.inactiveCategoryView.hidden = !categoryActive
    }
}
