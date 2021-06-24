//
//  Fetch.swift
//  eShop
//
//  Created by Dong Truong on 5/17/21.
//

import Foundation
import Firebase

struct Fetch {
    static func fetchMenuDish(id: String, completion: @escaping () -> Void) {
        let ref = Database.database().reference()
        
        ref.child("menuDishes").child(id).observe(.value, with: { (snapshot) in
            let dictionary = snapshot.value as! [String: Any]
            
            let name = dictionary["name"] as! String
            let price = dictionary["price"] as! Double
            let courseType = dictionary["courseType"] as! String
            
            // Fetch dish image
            let storageRef = Storage.storage().reference()
            storageRef.child("Dish Image").child("\(id).jpg").getData(maxSize: 1*1024*1024) { (data, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    let image = UIImage(data: data!)
                    let dish = menuDish(name: name, price: price, image: image, courseType: courseType, id: id)
                    allDishes[id] = dish
                    
                    completion()
                }
            }
        })
    }
}
