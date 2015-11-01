//
//  Expense.swift
//  Choregos
//
//  Created by Šimun on 31.10.2015..
//  Copyright © 2015. Manifest Media ltd. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Expense: NSManagedObject {

    @NSManaged var title: String?
    @NSManaged var amount: String?
    @NSManaged var category: Category?
    @NSManaged var onDate: NSDate?
    
    static let staticEntityName: String = "Expense"
    static let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    convenience init() {
        let entity = NSEntityDescription.entityForName(Expense.staticEntityName, inManagedObjectContext: Expense.context)
        self.init(entity: entity!, insertIntoManagedObjectContext: Expense.context)
    }
    
    convenience init(withData data: [String: AnyObject]){
        self.init()
        title     = data["title"] as! String?
        amount =  data["amount"] as! String?
        category = data["category"] as? Category
        onDate = NSDate()
    }
    
    func save() {
        let context = Expense.context
        do {
            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    func remove() {
        let context = Expense.context
        context.deleteObject(self as NSManagedObject)
        do {
            try context.save()
        } catch _ {}

    }
    
    class func create(withdata data: [String: AnyObject]) -> Expense {
        let newExpense =  NSEntityDescription.insertNewObjectForEntityForName(staticEntityName, inManagedObjectContext: context) as! Expense
        newExpense.title     = data["title"] as! String?
        newExpense.amount =  data["amount"] as! String?
        newExpense.category = data["category"] as? Category
        newExpense.onDate = NSDate()
        return newExpense
    }
    
    
    class func all() -> [Expense] {
        let fetchRequest = NSFetchRequest(entityName: staticEntityName)
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        var expenses: [Expense] = []
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let fetchResults = (try? context.executeFetchRequest(fetchRequest)) as? [Expense] {
            expenses = fetchResults
        }
        return expenses
    }
    
    class func deleteAll() {
        var expenses = all()
        for expense in expenses {
            context.deleteObject(expense as NSManagedObject)
        }
        expenses.removeAll(keepCapacity: false)
        do {
            try context.save()
        } catch _ {}
    }
    
    class func active() -> [Expense] {
        let fetchRequest = NSFetchRequest(entityName: staticEntityName)
        let predicate = NSPredicate(format: "category.isActive == true")
        var expenses: [Expense] = []

        fetchRequest.predicate = predicate
        if let fetchResults = (try? context.executeFetchRequest(fetchRequest)) as? [Expense] {
            expenses = fetchResults
        }

        if expenses.count > 0 {
            return expenses
        }
        else {
            return []
        }
    }
    
    class func total(filterActive: Bool) -> Float? {
        var expenses: [Expense] = []
        var totalSum: Float? = 0.0
        if filterActive {
            expenses = active()
        }
        else {
            expenses = all()
        }
        
        for expense in expenses {
            let number = NSNumberFormatter().numberFromString(expense.amount!)
            if let number = number {
                let floatValue = Float(number)
                totalSum = totalSum! + floatValue
            }
        }
        return totalSum
    }
}
