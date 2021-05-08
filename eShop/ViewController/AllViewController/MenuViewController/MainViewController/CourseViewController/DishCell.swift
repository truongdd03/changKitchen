//
//  DishCell.swift
//  eShop
//
//  Created by Dong Truong on 5/6/21.
//

import UIKit

class DishCell: UITableViewCell {

    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var dishPriceLabel: UILabel!
    
    var dish: Dish? {
        didSet {
            if let dish = dish {
                dishNameLabel.text = dish.name
                dishPriceLabel.text = "$\(dish.price)"
            }
        }
    }
}
