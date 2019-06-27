//
//  BapuDarshanUITableViewCell.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 23/02/19.
//  Copyright © 2019 Bhavin Chauhan. All rights reserved.
//

import UIKit

class BapuDarshanUITableViewCell: UITableViewCell {

  
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDateAndTime: UILabel!
    @IBOutlet weak var imgBapuDarshan: UIImageView!
  @IBOutlet weak var btnFavourite: UIButton!
  @IBOutlet weak var btnShare: UIButton!
  @IBOutlet weak var viewBackground: UIView!
  @IBOutlet weak var btnTitle: UIButton!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
