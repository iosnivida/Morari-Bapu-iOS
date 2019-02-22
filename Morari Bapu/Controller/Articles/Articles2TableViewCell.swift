//
//  Articles2TableViewCell.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 10/01/19.
//  Copyright © 2019 Bhavin Chauhan. All rights reserved.
//

import UIKit

class Articles2TableViewCell: UITableViewCell {

  @IBOutlet weak var lblTitle: UILabel!
  @IBOutlet weak var lblLink: UILabel!
  @IBOutlet weak var lblDate: UILabel!
  @IBOutlet weak var imgVideo: UIImageView!
  @IBOutlet weak var btnYoutube: UIButton!
  @IBOutlet weak var btnShare: UIButton!
  @IBOutlet weak var btnFavourite: UIButton!
  @IBOutlet weak var btnLink: UIButton!
  @IBOutlet weak var viewBackground: UIView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
