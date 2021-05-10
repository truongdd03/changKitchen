//
//  Menu.swift
//  eShop
//
//  Created by Dong Truong on 5/8/21.
//

import UIKit

class Menu: NSObject {
    var courses = [Course]()
    var date = ""
    
    init(courses: [Course], date: String) {
        self.courses = courses
        self.date = date
    }
}
