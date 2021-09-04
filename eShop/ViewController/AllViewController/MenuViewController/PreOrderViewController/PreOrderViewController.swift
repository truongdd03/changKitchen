//
//  CollectionViewController.swift
//  eShop
//
//  Created by Dong Truong on 5/8/21.
//

import UIKit
import Firebase

class PreOrderViewController: CollectionViewController {
    // Save all preorder menus
    var listOfDates = [String]()

    override func viewWillAppear(_ animated: Bool) {
        title = "Preorder"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        fetchData()
    }
    
    
    // MARK: Collection View
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
    
    
    // MARK: Firebase
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
    
        var y1 = date
        y1.removeFirst(4)
        var y2 = todayDate
        y2.removeFirst(4)
        if y1 < y2 || (y1 == y2 && date < todayDate) {
            return
        }
        
        // add '/' in date
        // from 051221 to 05/12/21
        let tmp = Utilities.reformatDate(date: date)
        
        listOfDates.append(tmp)
        listOfDates.sort() {
            let date1 = Utilities.findYear(pickUpTime: $0) + $0
            let date2 = Utilities.findYear(pickUpTime: $1) + $1
            
            return date1 < date2
        }
        
        collectionView.reloadData()
    }
}
