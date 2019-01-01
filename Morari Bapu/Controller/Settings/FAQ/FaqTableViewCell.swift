//
//  FaqTableViewCell.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 01/01/19.
//  Copyright © 2019 Bhavin Chauhan. All rights reserved.
//

import UIKit

class FaqTableViewCell: UITableViewCell {

  @IBOutlet weak var lblDescription: UILabel!
  @IBOutlet weak var lblTitle: UILabel!
  
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
