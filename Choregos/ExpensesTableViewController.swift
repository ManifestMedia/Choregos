//
//  ExpensesTableViewController.swift
//  Choregos
//
//  Created by Šimun on 30.10.2015..
//  Copyright © 2015. Manifest Media ltd. All rights reserved.
//

import UIKit

class ExpensesTableViewController: UITableViewController {
    
    var expenses: [Expense] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expenses = Expense.active()
        self.tableView.backgroundColor = UIColor(red: 193/255, green: 223/255, blue: 240/255, alpha: 1.0)
    }
    
    override func viewWillAppear(animated: Bool) {
        expenses = Expense.active()
        self.tableView.reloadData()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return expenses.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ExpenseCell", forIndexPath: indexPath) as! ExpenseTableViewCell
        let expense: Expense =  expenses[indexPath.row]
        
        cell.amountLabel.text = expense.amount
        cell.categoryLabel.text = expense.category?.name
        cell.descriptionLabel.text = expense.title
        cell.backgroundColor = NSKeyedUnarchiver.unarchiveObjectWithData((expense.category?.color)!) as? UIColor
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! ExpensesTableViewHeaderCell
        header.totalSum.text = String(Expense.total(true)!)
        return header
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let expense: Expense = expenses[indexPath.row]
            expenses.removeAtIndex(indexPath.row)
            expense.remove()
            tableView.reloadData()
        }
    }
    

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
}
