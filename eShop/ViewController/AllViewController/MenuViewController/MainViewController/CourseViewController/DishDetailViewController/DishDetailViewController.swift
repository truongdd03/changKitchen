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
    
    var dish = Dish(name: "", price: 0, quantity: 0, note: nil, image: nil)
    var date: String?
    var totalPrice = 0.0
    var quantity = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setUp()
    }

    func setUp() {
        totalPriceLabel.text = "$0.0"
        dishNameLabel.text = dish.name
        quantityInCart.text = "In Cart: \(Int(dish.quantity))"

        noteTextView.layer.borderWidth = 1
        noteTextView.layer.borderColor = UIColor.init(white: 0, alpha: 0.08).cgColor
        noteTextView.text = dish.note
        
        Utilities.styleFilledButton(addButton)
    }

    @IBAction func quantityFieldDidEdit(_ sender: Any) {
        if let tmp = Int((sender as! UITextField).text ?? "0") {
            quantity += Double(tmp)
            totalPrice = quantity * dish.price
            totalPriceLabel.text = "$\(totalPrice)"
        }
    }
        
    func updateDish() {
        var isNew = false
        if dish.quantity == 0 { isNew = true }
        
        dish.quantity += quantity
        dish.total = totalPrice
        dish.note = noteTextView.text
        
        if isNew {
            chosenDishes.append(dish)
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        if totalPrice == 0 { return }
        
        updateDish()
        
        noteTextView.text = ""
        quantityField.text = ""
        totalPriceLabel.text = "$0.0"
        quantityInCart.text = "In Cart: \(Int(dish.quantity))"
        
        if date != "Today" {
            preOrder()
            return
        }
        
        let ac = UIAlertController(title: "Added to cart!", message: "Is that all?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "No", style: .default, handler: { [weak self] action in
            self?.navigationController?.popViewController(animated: true)
        }))
        ac.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { [weak self] action in
            self?.tabBarController?.selectedIndex = 2
            self?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }))

        present(ac, animated: true)
    }
    
    // Upload demand
    func preOrder() {
        //var dateOrder = date
        //var dishOrder = dish
    }
}
