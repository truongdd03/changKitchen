//
//  DishDetailViewController.swift
//  eShop
//
//  Created by Dong Truong on 5/7/21.
//

import UIKit

class DishDetailViewController: ViewController {
    // Don't know what the hell is it
    @IBOutlet weak var quantityTextField: UITextField!
    
    @IBOutlet weak var quantityInCart: UILabel!
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var dishPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var noteTextView: UITextView!
    
    var dish = menuDish(name: "", price: 0, image: nil, courseType: "", id: "")
    
    var itemOrdered = orderedDish(id: "", quantity: 0, price: 0)
    var position: Int? = nil
    var prevQuantity = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        itemOrdered = orderedDish(id: "", quantity: 0, price: 0)
        itemOrdered.price = dish.price
        itemOrdered.id = dish.id
        prevQuantity = 0
        position = nil
        
        // Find position of dish in the list of ordered items
        if let orders = allOrders[date]?.orders {
            for i in 0..<orders.count {
                if orders[i].id == dish.id {
                    position = i
                    itemOrdered.quantity = orders[i].quantity
                    itemOrdered.note = orders[i].note
                }
            }
        }
                
        hideKeyboardWhenTappedAround()
        setUp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setUp() {
        totalPriceLabel.text = "$0.0"
        dishNameLabel.text = dish.name
        quantityInCart.text = "In Cart: \(Int(itemOrdered.quantity)) ($\(itemOrdered.total))"
        dishPriceLabel.text = "$\(dish.price)"
        
        itemOrdered.quantity = 0.0
        itemOrdered.total = 0.0

        noteTextView.layer.borderWidth = 1
        noteTextView.layer.borderColor = UIColor.init(white: 0, alpha: 0.08).cgColor
        noteTextView.text = itemOrdered.note
        
        Utilities.styleFilledButton(addButton)
    }

    func updateDish() {
        itemOrdered.note = noteTextView.text
        
        if position == nil {
            if allOrders[date] == nil {
                allOrders[date] = Order(orders: [], id: "", total: 0, pickUpTime: "")
            }
            position = 0
            allOrders[date]!.orders.append(itemOrdered)
            allOrders[date]!.total = itemOrdered.total
            
        } else {
            
            allOrders[date]!.orders[position!].quantity += itemOrdered.quantity
            allOrders[date]!.total += itemOrdered.total
        }
    }

    // MARK: Text Field and Buttons
    @IBAction func quantityFieldDidEdit(_ sender: Any) {
        itemOrdered.quantity -= prevQuantity
        
        if let tmp = Double((sender as! UITextField).text ?? "0") {
            itemOrdered.quantity += tmp
            totalPriceLabel.text = "$\(itemOrdered.total)"
            prevQuantity = tmp
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        if itemOrdered.total == 0 { return }
        
        updateDish()
        
        noteTextView.text = ""
        quantityField.text = ""
        totalPriceLabel.text = "$0.0"
        let tmp = allOrders[date]!.orders[position!]
        quantityInCart.text = "In Cart: \(Int(tmp.quantity))(\(tmp.total))"
        
        let ac = UIAlertController(title: "Added to cart!", message: "", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] action in
            self?.navigationController?.popViewController(animated: true)
        }))

        present(ac, animated: true)
    }
}
