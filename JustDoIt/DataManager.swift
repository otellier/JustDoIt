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
    
    var cachedItems = [Item]()
    
    private init() {
        loadListItems()
    }
    
    func filter(searchText: String) -> Array<Item>{
        return DataManager.sharedInstance.cachedItems.filter({( item : Item) -> Bool in
            return item.text!.lowercased().contains(searchText.lowercased())
        })
    }
    
    func saveListItems(){
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        let data = try! encoder.encode(cachedItems)
//        print(String(data: data, encoding: .utf8)!)
//        try! data.write(to: dataFileUrl)
        saveContext()
    }
    
    func loadListItems(){
//        if FileManager.default.fileExists(atPath: dataFileUrl.path) {
//            let data = try? Data(contentsOf: dataFileUrl)
//            let decoder = JSONDecoder()
//            let itemsLoaded = try? decoder.decode(Array<Item>.self, from: data!)
//            cachedItems = itemsLoaded!
            
        //}
        
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
