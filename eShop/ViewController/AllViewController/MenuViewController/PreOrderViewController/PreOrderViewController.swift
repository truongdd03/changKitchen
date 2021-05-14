//
//  CollectionViewController.swift
//  eShop
//
//  Created by Dong Truong on 5/8/21.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class PreOrderViewController: CollectionViewController {
    // Save all preorder menus
    var listOfDates = [String]()

    override func viewWillAppear(_ animated: Bool) {
        title = "Preorder"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        fetchData()
    }
    
    // List of dates that have menu
    func fetchData() {
        let ref = Database.database().reference()
        
        ref.child("menus").observe(.value) { (snapshot) in
            let dictionary = snapshot.value as! [String: Any]
            for item in dictionary {
                if item.key == todayDate { continue }
                self.updateList(date: item.key)
            }
        }
    }
    
    func updateList(date: String) {
    
        // add '/' in date
        // from 051221 to 05/12/21
        let tmp = Utilities.reformatDate(date: date)
        
        listOfDates.append(tmp)
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfDates.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        cell.dateLabel.text = listOfDates[indexPath.item]
        Utilities.styleFilledLabel(cell.dateLabel)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Menu", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "MainViewController") as! MainViewController
        vc.dateTitle = listOfDates[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
}
