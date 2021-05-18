//
//  CartViewController.swift
//  eShop
//
//  Created by Dong Truong on 5/7/21.
//

import UIKit
import Firebase

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
    @IBOutlet weak var timePicker: UIDatePicker!
    
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
    
    func calculateTotal() {
        var total = 0.0
        if allOrders[date]?.orders != nil {
            for dish in allOrders[date]!.orders {
                total += dish.total
            }
            total += tip
            allOrders[date]!.total = total
        }
        totalLabel.text = "$\(round(total*100)/100)"
    }
    
    func updatePickUpTime() {
        let components = Calendar.current.dateComponents([.hour, .minute], from: timePicker.date)
        pickUpTime = "\(String(describing: components.hour!))\(String(describing: components.minute!))"
        if pickUpTime.count < 4 {
            pickUpTime = "0" + pickUpTime
        }
        pickUpTime = date + pickUpTime
        allOrders[date]!.pickUpTime = pickUpTime
    }

    // MARK: Table View
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


    // MARK: Buttons and Text Field
    @IBAction func orderTapped(_ sender: Any) {
        guard let total = allOrders[date]?.total else { return }
        if total == 0 { return }
        
        updatePickUpTime()

        let ac = UIAlertController(title: "Are you sure you want to order?", message: "Total cost is $\(total)", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] action in
            self?.transit()
        }))
        
        present(ac, animated: true)
    }
    
    func transit() {
        let loadingView = self.loader()
        
        updateData() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                let vc = self.storyboard!.instantiateViewController(identifier: "OrdersViewController") as! OrdersViewController
                self.navigationController?.pushViewController(vc, animated: true)
            })
            self.stopLoader(loader: loadingView)
        }
    }
    
    @IBAction func trackTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "OrdersViewController") as! OrdersViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didEditTip(_ sender: Any) {
        if let tmp = Double((sender as! UITextField).text ?? "0") {
            tip = tmp
        }
        calculateTotal()
    }
    
    
    // MARK: Firebase
    func updateID(currentID: String) -> String {
        var id = Int(currentID)!
        id = id + 1
        
        var newID = String(id)
        while newID.count < 6 { newID = "0" + newID }
        
        return newID
    }
    
    func updateData(completion: @escaping () -> Void) {
        let ref = Database.database().reference().child("orders")
        
        ref.child("orderKey").getData { (error, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                //Update order id
                let orderID = self.updateID(currentID: snapshot.value as! String)
                ref.child("orderKey").setValue(orderID)
                allOrders[date]!.id = orderID
                
                self.uploadOrder() {
                    completion()
                }
            }
        }
    }
    
    func uploadOrder(completion: @escaping () -> Void) {
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        let orderID = allOrders[date]!.id
    
        // Update order locally
        ref.child("orders").child(userID!).child(orderID).setValue(orderID)
        
        //Update order globally
        let order = allOrders[date]!
        let userRef = ref.child("orderStatus").child(orderID)
        userRef.child("id").setValue(order.id)
        userRef.child("total").setValue(order.total)
        userRef.child("pickUpTime").setValue(order.pickUpTime)
        userRef.child("status").setValue("Received")
        
        //Update dish in order
        for item in order.orders {
            let dishRef = userRef.child(item.id)
            dishRef.child("id").setValue(item.id)
            dishRef.child("quantity").setValue(item.quantity)
            dishRef.child("note").setValue(item.note)
        }
        
        allOrders[date] = nil
        completion()
    }
}
