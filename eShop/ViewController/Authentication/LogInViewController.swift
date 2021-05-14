//
//  LogInViewController.swift
//  eShop
//
//  Created by Dong Truong on 5/5/21.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        title = "Log In"
        
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(logInButton)
        errorLabel.alpha = 0
    }

    func validateTextFields() -> String? {
        if emailTextField.text == nil || passwordTextField.text == nil {
            return "Invalid password/email"
        }
        return nil
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        errorLabel.alpha = 0
        if let error = validateTextFields() {
            showError(message: error)
            return
        }
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.showError(message: error.localizedDescription)
                return
            }
            
            let storyBoard = UIStoryboard(name: "TabBar", bundle: nil)
            let vc = storyBoard.instantiateViewController(identifier: "AllViewController") as! AllViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
            let defaults = UserDefaults.standard
            defaults.setValue(true, forKey: "isSignIn")
        }
    }
    
    func showError(message: String) {
        errorLabel.alpha = 1
        errorLabel.text = message
    }
    
}
