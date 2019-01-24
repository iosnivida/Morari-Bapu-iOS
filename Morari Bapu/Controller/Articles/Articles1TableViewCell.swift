//
//  Articles1TableViewCell.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 10/01/19.
//  Copyright © 2019 Bhavin Chauhan. All rights reserved.
//

import UIKit

class Articles1TableViewCell: UITableViewCell {

  @IBOutlet weak var lblTitle: UILabel!
  @IBOutlet weak var lblLink: UILabel!
  @IBOutlet weak var lblDate: UILabel!
  @IBOutlet weak var btnFavourite: UIButton!
  @IBOutlet weak var btnShare: UIButton!

  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
