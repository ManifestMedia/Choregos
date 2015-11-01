//
//  SpendController.swift
//  Choregos
//
//  Created by Šimun on 29.10.2015..
//  Copyright © 2015. Manifest Media ltd. All rights reserved.
//

import UIKit

class SpendController: UIViewController {

    @IBOutlet weak var spendButton: UIButton!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    var categories: [Category] = []
    var selectedCategory: Category?

    // MARK: Lifecycle
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        spendButton.layer.cornerRadius = 60
        spendButton.clipsToBounds = true
        descriptionTextField.delegate = self
        categoryTextField.delegate = self
        amountTextField.delegate = self

        setInputViewToolbar(amountTextField)
        setInputViewToolbar(categoryTextField)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        setPickerView()
    }
    
    // MARK: Layout
    func setPickerView() {
        categories = Category.active()
        let pickerView: UIPickerView = UIPickerView()
        pickerView.delegate = self
        categoryTextField.inputView?.backgroundColor = UIColor.clearColor()
        categoryTextField.inputView = pickerView
    }
    
    func setInputViewToolbar(inputField: UITextField){
        let toolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("hideInputView"))
        let next: UIBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Done, target: self, action: Selector("nextResponder:"))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil);
        
        switch inputField {
            case categoryTextField:
                let items = [flexibleSpace, done]
                toolbar.items = items
                categoryTextField.inputAccessoryView = toolbar
            break
        default:
            let items = [next, flexibleSpace, done]
            toolbar.items = items
            amountTextField.inputAccessoryView = toolbar
            
        }
    
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

// MARK: User Interaction
extension SpendController {

    @IBAction func spendButonAction(sender: AnyObject) {
        
        if descriptionTextField.text! == "" {
            showAlert()
            return
        }
        
        if amountTextField.text! == "" {
            showAlert()
            return
        }
        
        if selectedCategory == nil {
            showAlert()
            return
        }
        
        let data: [String: AnyObject] = [
            "title":   descriptionTextField.text!,
            "category": selectedCategory!,
            "amount": amountTextField.text!
        ]
        Expense.create(withdata: data).save()
        animateSpendButton()
    }
    
    @IBAction func closeKeyboard(sender: AnyObject) {
        hideInputView()
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}

// MARK: Delegates - Text Fields
extension SpendController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let currentInputTag = textField.tag
        if currentInputTag != 2 {
            nextResponder(textField)
        }
        else {
            hideInputView()
        }
        return true
    }
}

// MARK: Delegates - Category Picker View
extension SpendController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let category: Category = categories[row]
        return category.name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let category: Category = categories[row]
        selectedCategory = category
        categoryTextField.text = category.name
    }
}

//MARK: Helpers
extension SpendController {
    
    func showAlert() {
        let alert = UIAlertController(title: "Empty Field", message: "Please fill in all the fields.", preferredStyle: UIAlertControllerStyle.Alert)
        let dissmisAction = UIAlertAction(title: "Dissmis", style: .Default, handler: nil)
        alert.addAction(dissmisAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func animateSpendButton() {
        let buttonStartY = self.spendButton.frame.origin.y
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.spendButton.frame.origin.y = self.view.frame.size.height
            }) { (completed) -> Void in
                self.spendButton.hidden = true
                self.spendButton.frame.origin.y = buttonStartY
                self.spendButton.transform = CGAffineTransformMakeScale(0.1, 0.1)
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.spendButton.hidden = false
                    self.spendButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    self.amountTextField.text = ""
                    self.descriptionTextField.text = ""
                    self.categoryTextField.text = ""
                })
                
        }
    }
    
    func hideInputView(){
        descriptionTextField.resignFirstResponder()
        categoryTextField.resignFirstResponder()
        amountTextField.resignFirstResponder()
    }
    
    func nextResponder(currentResponder: UITextField!) {
        let currentInputTag = currentResponder.tag
        let nextInputTag = currentInputTag + 1
        let nextResponder: UIResponder = self.view.viewWithTag(nextInputTag)!
        nextResponder.becomeFirstResponder()
    }
}