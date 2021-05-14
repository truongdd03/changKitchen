//
//  NewfeedsViewController.swift
//  eShop
//
//  Created by Dong Truong on 5/5/21.
//

// Can change the number of courses.
import UIKit
import Firebase

var date = ""
class MainViewController: ViewController {
    var dateTitle = "Today"
    
    @IBOutlet weak var appetizerButton: UIButton!
    @IBOutlet weak var soupButton: UIButton!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var dessertButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        title = dateTitle
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch data
        if dateTitle == "Today" {
            date = todayDate
        } else {
            date = dateTitle
            while let id = date.firstIndex(of: "/") {
                date.remove(at: id)
            }
        }
        
        if allMenus[date] == nil {
            allMenus[date] = Menu(dishes: [], date: date)
            performSelector(inBackground: #selector(fetchMenu), with: nil)
        }
    }
    
    @objc func fetchMenu() {
        let ref = Database.database().reference()
        
        ref.child("menus").child(date).observe(.value, with: { (snapshot) in
            allMenus[date]?.dishes.removeAll()
            let dictionary = snapshot.value as! [String: Any]
            for item in dictionary {
                let id = item.value as! String
                if allDishes[id] != nil {
                    self.updateList(dish: allDishes[id]!, id: id)
                } else {
                    self.fetchMenuDish(id: item.value as! String)
                }
            }
        })
    }

    func fetchMenuDish(id: String) {
        let ref = Database.database().reference()
        
        ref.child("menuDishes").child(id).observe(.value, with: { (snapshot) in
            let dictionary = snapshot.value as! [String: Any]
            let tmp = menuDish(name: dictionary["name"] as! String, price: dictionary["price"] as! Double, image: nil, courseType: dictionary["courseType"] as! String, id: id)
            self.updateList(dish: tmp, id: id)
        })
    }
    
    func updateList(dish: menuDish, id: String) {
        allMenus[date]?.dishes.append(dish)
        allDishes[id] = dish
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        let courseName = (sender as! UIButton).titleLabel?.text
        let vc = storyboard?.instantiateViewController(identifier: "CourseDetailViewController") as! CourseDetailViewController
        vc.dateTitle = dateTitle
        vc.courseName = courseName!
        vc.listOfDishes = allMenus[date]!.dishes
        navigationController?.pushViewController(vc, animated: true)
    }
}
