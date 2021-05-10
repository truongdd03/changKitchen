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
        if chosenDishes[id].quantity == 0 { return }
        chosenDishes[id].quantity -= 1
        showLabel()
        
        updateTotalLabel()
    }
    
    @IBAction func addTapped(_ sender: Any) {
        chosenDishes[id].quantity += 1
        showLabel()
        
        updateTotalLabel()
    }

    func updateTotalLabel() {
        delegate.calculateTotal()
    }

    func showLabel() {
        let dish = chosenDishes[id]
        dishNameLabel.text = dish.name
        priceLabel.text = "$\(dish.price)"
        quantityLabel.text = "\(Int(dish.quantity))"
        totalLabel.text = "$\(dish.total)"
    }
}
