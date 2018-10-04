//
//  QuotesTableViewCell.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 03/10/18.
//  Copyright © 2018 Bhavin Chauhan. All rights reserved.
//

import UIKit

class QuotesTableViewCell: UITableViewCell {

  
  @IBOutlet weak var btnCategories: UIButton!
  @IBOutlet weak var btnShare: UIButton!
  @IBOutlet weak var lblDate: UILabel!
  @IBOutlet weak var lblQuotes: UILabel!
  @IBOutlet weak var btnFavourite: UIButton!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
