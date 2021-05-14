//
//  Menu.swift
//  eShop
//
//  Created by Dong Truong on 5/8/21.
//

import UIKit

class Menu: NSObject {
    var dishes = [menuDish]()
    var date = ""
    
    init(dishes: [menuDish], date: String) {
        self.dishes = dishes
        self.date = date
    }
}
