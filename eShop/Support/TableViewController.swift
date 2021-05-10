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

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.right.doc.on.clipboard"), style: .plain, target: self, action: #selector(logOut))
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
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "LobbyViewController") as! LobbyViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
