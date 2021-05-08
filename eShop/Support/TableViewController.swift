//
//  ViewController.swift
//  eShop
//
//  Created by Dong Truong on 5/7/21.
//

import UIKit
import Firebase

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let cartButton = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(showCart))
        navigationItem.rightBarButtonItems = [cartButton]
    }
    
    @objc func showCart() {
        let vc = storyboard?.instantiateViewController(identifier: "CartViewController") as! CartViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
