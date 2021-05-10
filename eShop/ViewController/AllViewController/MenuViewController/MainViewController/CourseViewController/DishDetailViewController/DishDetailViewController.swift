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
    
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var dishPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var noteTextView: UITextView!
    
    var dish = Dish(name: "", price: 0, quantity: 0, note: nil)
    var date: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setUp()
    }

    func setUp() {
        totalPriceLabel.text = "$0.0"
        dishNameLabel.text = dish.name

        noteTextView.layer.borderWidth = 1
        noteTextView.layer.borderColor = UIColor.init(white: 0, alpha: 0.08).cgColor
        
        Utilities.styleFilledButton(addButton)
    }

    @IBAction func quantityFieldDidEdit(_ sender: Any) {
        if let tmp = Int((sender as! UITextField).text ?? "0") {
            dish.quantity = Double(tmp)
            dish.total = dish.quantity * dish.price
            totalPriceLabel.text = "$\(dish.total)"
        }
    }
        
    @IBAction func addButtonTapped(_ sender: Any) {
        if dish.total == 0 { return }
        dish.note = noteTextView.text
        chosenDishes.append(dish)
        noteTextView.text = ""
        quantityField.text = ""
        
        if date != "Today" {
            preOrder()
            return
        }
        
        let ac = UIAlertController(title: "Added to cart!", message: "Is that all?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "No", style: .default, handler: { [weak self] action in
            self?.navigationController?.popViewController(animated: true)
        }))
        ac.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { [weak self] action in
            //let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            //let vc = storyBoard.instantiateViewController(identifier: "CartViewController") as! CartViewController
            //self?.navigationController?.pushViewController(vc, animated: true)
            self?.tabBarController?.selectedIndex = 2
            self?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }))

        present(ac, animated: true)
    }
    
    // Upload demand
    func preOrder() {
        var dateOrder = date
        var dishOrder = dish
    }
}
