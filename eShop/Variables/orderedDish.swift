//
//  orderedDish.swift
//  eShop
//
//  Created by Dong Truong on 5/13/21.
//

import UIKit

class orderedDish: NSObject {
    var id: String
    var quantity: Double {
        didSet {
            self.total = self.quantity * self.price
        }
    }
    var price: Double
    var note: String?
    var total: Double {
        didSet {
            self.total = round(self.total * 100) / 100
        }
    }
    
    init(id: String, quantity: Double, price: Double) {
        self.id = id
        self.quantity = quantity
        self.price = price
        self.total = self.quantity * self.price
    }
}
