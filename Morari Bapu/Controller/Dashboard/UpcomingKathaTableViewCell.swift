//
//  UpcomingKathaTableViewCell.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 03/10/18.
//  Copyright © 2018 Bhavin Chauhan. All rights reserved.
//

import UIKit

class UpcomingKathaTableViewCell: UITableViewCell {

  @IBOutlet weak var btnCategoryName: UIButton!
  @IBOutlet weak var lblTitle: UILabel!
  @IBOutlet weak var lblDate: UILabel!
  @IBOutlet weak var lblScheduleDate: UILabel!
  @IBOutlet weak var lblDay: UILabel!
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
