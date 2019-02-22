//
//  WhatsNewTextTableViewCell.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 03/01/19.
//  Copyright © 2019 Bhavin Chauhan. All rights reserved.
//

import UIKit

class WhatsNewTextTableViewCell: UITableViewCell {

  
  @IBOutlet weak var lblCreatedBy: UILabel!
  @IBOutlet weak var lblDescription: UILabel!
  @IBOutlet weak var lblTitle: UILabel!
  @IBOutlet weak var btnShare: UIButton!
  @IBOutlet weak var btnTitle: UIButton!
  @IBOutlet weak var viewBackground: UIView!
  @IBOutlet weak var btnFavourites: UIButton!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
