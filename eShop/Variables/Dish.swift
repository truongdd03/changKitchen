//
//  Dish.swift
//  eShop
//
//  Created by Dong Truong on 5/6/21.
//

import UIKit

class Dish: NSObject {
    var name: String
    var price: Double {
        didSet {
            self.total = self.price * self.quantity
        }
    }
    var quantity: Double {
        didSet {
            self.total = self.price * self.quantity
        }
    }
    var note: String?
    //var image: UIImage?
    var total: Double
    
    init(name: String, price: Double, quantity: Double, note: String?, image: UIImage?) {
        self.name = name
        self.price = price
        self.quantity = quantity
        self.note = note
        self.total = self.quantity * self.price
        //self.image = image
    }
}
