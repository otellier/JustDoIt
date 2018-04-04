//
//  DataManager.swift
//  JustDoIt
//
//  Created by iem on 30/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import Foundation

class DataManager{
    
    static let sharedInstance = DataManager()
    
    var documentDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    var dataFileUrl: URL {
        return documentDirectory.appendingPathComponent("lists").appendingPathExtension("json")
    }
    
    var cachedItems = Array<Item>()
    
    private init() {
        loadListItems()
    }
    
    func filter(searchText: String) -> Array<Item>{
        return DataManager.sharedInstance.cachedItems.filter({( item : Item) -> Bool in
            return item.text.lowercased().contains(searchText.lowercased())
        })
    }
    
    func saveListItems(){
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(cachedItems)
        print(String(data: data, encoding: .utf8)!)
        try! data.write(to: dataFileUrl)
    }
    
    func loadListItems(){
        if FileManager.default.fileExists(atPath: dataFileUrl.path) {
            let data = try? Data(contentsOf: dataFileUrl)
            let decoder = JSONDecoder()
            let itemsLoaded = try? decoder.decode(Array<Item>.self, from: data!)
            cachedItems = itemsLoaded!
            
        }
    }
    
}
