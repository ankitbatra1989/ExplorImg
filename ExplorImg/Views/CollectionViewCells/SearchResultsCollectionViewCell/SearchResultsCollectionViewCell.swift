//
//  SearchResultsCollectionViewCell.swift
//  ExplorImg
//
//  Created by Ankit Batra on 26/10/20.
//

import UIKit

class SearchResultsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var searchResultImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        searchResultImageView.clipsToBounds = true
        searchResultImageView.image = UIImage(named: "placeholder.png")
    }
}
