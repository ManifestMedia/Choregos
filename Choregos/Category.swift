//
//  Cateogry.swift
//  Choregos
//
//  Created by Šimun on 31.10.2015..
//  Copyright © 2015. Manifest Media ltd. All rights reserved.
//

import UIKit
import Foundation
import CoreData


class Category: NSManagedObject {
    
    @NSManaged var color: NSData?
    @NSManaged var name: String?
    @NSManaged var isActive: NSNumber?
    @NSManaged var expenses: NSSet?
    
    static let staticEntityName: String = "Category"
    static let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    convenience init() {
        let entity = NSEntityDescription.entityForName(Category.staticEntityName, inManagedObjectContext: Category.context)
        self.init(entity: entity!, insertIntoManagedObjectContext: Category.context)
    }
    
    convenience init(withData data: [String: AnyObject]){
        self.init()
        name     = data["name"] as! String?
        isActive = data["isActive"] as! Bool?
        color    = NSKeyedArchiver.archivedDataWithRootObject(data["color"]!)
    }
    
    func save() {
        let context = Category.context
        do {
            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    class func active() -> [Category] {
        let fetchRequest = NSFetchRequest(entityName: staticEntityName)
        let predicate = NSPredicate(format: "isActive ==true")
        var categories: [Category] = []
        
        fetchRequest.predicate = predicate
        if let fetchResults = (try? context.executeFetchRequest(fetchRequest)) as? [Category] {
            categories = fetchResults
        }
        
        if categories.count > 0 {
            return categories
        }
        else {
            return []
        }
    }

    
    class func create(withdata data: [String: AnyObject]) -> Category {
        let newCategory =  NSEntityDescription.insertNewObjectForEntityForName(staticEntityName, inManagedObjectContext: context) as! Category
        newCategory.name     = data["name"] as! String?
        newCategory.isActive = data["isActive"] as! Bool?
        newCategory.color    = NSKeyedArchiver.archivedDataWithRootObject(data["color"]!)
        return newCategory
    }
    
    
    class func all() -> [Category] {
        let fetchRequest = NSFetchRequest(entityName: staticEntityName)
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        var categories: [Category] = []
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let fetchResults = (try? context.executeFetchRequest(fetchRequest)) as? [Category] {
            categories = fetchResults
        }
        return categories
    }
}
