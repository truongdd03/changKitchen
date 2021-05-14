//
//  SignUpViewController.swift
//  eShop
//
//  Created by Dong Truong on 5/5/21.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var lastNameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var password2Label: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        title = "Sign Up"
        
        Utilities.styleTextField(firstNameLabel)
        Utilities.styleTextField(lastNameLabel)
        Utilities.styleTextField(emailLabel)
        Utilities.styleTextField(passwordLabel)
        Utilities.styleTextField(password2Label)
        Utilities.styleFilledButton(signUpButton)
        errorLabel.alpha = 0
    }

    func validateTextFields() -> String? {
        if firstNameLabel.text == nil || lastNameLabel.text == nil || emailLabel.text == nil || passwordLabel.text == nil || password2Label.text == nil {
            return "Please fill all fields"
        }
        
        if passwordLabel.text != password2Label.text {
            return "Password and cofirm password don't match"
        }
        
        if firstNameLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Invalid first/last name"
        }
        
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        errorLabel.alpha = 0
        if let error = validateTextFields() {
            showError(message: error)
            return
        }
        
        let email = emailLabel.text!
        let password = passwordLabel.text!
        let firstName = firstNameLabel.text!
        let lastName = lastNameLabel.text!
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.showError(message: error.localizedDescription)
                return
            }
            
            let db = Firestore.firestore()
            db.collection("users").document(result!.user.uid).setData(["firstName": firstName, "lastName": lastName, "uid": result!.user.uid])
            
            self.transit()
        }
    }
    
    func transit() {
        let ac = UIAlertController(title: "Successfully register", message: "Welcome to Chang's Kitchen!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK!", style: .default, handler: { [weak self] action in
            let storyBoard = UIStoryboard(name: "TabBar", bundle: nil)
            let vc = storyBoard.instantiateViewController(identifier: "AllViewController") as! AllViewController
            self?.navigationController?.pushViewController(vc, animated: true)
        }))
        present(ac, animated: true)
        
        let defaults = UserDefaults.standard
        defaults.setValue(true, forKey: "isSignIn")
    }
    
    func showError(message: String) {
        errorLabel.alpha = 1
        errorLabel.text = message
    }

}
