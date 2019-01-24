//
//  MusicPlayerVC.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 14/01/19.
//  Copyright © 2019 Bhavin Chauhan. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class MusicPlayerVC: UIViewController {

  @IBOutlet weak var imgThumbnil: UIImageView!
  @IBOutlet weak var lblTitleHeader: UILabel!
  @IBOutlet weak var lblSubTitleHeader: UILabel!
  @IBOutlet weak var btnPreviousHeader: UIButton!
  @IBOutlet weak var btnNextHeader: UIButton!
  @IBOutlet weak var btnPlayPauseHeader: UIButton!
  
  @IBOutlet weak var imgBigThumbnil: UIImageView!
  @IBOutlet weak var lblTitle: UILabel!
  @IBOutlet weak var lblSubTitle: UILabel!
  @IBOutlet weak var lblOutOfAudio: UILabel!
  @IBOutlet weak var lblStartTimer: UILabel!
  @IBOutlet weak var lblEndTimer: UILabel!
  @IBOutlet weak var lblSliderAudio: UISlider!
  @IBOutlet weak var btnPrevious: UIButton!
  @IBOutlet weak var btnPlayPause: UIButton!
  @IBOutlet weak var btnNext: UIButton!
  @IBOutlet weak var btnRepeat: UIButton!
  
  @IBOutlet weak var btnSuffle: UIButton!
  @IBOutlet weak var constraintTopView: NSLayoutConstraint!

  @IBOutlet weak var constraintMainViewHeight: NSLayoutConstraint!
  
  var arrAudioList = [JSON]()
  
  var playPosition = Int()
  
  override func viewDidLoad() {
        super.viewDidLoad()

      self.constraintTopView.constant = self.view.frame.height - 50
      self.constraintMainViewHeight.constant = self.view.frame.height - 20
      self.view.layoutIfNeeded()

      updateAudioPlayer(positon: playPosition)
    
    }
  
  func updateAudioPlayer(positon:Int){
    
    let dict = arrAudioList[positon]
    
    DispatchQueue.main.async {
      
      self.lblTitleHeader.text = dict["name"].stringValue
      self.lblSubTitleHeader.text = "(Duration: \(dict["duration"].stringValue))"
      self.lblTitle.text = dict["name"].stringValue
      self.lblSubTitle.text = dict["description"].stringValue
      
      let placeHolder = UIImage(named: "youtube_placeholder")
      self.imgThumbnil.kf.indicatorType = .activity
      self.imgThumbnil.kf.setImage(with: URL(string: "\(BASE_URL_IMAGE)\(dict["image_file"].stringValue)"), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
      
      let placeHolder1 = UIImage(named: "youtube_placeholder")
      self.imgBigThumbnil.kf.indicatorType = .activity
      self.imgBigThumbnil.kf.setImage(with: URL(string: "\(BASE_URL_IMAGE)\(dict["image_file"].stringValue)"), placeholder: placeHolder1, options: [.transition(ImageTransition.fade(1))])

      if self.arrAudioList.count == positon{
          self.lblOutOfAudio.text = "\(positon+1)/\(self.arrAudioList.count)"
      }else{
        self.lblOutOfAudio.text = "\(positon+1)/\(self.arrAudioList.count)"
      }
      self.lblStartTimer.text = "00:00"
      self.lblEndTimer.text = dict["duration"].stringValue

    }
    
   /* "description" : "It often happens that we overestimate our strengths. Something drastic has to happen before we realise our limitations and Brahma was no exception to this. Not aware that beside Lord Narayana’s powers his own powers were insignificant, Brahma steals the cows that Krishna and His friends are looking after in Gokula.",
    "is_read" : 0,
    "name" : "Brahma Stuti",
    "html_file" : "",
    "status" : "1",
    "id" : "5",
    "audio_file" : "stuti\/audio\/audio1528695221.mp3",
    "stuti_type_id" : "1",
    "pdf_file" : "stuti\/pdf\/pdf1528695221.pdf",
    "created" : "2018-06-11 11:03:41",
    "duration" : "7:43",
    "modified" : "2018-07-03 14:06:51"*/
    
  }
  
  
  //MARK:- Button Event
  @IBAction func btnUpAndDown(_ sender: Any) {
    
    DispatchQueue.main.async {
      
      UIView.animate(withDuration: 0.3, animations: {
        self.constraintTopView.constant = 20
        self.view.layoutIfNeeded()
      })
    }
  }
  
  @IBAction func btnPlayPause(_ sender: Any) {
    
    if btnPlayPause.isSelected == false{
      btnPlayPause.isSelected = true
      btnPlayPause.setImage(UIImage(named: "pause"), for: .normal)
      
    }else{
      
      btnPlayPause.isSelected = false
      btnPlayPause.setImage(UIImage(named: "play"), for: .normal)
    }
  }
  
  @IBAction func btnNext(_ sender: Any) {
    
  }
  
  @IBAction func btnPrevious(_ sender: Any) {
    
  }
  
  @IBAction func btnSuffle(_ sender: Any) {
    
  }
  
  @IBAction func btnRepeat(_ sender: Any) {
    
  }
  
  
}


class PassThroughView: UIView {
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    for subview in subviews {
      if !subview.isHidden && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
        return true
      }
    }
    return false
  }
}
