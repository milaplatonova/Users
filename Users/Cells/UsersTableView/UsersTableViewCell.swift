//
//  UsersTableViewCell.swift
//  Users
//
//  Created by Lyudmila Platonova on 16.06.21.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabe: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let imageHeight = self.bounds.height
        userImage.frame.size.height = imageHeight
        userImage.frame.size.width = imageHeight
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
