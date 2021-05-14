//
//  menuDish.swift
//  eShop
//
//  Created by Dong Truong on 5/12/21.
//

import UIKit

class menuDish: NSObject {
    var id: String
    var name: String
    var price: Double
    var courseType: String
    var image: UIImage?
    
    init(name: String, price: Double, image: UIImage?, courseType: String, id: String) {
        self.name = name
        self.price = price
        self.image = image
        self.courseType = courseType
        self.id = id
    }
}
