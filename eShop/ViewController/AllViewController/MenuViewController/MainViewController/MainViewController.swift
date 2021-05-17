//
//  NewfeedsViewController.swift
//  eShop
//
//  Created by Dong Truong on 5/5/21.
//

// Can change the number of courses.
import UIKit
import Firebase

var date = ""
class MainViewController: ViewController {
    var dateTitle = "Today"
    
    @IBOutlet weak var appetizerButton: UIButton!
    @IBOutlet weak var soupButton: UIButton!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var dessertButton: UIButton!

    var dishID = [String]()
        
    override func viewWillAppear(_ animated: Bool) {
        title = dateTitle
        calculateDate()
        print(date)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculateDate()
        
        // Fetch data
        if allMenus[date] == nil {
            allMenus[date] = Menu(dishes: [], date: date)
                        
            fetchMenuDishID() {
                self.startFetchDish()
            }
            
        }
    }
    
    func startFetchDish() {
        for id in self.dishID {
            if let dish = allDishes[id] {
                allMenus[date]!.dishes.append(dish)
            } else {
                let dishLoader = self.loader()
                Fetch.fetchMenuDish(id: id) {
                    allMenus[date]?.dishes.append(allDishes[id]!)
                    self.stopLoader(loader: dishLoader)
                }
            }
        }
    }
    
    func calculateDate() {
        if dateTitle == "Today" {
            date = todayDate
        } else {
            date = dateTitle
            while let id = date.firstIndex(of: "/") {
                date.remove(at: id)
            }
        }
    }
    
    // MARK: Buttons
    @IBAction func buttonTapped(_ sender: Any) {
        let courseName = (sender as! UIButton).titleLabel?.text
        let vc = storyboard?.instantiateViewController(identifier: "CourseDetailViewController") as! CourseDetailViewController
        vc.dateTitle = dateTitle
        vc.courseName = courseName!
        vc.listOfDishes = allMenus[date]!.dishes
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: Firebase
    func fetchMenuDishID(completion: @escaping () -> Void) {
        let ref = Database.database().reference()
        
        ref.child("menus").child(date).observe(.value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {
                let ac = Utilities.createAlert(title: "Oops!", message: "We really apolozie that there is no menu for today")
                self.present(ac, animated: true)
                return
            }
                
            for item in dictionary {
                self.dishID.append(item.value as! String)
            }
            
            completion()
        })
    }
    
    // MARK: Loader
    func loader() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true)
        return alert
    }
    
    func stopLoader(loader : UIAlertController) {
        DispatchQueue.main.async {
            loader.dismiss(animated: true, completion: nil)
        }
    }
}
