//
//  KathaEBookTableViewCell.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 07/10/18.
//  Copyright © 2018 Bhavin Chauhan. All rights reserved.
//

import UIKit

class KathaEBookTableViewCell: UITableViewCell {

  @IBOutlet weak var lblTitle: UILabel!
  @IBOutlet weak var lblDescription1: UILabel!
  @IBOutlet weak var lblDescription2: UILabel!
  @IBOutlet weak var lblDescription3: UILabel!

  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
