//
//  CourseDetailViewController.swift
//  eShop
//
//  Created by Dong Truong on 5/6/21.
//

import UIKit

class CourseDetailViewController: CollectionViewController {

    var date: String?
    var courseName: String? {
        didSet {
            if let courseName = courseName {
                title = "\(courseName) (\(date!))"
                if courseName == "Main" {
                    title = "Main Dish"
                }
            }
        }
    }
    
    var listOfDishes = [Dish]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }

    // What will we have today .-.
    func fetchData() {
        for i in 0..<5 {
            listOfDishes.append(Dish(name: "Dish \(i)", price: 1.00, quantity: 0, note: nil, image: nil))
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfDishes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishCell", for: indexPath) as! DishCell
        cell.dishImage.image = UIImage(named: "main")
        Utilities.styleRoundedImageView(cell.dishImage)
        cell.dishName.text = listOfDishes[indexPath.item].name
        cell.dishPrice.text = "$\(listOfDishes[indexPath.item].price)"
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DishDetailViewController") as! DishDetailViewController
        vc.dish = listOfDishes[indexPath.row]
        vc.date = date
        vc.title = self.title
        navigationController?.pushViewController(vc, animated: true)
    }

}
