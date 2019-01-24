//
//  KathaChopaiTableViewCell.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 08/10/18.
//  Copyright © 2018 Bhavin Chauhan. All rights reserved.
//

import UIKit

class KathaChopaiTableViewCell: UITableViewCell {

  @IBOutlet weak var lblTitle: UILabel!
  @IBOutlet weak var btnShare: UIButton!
  @IBOutlet weak var btnFavourite: UIButton!
  @IBOutlet weak var lblDate: UILabel!
  @IBOutlet weak var lblDescription1: UILabel!
  @IBOutlet weak var lblDescription2: UILabel!
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
