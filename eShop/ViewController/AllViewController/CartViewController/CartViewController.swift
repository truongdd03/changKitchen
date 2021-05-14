//
//  CartViewController.swift
//  eShop
//
//  Created by Dong Truong on 5/7/21.
//

import UIKit

protocol UpdateTotalPriceProtocol {
   func calculateTotal()
}

class CartViewController: TableViewController, UpdateTotalPriceProtocol {
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var tipTextField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var trackButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    var tax = 0.0 {
        didSet {
            taxLabel.text = "$\(tax)"
        }
    }
    var tip = 0.0
    var pickUpTime = ""
    
    override func viewWillAppear(_ animated: Bool) {
        calculateTotal()
        setUp()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customCell = UINib(nibName: "ChosenDishCell", bundle: nil)
        tableView.register(customCell, forCellReuseIdentifier: "ChosenDishCell")
    }
    
    func setUp() {
        title = "Cart"
        taxLabel.text = "$\(tax)"
        dateLabel.text = Utilities.reformatDate(date: date)
        
        Utilities.styleFilledButton(orderButton)
        Utilities.styleHollowButton(trackButton)
        
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func didEditTip(_ sender: Any) {
        if let tmp = Double((sender as! UITextField).text ?? "0") {
            tip = tmp
        }
        calculateTotal()
    }
    
    @IBAction func didEditTime(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
        pickUpTime = "\(String(describing: components.hour!))\(String(describing: components.minute!))"
        if pickUpTime.count < 4 {
            pickUpTime = "0" + pickUpTime
        }
        pickUpTime = date + pickUpTime
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allOrders[date]?.orders.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChosenDishCell") as! ChosenDishCell
        cell.id = indexPath.row
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            allOrders[date]!.orders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            calculateTotal()
        }
    }
    
    func calculateTotal() {
        var total = 0.0
        if allOrders[date]?.orders != nil {
            for dish in allOrders[date]!.orders {
                total += dish.total
            }
            total += tip
            allOrders[date]!.total = total
        }
        totalLabel.text = "$\(total)"
    }
    
    @IBAction func orderTapped(_ sender: Any) {
        let total = allOrders[date]!.total
        
        if total == 0 { return }
        
        let ac = UIAlertController(title: "Are you sure you want to order?", message: "Total cost is $\(total)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] action in
            let vc = self?.storyboard?.instantiateViewController(identifier: "TrackingViewController") as! TrackingViewController
            self?.navigationController?.pushViewController(vc, animated: true)
        }))
        
        present(ac, animated: true)
    }
    
    @IBAction func trackTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "TrackingViewController") as! TrackingViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
