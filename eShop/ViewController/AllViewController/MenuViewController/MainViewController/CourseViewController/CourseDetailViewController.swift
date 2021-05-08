//
//  CourseDetailViewController.swift
//  eShop
//
//  Created by Dong Truong on 5/6/21.
//

import UIKit

class CourseDetailViewController: TableViewController {

    var courseName: String? {
        didSet {
            if let courseName = courseName {
                title = "Today's \(courseName)"
                if courseName == "Main" {
                    title = "Today's Main Dish"
                }
            }
        }
    }
    
    var listOfDishes = [Dish]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let customCell = UINib(nibName: "DishCell", bundle: nil)
        tableView.register(customCell, forCellReuseIdentifier: "DishCell")
        fetchData()
    }

    // What will we have today .-.
    func fetchData() {
        for i in 0..<5 {
            listOfDishes.append(Dish(name: "Dish \(i)", price: 1.00, quantity: 0, note: nil))
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfDishes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishCell", for: indexPath) as! DishCell
        cell.dish = listOfDishes[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DishDetailViewController") as! DishDetailViewController
        vc.dish = listOfDishes[indexPath.row]
        vc.title = self.title
        navigationController?.pushViewController(vc, animated: true)
    }
}
