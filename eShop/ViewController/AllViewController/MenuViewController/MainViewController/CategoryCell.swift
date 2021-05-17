//
//  CategoryCell.swift
//  eShop
//
//  Created by Dong Truong on 5/6/21.
//

import UIKit

class CategoryCell: UITableViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
    
    var categoryName: String? {
        didSet {
            if let categoryName = categoryName {
                categoryLabel.text = categoryName
                categoryLabel.textColor = .black
                contentView.backgroundColor = UIColor(patternImage: UIImage(named: categoryName.lowercased())!)
                contentView.contentMode = UIView.ContentMode.scaleAspectFill
            }
        }
    }
}
