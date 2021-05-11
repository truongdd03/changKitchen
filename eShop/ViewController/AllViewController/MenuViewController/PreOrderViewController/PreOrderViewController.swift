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
    var listOfMenus = [Menu]()

    override func viewWillAppear(_ animated: Bool) {
        title = "Preorder"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        fetchData()
    }
    
    func fetchData() {
        for i in 0...3 {
            listOfMenus.append(Menu(courses: [], date: "\(i)"))
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfMenus.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        cell.dateLabel.text = listOfMenus[indexPath.item].date
        Utilities.styleFilledLabel(cell.dateLabel)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Menu", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "MainViewController") as! MainViewController
        vc.dateTitle = listOfMenus[indexPath.item].date
        navigationController?.pushViewController(vc, animated: true)
    }
}
