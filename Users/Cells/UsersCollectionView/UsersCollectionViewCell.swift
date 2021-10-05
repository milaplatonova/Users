//
//  UsersCollectionViewCell.swift
//  Users
//
//  Created by Lyudmila Platonova on 24.08.21.
//

import UIKit

class UsersCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let imageWidth = self.bounds.width
        userImage.frame.size.width = imageWidth
        userImage.frame.size.height = imageWidth
    }

}
