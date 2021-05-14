//
//  CourseDetailViewController.swift
//  eShop
//
//  Created by Dong Truong on 5/6/21.
//

import UIKit
import Firebase

class CourseDetailViewController: TableViewController {

    var dateTitle: String?
    var courseName: String? {
        didSet {
            if let courseName = courseName {
                title = "\(courseName) (\(dateTitle!))"
            }
        }
    }
    var listOfDishes = [menuDish]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customCell = UINib(nibName: "DishCell", bundle: nil)
        tableView.register(customCell, forCellReuseIdentifier: "DishCell")
        filterList()
    }
    
    func filterList() {
        var tmp = [menuDish]()
        for dish in listOfDishes {
            if dish.courseType == courseName {
                tmp.append(dish)
            }
        }
        listOfDishes = tmp
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfDishes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishCell", for: indexPath) as! DishCell
        cell.dishImage.image = UIImage(named: "main")
        cell.dishName.text = listOfDishes[indexPath.item].name
        cell.dishPrice.text = "$\(listOfDishes[indexPath.item].price)"
        
        cell.dishImage.contentMode = UIView.ContentMode.scaleToFill
        Utilities.styleRoundedImageView(cell.dishImage)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DishDetailViewController") as! DishDetailViewController
        vc.dish = listOfDishes[indexPath.row]
        vc.title = self.title
        navigationController?.pushViewController(vc, animated: true)
    }
}
