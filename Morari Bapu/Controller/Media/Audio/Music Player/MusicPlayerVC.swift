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
import MediaPlayer
import Jukebox

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
  @IBOutlet weak var sliderAudio: UISlider!
  @IBOutlet weak var sliderVolume: UISlider!
  @IBOutlet weak var btnPrevious: UIButton!
  @IBOutlet weak var btnPlayPause: UIButton!
  @IBOutlet weak var btnVolume: UIButton!
  @IBOutlet weak var btnNext: UIButton!
  @IBOutlet weak var btnRepeat: UIButton!
  @IBOutlet weak var indicator: UIActivityIndicatorView!
  
  @IBOutlet weak var btnSuffle: UIButton!
  @IBOutlet weak var constraintTopView: NSLayoutConstraint!

  @IBOutlet weak var constraintMainViewHeight: NSLayoutConstraint!
  
  @IBOutlet weak var constraintTopVolumeView: NSLayoutConstraint!
  
  var arrAudioList = [JSON]()
  
  var playPosition = Int()
  
  var isUpDown = false
  var isSuffle = false
  var isRepeat = false
  
  //Jukbok
  var jukebox : Jukebox!
  
  override func viewDidLoad() {
        super.viewDidLoad()


      // begin receiving remote events
      UIApplication.shared.beginReceivingRemoteControlEvents()

      self.constraintTopVolumeView.constant = -70
      self.view.layoutIfNeeded()
    
      self.constraintTopView.constant = self.view.frame.height - 50
      self.constraintMainViewHeight.constant = self.view.frame.height - 20
      self.view.layoutIfNeeded()

    
        for audio in arrAudioList{
          
          // configure jukebox
          
          if jukebox == nil{
            
              jukebox = Jukebox(delegate: self, items: [
                JukeboxItem(URL: URL(string: "\(BASE_URL_IMAGE)\(audio["audio_file"].stringValue)")!)
                ])!
            
          }else{
            
            /// Later add another item
            let delay = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delay) {
              self.jukebox.append(item: JukeboxItem (URL: URL(string: "\(BASE_URL_IMAGE)\(audio["audio_file"].stringValue)")!), loadingAssets: true)
            }
          }
        }
    
    
        self.jukebox.play()
    
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
    
    if isUpDown == false{
      
      UIView.animate(withDuration: 0.3, animations: {
        self.isUpDown = true
        self.constraintTopView.constant = 20
        self.btnPlayPauseHeader.alpha = 0.0
        self.btnNextHeader.alpha = 0.0
        self.btnPreviousHeader.alpha = 0.0
        self.view.layoutIfNeeded()
      })
      
    }else{
      UIView.animate(withDuration: 0.3, animations: {
        self.btnPlayPauseHeader.alpha = 1.0
        self.btnNextHeader.alpha = 1.0
        self.btnPreviousHeader.alpha = 1.0
        self.isUpDown = false
        self.constraintTopView.constant = self.view.frame.height - 50
        self.view.layoutIfNeeded()
      })
    }
  }
  
  @IBAction func swipeUp(_ sender: Any) {
    UIView.animate(withDuration: 0.3, animations: {
      self.isUpDown = true
      self.constraintTopView.constant = 20
      self.btnPlayPauseHeader.alpha = 0.0
      self.btnNextHeader.alpha = 0.0
      self.btnPreviousHeader.alpha = 0.0
      self.view.layoutIfNeeded()
    })
  }
  
  @IBAction func swipeDown(_ sender: Any) {
    UIView.animate(withDuration: 0.3, animations: {
      self.btnPlayPauseHeader.alpha = 1.0
      self.btnNextHeader.alpha = 1.0
      self.btnPreviousHeader.alpha = 1.0
      self.isUpDown = false
      self.constraintTopView.constant = self.view.frame.height - 50
      self.view.layoutIfNeeded()
    })
  }
  
  
  @IBAction func btnPlayPause(_ sender: Any) {
    
    if btnPlayPause.isSelected == false{
      btnPlayPause.isSelected = true
      btnPlayPause.setImage(UIImage(named: "pause"), for: .normal)
      btnPlayPauseHeader.isSelected = true
      btnPlayPauseHeader.setImage(UIImage(named: "pause"), for: .normal)
      
    }else{
      
      btnPlayPause.isSelected = false
      btnPlayPause.setImage(UIImage(named: "play"), for: .normal)
      btnPlayPauseHeader.isSelected = false
      btnPlayPauseHeader.setImage(UIImage(named: "play"), for: .normal)
    }
  }
  
  @IBAction func btnVolumeChanger(_ sender: Any) {
   
    if btnVolume.isSelected == true{
      btnVolume.isSelected = false
      
      UIView.animate(withDuration: 0.3) {
        self.constraintTopVolumeView.constant = -70
        self.view.layoutIfNeeded()
      }
      
    }else{
      btnVolume.isSelected = true
      
      UIView.animate(withDuration: 0.3) {
        self.constraintTopVolumeView.constant = 0
        self.view.layoutIfNeeded()
      }
      
    }
  }
  
  @IBAction func btnSuffle(_ sender: Any) {
    
    if isSuffle == true{
      
      isSuffle = false
      
    }else{
     
      isSuffle = true
      
    }
  }
  
  
  @IBAction func btnRepeat(_ sender: Any) {
    
    if isRepeat == false{
      
      isRepeat = true
      
      
    }else{
      
      self.jukebox.seek(toSecond: 0, shouldPlay: false)
      
      isRepeat = false
      
    }
  }
  
}

