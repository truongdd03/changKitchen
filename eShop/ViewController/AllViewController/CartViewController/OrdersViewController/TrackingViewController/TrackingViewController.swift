//
//  TrackingViewController.swift
//  eShop
//
//  Created by Dong Truong on 5/9/21.
//

import UIKit
import Firebase

class TrackingViewController: TableViewController {
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var pickUpTimeLabel: UILabel!
    @IBOutlet weak var pickUpAddressLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    
    var order: Order?

    var statusColor = [String: UIColor]()
    var statusPercent = [String: Float]()
    var orderDishes = [orderedDish]()
    
    var ref = Database.database().reference()
    var status = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designProgressBar()
        setUp()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        updateLabel()
    }
    
    func updateLabel() {
        if let order = order {
            orderNumberLabel.text = "#\(order.id)"
            pickUpTimeLabel.text = "\(Utilities.reformatPickUpTime(pickUpTime: order.pickUpTime))"
            pickUpAddressLabel.text = "000 Unknown Street, Unknown City, Unknown State"
            
            fetchStatus() {
                self.progressBar.progress = self.statusPercent[self.status]!
                self.progressBar.progressTintColor = self.statusColor[self.status]!
                self.statusLabel.text = self.status
                self.statusLabel.textColor = self.statusColor[self.status]!
            }
            
            fetchOrder {
                self.totalCostLabel.text = "$\(order.total)"
                print(self.orderDishes.count)
                self.tableView.reloadData()
            }
        }
    }
    
    func setUp() {
        statusColor["Received"] = UIColor.systemOrange
        statusColor["Cooking"] = UIColor.systemOrange
        statusColor["Almost Done"] = UIColor.systemGreen
        statusColor["Finished"] = UIColor.systemGreen
        statusColor["Paid"] = UIColor.systemGreen
        
        statusPercent["Received"] = 0.2
        statusPercent["Cooking"] = 0.4
        statusPercent["Almost Done"] = 0.6
        statusPercent["Finished"] = 0.8
        statusPercent["Paid"] = 1
    }
    
    func designProgressBar() {
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 8)
        progressBar.layer.cornerRadius = 8
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 8
        progressBar.subviews[1].clipsToBounds = true
    }


    // MARK: Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderDishes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleDishCell", for: indexPath) as! SimpleDishCell
        
        let order = orderDishes[indexPath.row]
        cell.dishNameLabel.text = allDishes[order.id]!.name
        cell.quantityLabel.text = "x\(Int(order.quantity))"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }


    // MARK: Firebase
    func fetchStatus(completion: @escaping () -> Void) {
        let ref = Database.database().reference()
        
        ref.child("orderStatus").child(order!.id).observe(.value) { (snapshot) in
            let dictionary = snapshot.value as! [String: Any]
            self.status = dictionary["status"] as! String
            completion()
        }
    }
    
    func fetchOrder(completion: @escaping () -> Void) {
        ref = ref.child("orderStatus").child(order!.id)
        ref.observe(.value) { (snapshot) in
            let dictionary = snapshot.value as! [String: Any]
            
            for item in dictionary {
                if Int(item.key) != nil {
                    // Fetch Dish From ID here
                    self.fetchOrderDetail(id: item.key) {
                        if allDishes[item.key] == nil {
                            Fetch.fetchMenuDish(id: item.key, completion: completion)
                        }
                        completion()
                    }
                }
            }
        }
    }
    
    func fetchOrderDetail(id: String, completion: @escaping () -> Void) {
        let result = orderedDish(id: "", quantity: 0, price: 0)
        ref.child(id).observe(.value) { (snapshot) in
            let dictionary = snapshot.value as! [String: Any]
            let quantity = dictionary["quantity"] as! Double
            result.quantity = quantity
            result.id = id
            self.orderDishes.append(result)
            
            completion()
        }
        
    }
}
