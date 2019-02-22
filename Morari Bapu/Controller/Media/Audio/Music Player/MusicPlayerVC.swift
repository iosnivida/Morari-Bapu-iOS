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

class MusicPlayerVC: PullUpController {

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
  
  @IBOutlet weak var constraintTopVolumeView: NSLayoutConstraint!
  
  var arrAudioList = [JSON]()
  
  var playPosition = Int()
  
  var isUpDown = false
  var isSuffle = false
  var isRepeat = false
  
  //Jukbok
  var jukebox : Jukebox!
  
  
  @IBOutlet private weak var viewMusicBar: UIView!

  
  var initialPointOffset: CGFloat {
    return pullUpControllerPreferredSize.height
  }
  
  public var portraitSize: CGSize = .zero
  public var landscapeFrame: CGRect = .zero
  
  
  override func viewDidLoad() {
        super.viewDidLoad()

      playPosition = 0
      // begin receiving remote events
      UIApplication.shared.beginReceivingRemoteControlEvents()

      self.constraintTopVolumeView.constant = -70
      self.view.layoutIfNeeded()
    
//      self.constraintTopView.constant = self.view.frame.height - 50
//      self.constraintMainViewHeight.constant = self.view.frame.height - 20
      self.view.layoutIfNeeded()

    
 
    
    portraitSize = CGSize(width: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height),
                          height: viewMusicBar.frame.size.height + 20)
    
    view.layer.cornerRadius = 12
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.audioPlayList), name: NSNotification.Name(rawValue: "audioPlayList"), object: nil)
    
  }

  
  @objc func audioPlayList(_ notification: Notification) {
    print(notification)
    
    arrAudioList =  notification.object as! [JSON]
    
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
    
      DispatchQueue.main.async {
     self.jukebox.play(atIndex: self.playPosition)
     self.updateAudioPlayer(positon: self.playPosition)
     }
    
  }
  
    override func pullUpControllerWillMove(to stickyPoint: CGFloat) {
      //        print("will move to \(stickyPoint)")
    }
  
    override func pullUpControllerDidMove(to stickyPoint: CGFloat) {
      //        print("did move to \(stickyPoint)")
    }
  
    override func pullUpControllerDidDrag(to point: CGFloat) {
      //        print("did drag to \(point)")
    }
  
  // MARK: - PullUpController
  
  override var pullUpControllerPreferredSize: CGSize {
    return portraitSize
  }
  
  override var pullUpControllerPreferredLandscapeFrame: CGRect {
    return landscapeFrame
  }
  
  override var pullUpControllerMiddleStickyPoints: [CGFloat] {
    return [viewMusicBar.frame.maxY, self.view.frame.maxY]
    
  }
  
  override var pullUpControllerBounceOffset: CGFloat {
    return 20
  }
  
  override func pullUpControllerAnimate(action: PullUpController.Action,
                                        withDuration duration: TimeInterval,
                                        animations: @escaping () -> Void,
                                        completion: ((Bool) -> Void)?) {
    switch action {
    case .move:
      UIView.animate(withDuration: 0.3,
                     delay: 0,
                     usingSpringWithDamping: 1.0,
                     initialSpringVelocity: 0,
                     options: .curveEaseInOut,
                     animations: animations,
                     completion: completion)
    default:
      UIView.animate(withDuration: 0.3,
                     animations: animations,
                     completion: completion)
    }
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
      
      pullUpControllerMoveToVisiblePoint(pullUpControllerMiddleStickyPoints[0], animated: true, completion: nil)

      UIView.animate(withDuration: 0.3, animations: {
        self.isUpDown = true
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
        self.view.layoutIfNeeded()
      })
    }
  }
  
  @IBAction func swipeUp(_ sender: Any) {
    UIView.animate(withDuration: 0.3, animations: {
      self.isUpDown = true
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
    
    if isSuffle == false{
      
      isSuffle = true
      self.btnSuffle.imageColorChange(imageColor: .black)
      
    }else{
     
      isSuffle = false
      self.btnSuffle.imageColorChange(imageColor: UIColor.init(red: 112.0/255.0, green: 112.0/255.0, blue: 112.0/255.0, alpha: 1.0))
    }
  }
  
  
  @IBAction func btnRepeat(_ sender: Any) {
    
    if isRepeat == false{
      
      isRepeat = true
      self.btnRepeat.imageColorChange(imageColor: .black)
      
    }else{
      
      isRepeat = false
      self.btnRepeat.imageColorChange(imageColor: UIColor.init(red: 112.0/255.0, green: 112.0/255.0, blue: 112.0/255.0, alpha: 1.0))
      
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
    
    print(self.playPosition)
    
    print("State: \(jukebox.state.description)")
    if isRepeat == true{
      jukebox.seek(toSecond: 0, shouldPlay: true)
    }else if isSuffle == true{
      updateAudioPlayer(positon: jukebox.playIndex)
    }
    else{
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
    
    if isRepeat == true{
      jukebox.seek(toSecond: 0, shouldPlay: true)
    }
    else if isSuffle == true{
      let randomIndex = Int(arc4random_uniform(UInt32(arrAudioList.count)))
      jukebox.play(atIndex: randomIndex)
      updateAudioPlayer(positon: randomIndex)
    }
    else{
      if let time = jukebox.currentItem?.currentTime, time > 5.0 || jukebox.playIndex == 0 {
        jukebox.replayCurrentItem()
      } else {
        jukebox.playPrevious()
      }
    }
    
  }
  
  @IBAction func nextAction()
  {
    if isRepeat == true{
      jukebox.seek(toSecond: 0, shouldPlay: true)
    }else if isSuffle == true{
      let randomIndex = Int(arc4random_uniform(UInt32(arrAudioList.count)))
      jukebox.play(atIndex: randomIndex)
      updateAudioPlayer(positon: randomIndex)
    }
    else{
      jukebox.playNext()
    }
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
