//
//  CartViewController.swift
//  eShop
//
//  Created by Dong Truong on 5/7/21.
//

import UIKit

var chosenDishes = [Dish]()
var total = 0.0

protocol UpdateTotalPriceProtocol {
   func calculateTotal()
}

class CartViewController: UITableViewController, UpdateTotalPriceProtocol {
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var tipTextField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
        
    var tax = 0.0 {
        didSet {
            taxLabel.text = "$\(tax)"
        }
    }
    var tip = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fetchData()
        calculateTotal()
        
        title = "Cart"
        taxLabel.text = "$\(tax)"
        Utilities.styleFilledButton(orderButton)
        
        hideKeyboardWhenTappedAround()
        
        let customCell = UINib(nibName: "ChosenDishCell", bundle: nil)
        tableView.register(customCell, forCellReuseIdentifier: "ChosenDishCell")
    }
    
    @IBAction func didEditTip(_ sender: Any) {
        total -= tip
        if let tmp = Double((sender as! UITextField).text ?? "0") {
            tip = tmp
        }
        print(tip)
        total += tip
        calculateTotal()
    }
    
    func fetchData() {
        chosenDishes.removeAll()
        for i in 0...3 {
            chosenDishes.append(Dish(name: "Dish \(i)", price: 1.00, quantity: 1, note: nil))
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chosenDishes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChosenDishCell") as! ChosenDishCell
        cell.id = indexPath.row
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            chosenDishes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            calculateTotal()
        }
    }
    
    func calculateTotal() {
        total = 0
        for dish in chosenDishes {
            total += dish.total
        }
        total += tip
        totalLabel.text = "$\(total)"
    }
    
    @IBAction func orderTapped(_ sender: Any) {
        if total == 0 { return }
        
        let ac = UIAlertController(title: "Are you sure you want to order?", message: "Total cost is $\(total)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] action in
            let vc = self?.storyboard?.instantiateViewController(identifier: "TrackingViewController") as! TrackingViewController
            self?.navigationController?.pushViewController(vc, animated: true)
        }))
        
        present(ac, animated: true)
    }
    
}
