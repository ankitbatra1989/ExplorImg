//
//  ImageDetailCollectionViewCell.swift
//  ExplorImg
//
//  Created by Ankit Batra on 28/10/20.
//

import UIKit

class ImageDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        detailImageView.clipsToBounds = true
        detailImageView.image = UIImage(named: "placeholder.png")
    }
}
