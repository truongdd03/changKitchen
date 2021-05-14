//
//  ViewController.swift
//  eShop
//
//  Created by Dong Truong on 5/5/21.
//

import UIKit

class LobbyViewController: UIViewController {

    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.setToolbarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleFilledButton(logInButton)
        Utilities.styleHollowButton(signUpButton)
        
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "isSignIn") == true {
            let storyBoard = UIStoryboard(name: "TabBar", bundle: nil)
            let vc = storyBoard.instantiateViewController(identifier: "AllViewController") as! AllViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func logInTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "LogInViewController") as! LogInViewController
        navigationController?.pushViewController(vc, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
        navigationController?.pushViewController(vc, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

