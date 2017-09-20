//
//  ListingsCollectionCell.swift
//  fix
//
//  Created by Alex Beattie on 9/19/17.
//  Copyright © 2017 Artisan Branding. All rights reserved.
//

import UIKit

class ListingsCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
//    var listing: Listing?

    override func prepareForReuse() {
        titleLabel.text = ""
        subTitleLabel.text = ""
    }
    var listing: Listing? {
        didSet {
            if let listing = listing {
                titleLabel.text = listing.listDate
                if let listPrice = listing.listPrice {
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                    
                    let subTitleText = "\(numberFormatter.string(from: listPrice)!)"
                    subTitleLabel.text = subTitleText
                }
            }
        }
    }
}
