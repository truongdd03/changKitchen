//
//  ViewController.swift
//  eShop
//
//  Created by Dong Truong on 5/7/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(showCart))
    }
    
    @objc func showCart() {
        let vc = storyboard?.instantiateViewController(identifier: "CartViewController") as! CartViewController
        navigationController?.pushViewController(vc, animated: true)
    }

}
