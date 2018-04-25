//
//  DataManager.swift
//  JustDoIt
//
//  Created by iem on 30/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import Foundation
import CoreData

class DataManager{
    
    static let sharedInstance = DataManager()
    
    var documentDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    var dataFileUrl: URL {
        return documentDirectory.appendingPathComponent("lists").appendingPathExtension("json")
    }
    
    var context: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    var cashedCategories = [Category]()
    
    private init() {
        loadData()
    }
    
    func filter(searchText: String, category: Category) -> Array<Item>{
        
        var items: [Item]! = nil
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        var predicates = [NSPredicate]()
        
        if searchText.count > 0{
            let predicateText = NSPredicate(format: "text contains[cd] %@", searchText)
            
            if category.title != "All"{
                let predicateCategory = NSPredicate(format: "%K == %@",#keyPath(Item.category) , category)
                  predicates.append(predicateCategory)
            }
            
            predicates.append(predicateText)
            
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        do{
            items = try context.fetch(fetchRequest)
        }catch{
            debugPrint("Could not load the items from CoreData")
        }
        return items
//        return DataManager.sharedInstance.cachedItems.filter({( item : Item) -> Bool in
//            return item.text!.lowercased().contains(searchText.lowercased())
//        })
    }
    
    func delete(object: NSManagedObject){
        context.delete(object)
        saveData();
    }
    
    func saveData(){
        saveContext()
    }
    
    func loadData(){
        
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            self.cashedCategories = try context.fetch(fetchRequest)
        }catch{
            debugPrint("Could not load the items from CoreData")
        }
    }
    
    func saveCategory(category: Category, item: Item? = nil){
        let index = self.cashedCategories.index(where: {$0 === category})
        category.dateModif = Date()
        if (item != nil) {
            item?.dateModif = Date()
        }
        self.cashedCategories[index!] = category
        saveData()
    }
    
    // MARK: - Core Data stack
    
var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "JustDoIt")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
