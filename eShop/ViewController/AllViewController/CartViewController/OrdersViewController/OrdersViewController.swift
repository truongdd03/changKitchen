//
//  OrdersViewController.swift
//  eShop
//
//  Created by Dong Truong on 5/14/21.
//

import UIKit
import Firebase

class OrdersViewController: TableViewController {
    var listOfOrders = [Order]()
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        title = "Your Orders"
        listOfOrders.removeAll()
        fetchData()
    }

    
    // MARK: Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfOrders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        cell.order = listOfOrders[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyBoard = UIStoryboard(name: "Cart", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "TrackingViewController") as! TrackingViewController
        vc.order = listOfOrders[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: Firebase
    func fetchData() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("orders").child(userID!).observe(.value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
                        
            for item in dictionary {
                self.ref.child("orderStatus").child(item.key).observe(.value) { (orderData) in
                    let orderDictionary = orderData.value as! [String: Any]
                    self.fetchOrder(dictionary: orderDictionary)
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func fetchOrder(dictionary: [String: Any]) {
        let id = dictionary["id"] as! String
        let pickUpTime = dictionary["pickUpTime"] as! String
        let total = dictionary["total"] as! Double
        listOfOrders.append(Order(orders: [], id: id, total: total, pickUpTime: pickUpTime))
        
        listOfOrders.sort {
            let time0 = Utilities.findYear(pickUpTime: $0.pickUpTime) + $0.pickUpTime
            let time1 = Utilities.findYear(pickUpTime: $1.pickUpTime) + $1.pickUpTime
            return time0 > time1
        }
        
        tableView.reloadData()
    }
}