// MARK:- JukeboxDelegate -
extension MusicPlayerVC: JukeboxDelegate{

  func jukeboxStateDidChange(_ jukebox: Jukebox) {
    
    UIView.animate(withDuration: 0.3, animations: { () -> Void in
      self.indicator.alpha = jukebox.state == .loading ? 1 : 0
      self.btnPlayPause.alpha = jukebox.state == .loading ? 0 : 1
      self.btnPlayPause.isEnabled = jukebox.state == .loading ? false : true
      
      if self.isUpDown == false{
        self.btnPlayPauseHeader.alpha = jukebox.state == .loading ? 0 : 1
        self.btnPlayPauseHeader.isEnabled = jukebox.state == .loading ? false : true
      }

    })
    
    if jukebox.state == .ready {
      btnPlayPause.setImage(UIImage(named: "play"), for: .normal)
      
      if self.isUpDown == false{
        btnPlayPauseHeader.setImage(UIImage(named: "play"), for: .normal)
      }

    } else if jukebox.state == .loading  {
      btnPlayPause.setImage(UIImage(named: "pause"), for: .normal)
      
      if self.isUpDown == false{
        btnPlayPauseHeader.setImage(UIImage(named: "play"), for: .normal)
      }

    } else {
      sliderVolume.value = jukebox.volume
      let imageName: String
      switch jukebox.state {
      case .playing, .loading:
        imageName = "pause"
      case .paused, .failed, .ready:
        imageName = "play"
      }
      btnPlayPause.setImage(UIImage(named: imageName), for: .normal)
      
      if self.isUpDown == false{
        btnPlayPauseHeader.setImage(UIImage(named: imageName), for: .normal)
      }

    }
    
    print("Jukebox state changed to \(jukebox.state)")
  }
  
  
  func jukeboxPlaybackProgressDidChange(_ jukebox: Jukebox) {
    
    if let currentTime = jukebox.currentItem?.currentTime, let duration = jukebox.currentItem?.meta.duration {
      let value = Float(currentTime / duration)
      
      DispatchQueue.main.async {
        self.populateLabelWithTime(self.lblStartTimer, time: currentTime)
        self.populateLabelWithTime(self.lblEndTimer, time: duration)
        self.sliderAudio.setValue(value, animated: true)
        
      }
    } else {
      resetUI()
    }
  }

  
  func jukeboxDidLoadItem(_ jukebox: Jukebox, item: JukeboxItem) {
    
    if isRepeat == true{
      
      self.jukebox.play(atIndex: jukebox.playIndex)
      updateAudioPlayer(positon: jukebox.playIndex)
      
    }else{
      
      updateAudioPlayer(positon: jukebox.playIndex)
      
    }
    
 
    
    print("Jukebox did load: \(item.URL.lastPathComponent)")
  }
  
  func jukeboxDidUpdateMetadata(_ jukebox: Jukebox, forItem: JukeboxItem) {
    print("Item updated:\n\(forItem)")
  }
  
  override func remoteControlReceived(with event: UIEvent?) {
    if event?.type == .remoteControl {
      switch event!.subtype {
      case .remoteControlPlay :
        jukebox.play()
      case .remoteControlPause :
        jukebox.pause()
      case .remoteControlNextTrack :
        jukebox.playNext()
      case .remoteControlPreviousTrack:
        jukebox.playPrevious()
      case .remoteControlTogglePlayPause:
        if jukebox.state == .playing {
          jukebox.pause()
        } else {
          jukebox.play()
        }
      default:
        break
      }
    }
  }
  
  
  // MARK:- Callbacks -
  
  @IBAction func volumeSliderValueChanged() {
    if let jk = jukebox {
      jk.volume = sliderVolume.value
    }
  }
  
  @IBAction func progressSliderValueChanged() {
    if let duration = jukebox.currentItem?.meta.duration {
      jukebox.seek(toSecond: Int(Double(sliderAudio.value) * duration))
    }
  }
  
  @IBAction func prevAction() {
    
    if let time = jukebox.currentItem?.currentTime, time > 5.0 || jukebox.playIndex == 0 {
      jukebox.replayCurrentItem()
    } else {
      jukebox.playPrevious()
    }
  }
  
  @IBAction func nextAction() {
    jukebox.playNext()
  }
  
  @IBAction func playPauseAction() {
    switch jukebox.state {
    case .ready :
      jukebox.play(atIndex: 0)
    case .playing :
      jukebox.pause()
    case .paused :
      jukebox.play()
    default:
      jukebox.stop()
    }
  }
  
  @IBAction func replayAction() {
    /*resetUI()
    jukebox.replay()
    */
  }
  
  @IBAction func stopAction() {
    resetUI()
    jukebox.stop()
  }
  
  
  //MARK:- Helpers
  func populateLabelWithTime(_ label : UILabel, time: Double) {
    let minutes = Int(time / 60)
    let seconds = Int(time) - minutes * 60
    
    label.text = String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds)
  }
  
  func resetUI()
  {
    lblStartTimer.text = "00:00"
    lblEndTimer.text = "00:00"
    sliderAudio.value = 0
  }
  
}

