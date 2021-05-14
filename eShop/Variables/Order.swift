//
//  Order.swift
//  eShop
//
//  Created by Dong Truong on 5/13/21.
//

import UIKit

class Order: NSObject {
    var orders = [orderedDish]()
    var id = ""
    var total = 0.0
    
    init(orders: [orderedDish], id: String, total: Double) {
        self.orders = orders
        self.id = id
        self.total = total
    }
}
