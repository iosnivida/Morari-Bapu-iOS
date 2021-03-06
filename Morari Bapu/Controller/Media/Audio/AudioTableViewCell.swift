//
//  AudioTableViewCell.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 12/01/19.
//  Copyright © 2019 Bhavin Chauhan. All rights reserved.
//

import UIKit
import ESTMusicIndicator

class AudioTableViewCell: UITableViewCell {

  
  @IBOutlet weak var viewMusicIndicator: ESTMusicIndicatorView!
  @IBOutlet weak var lblbTitle: UILabel!
  @IBOutlet weak var lblDuration: UILabel!
  @IBOutlet weak var btnShare: UIButton!
  @IBOutlet weak var btnTitle: UIButton!
  @IBOutlet weak var btnFavourite: UIButton!
  @IBOutlet weak var constraintShareRight: NSLayoutConstraint!
  @IBOutlet weak var viewBackground: UIView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
      //viewMusicIndicator.state = .playing
      viewMusicIndicator.tintColor = .red
      viewMusicIndicator.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
