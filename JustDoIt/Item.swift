//
//  item.swift
//  JustDoIt
//
//  Created by iem on 30/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import Foundation

class Item : Codable {
    var text: String
    var checked:Bool
    
    
    init(text: String, checked:Bool? = false) {
        self.text=text
        self.checked=checked!
    }
    
    func  toggleChecked(){
        checked = !checked
    }
}
