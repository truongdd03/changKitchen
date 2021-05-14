//
//  ChosenDishCell.swift
//  eShop
//
//  Created by Dong Truong on 5/7/21.
//

import UIKit

class ChosenDishCell: UITableViewCell {
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    var delegate: UpdateTotalPriceProtocol!

    var id = 0 {
        didSet {
            showLabel()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        showLabel()
    }

    @IBAction func reduceTapped(_ sender: Any) {
        if allOrders[date]!.orders[id].quantity == 0 { return }
        
        allOrders[date]!.orders[id].quantity -= 1
        showLabel()

        delegate.calculateTotal()
    }
    
    @IBAction func addTapped(_ sender: Any) {
        allOrders[date]!.orders[id].quantity += 1
        showLabel()
        
        delegate.calculateTotal()
    }

    func showLabel() {
        let orderedDish = allOrders[date]!.orders[id]
        let dish = allDishes[orderedDish.id]!
        dishNameLabel.text = dish.name
        priceLabel.text = "$\(dish.price)"
        quantityLabel.text = "\(Int(orderedDish.quantity))"
        totalLabel.text = "$\(orderedDish.total)"
    }
}
