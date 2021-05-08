//
//  NewfeedsViewController.swift
//  eShop
//
//  Created by Dong Truong on 5/5/21.
//

// Can change the number of courses.
import UIKit
import Firebase

class MainViewController: LogOutTableViewController {
    var categories = ["Appetizer","Soup","Main", "Dessert"]
    var dateTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        title = dateTitle
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.categoryName = categories[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "CourseDetailViewController") as! CourseDetailViewController
        vc.courseName = categories[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

}