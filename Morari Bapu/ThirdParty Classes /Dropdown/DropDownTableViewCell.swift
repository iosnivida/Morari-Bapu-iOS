//
//  DropDownTableViewCell.swift
//  Doggie
//
//  Created by Bhavin Chauhan on 07/08/18.
//  Copyright © 2018 Bhavin Chauhan. All rights reserved.
//

import UIKit

class DropDownTableViewCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgProfilePic: UIImageView!
    @IBOutlet var lblAddNewPet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
