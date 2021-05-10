//
//  AllViewController.swift
//  eShop
//
//  Created by Dong Truong on 5/8/21.
//

import UIKit
import Firebase

class AllViewController: UITabBarController {

    var name = ""
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    @objc func logOut() {
        let ac = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Sure", style: .default, handler: { [weak self] action in
            self?.doLogOut()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    func doLogOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error when log out")
        }
        let vc = storyboard?.instantiateViewController(identifier: "LobbyViewController") as! LobbyViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
