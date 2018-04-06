//
//  Category.swift
//  JustDoIt
//
//  Created by iem on 06/04/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import Foundation

class Category {
    var title: String
    var items = Array<Item>()
    var dateCreation = Date()
    var dateModif =  Date()
    init(title: String, tasks: Array<Item> = Array<Item>()){
        self.title=title
        self.items=tasks
    }
}

extension Category {
    var uncheckedItemsCount: Int{
        return items.filter{!$0.checked}.count
    }
}
