//
//  YoutubeTableViewCell.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 03/10/18.
//  Copyright © 2018 Bhavin Chauhan. All rights reserved.
//

import UIKit

class YoutubeTableViewCell: UITableViewCell {

  
    @IBOutlet weak var lblDateAndTime: UILabel!
    @IBOutlet weak var btnMoveToCatrgoryLink: UIButton!
  @IBOutlet weak var lblTitle: UILabel!
  @IBOutlet weak var lblDuration: UILabel!
  @IBOutlet weak var lblDate: UILabel!
  @IBOutlet weak var imgVideo: UIImageView!
  @IBOutlet weak var btnYoutube: UIButton!
  @IBOutlet weak var btnShare: UIButton!
  @IBOutlet weak var btnFavourite: UIButton!
  @IBOutlet weak var btnTitle: UIButton!
  @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var btnPlayList: UIButton!
    
  @IBOutlet weak var constraintRightShare: NSLayoutConstraint!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
