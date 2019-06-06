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
import MarqueeLabel
import AudioPlayerManager
import MediaPlayer
import LNPopupController
import  SwiftyUserDefaults
import SubtleVolume

fileprivate struct Keys {
  static let Status  = "status"
}

class MusicPlayerVC: UIViewController {
  
  @IBOutlet weak var imgThumbnil: UIImageView!
  @IBOutlet weak var lblTitleHeader: UILabel!
  @IBOutlet weak var lblSubTitleHeader: MarqueeLabel!
  
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
  
  fileprivate var player                  : AVPlayer?

  var arrAudioList = [JSON]()
  var playList : [String] = []
  
  
  var isUpDown = false
  var isSuffle = false
  var isRepeat = false
  
  var screenType = String()
  var playPosition = Int()

  var tempAudioSliderValue: Float = 0.0

  
  @IBOutlet private weak var viewMusicBar: UIView!

  
  public var portraitSize: CGSize = .zero
  public var landscapeFrame: CGRect = .zero
  
  //MARK: - Variables
  var playBarButton: UIBarButtonItem!
  var puseBarButton: UIBarButtonItem!
  var nextBarButton: UIBarButtonItem!

  let volume = SubtleVolume(style: .rounded)

  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    tempAudioSliderValue = sliderVolume.value
    
    volume.delegate = self

    btnSuffle.isHidden = true
    btnRepeat.isHidden = true

    self.constraintTopVolumeView.constant = -70
    self.view.layoutIfNeeded()
    
    
    AudioPlayerManager.shared.setup()
    AudioPlayerManager.shared.playingTimeRefreshRate = 0.1
    
//      self.constraintTopView.constant = self.view.frame.height - 50
//      self.constraintMainViewHeight.constant = self.view.frame.height - 20
      self.view.layoutIfNeeded()

    lblSubTitleHeader.type = .rightLeft
    lblSubTitleHeader.speed = .rate(60)
    lblSubTitleHeader.fadeLength = 10.0
    lblSubTitleHeader.leadingBuffer = 30.0
    lblSubTitleHeader.trailingBuffer = 20.0
    
    portraitSize = CGSize(width: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height),
                          height: viewMusicBar.frame.size.height + 20)
 
    // Listen to the player state updates. This state is updated if the play, pause or queue state changed.
    AudioPlayerManager.shared.addPlayStateChangeCallback(self, callback: { [weak self] (track: AudioTrack?) in
      
      let asset = AudioPlayerManager.shared.currentTrack?.playerItem?.asset
      if asset != nil {
        if let urlAsset = asset as? AVURLAsset {
          print(urlAsset.url)
          
          for (index,urlPlay) in self!.playList.enumerated(){
            
            if urlPlay == "\(urlAsset.url)"{
              self!.playPosition = index
              
              
              if self!.screenType == "HanumanChalisha"{
                
                AudioPlayerManager.shared.currentTrack?.nowPlayingInfo?[MPMediaItemPropertyTitle] = "Hanuman Chalisha" as NSObject?
                AudioPlayerManager.shared.currentTrack?.nowPlayingInfo?[MPMediaItemPropertyAlbumTitle] = "Hanuman Chalish By Morari Bapu" as NSObject?
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playPosition"), object: self!.playPosition)
              }
               else if self?.screenType == "whatsnewaudio"{
                  
                  if self!.arrAudioList.count != 0{
                    
                    AudioPlayerManager.shared.currentTrack?.nowPlayingInfo?[MPMediaItemPropertyTitle] = "\(self!.arrAudioList[self!.playPosition]["title"].stringValue)" as NSObject?
                    AudioPlayerManager.shared.currentTrack?.nowPlayingInfo?[MPMediaItemPropertyAlbumTitle] = "Morari Bapu's Sankirtan" as NSObject?
                  }
                  
                }else{
                  
                  if self!.arrAudioList.count != 0{
                    
                    AudioPlayerManager.shared.currentTrack?.nowPlayingInfo?[MPMediaItemPropertyTitle] = "\(self!.arrAudioList[self!.playPosition]["name"].stringValue)" as NSObject?
                    AudioPlayerManager.shared.currentTrack?.nowPlayingInfo?[MPMediaItemPropertyAlbumTitle] = "Morari Bapu's Sankirtan" as NSObject?
                    
                }
              }
            }
          }
          
          self!.updateAudioPlayer(positon: self!.playPosition)
          
        }
      }else{
        self!.updateAudioPlayer(positon: self!.playPosition)
      }
      
      self?.updateButtonStates()
      self?.updateSongInformation(with: track)
      
      
    })
    // Listen to the playback time changed. Thirs event occurs every `AudioPlayerManager.PlayingTimeRefreshRate` seconds.
    AudioPlayerManager.shared.addPlaybackTimeChangeCallback(self, callback: { [weak self] (track: AudioTrack?) in
          self?.updatePlaybackTime(track)
    })
    
    
    
    self.updateButtonStates()
    self.updateAudioPlayer(positon: self.playPosition)

    //NotificationCenter.default.addObserver(value, selector: #selector(SubtleVolume.resume), name: UIApplication.didBecomeActiveNotification, object: nil)
    
  }
  
 
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    puseBarButton = UIBarButtonItem(image: UIImage.init(named: "pause-bar"), style: .plain, target: self, action: #selector(didPressPlayPauseButton(_:)))
    playBarButton = UIBarButtonItem(image: UIImage.init(named: "play-bar"), style: .plain, target: self, action: #selector(didPressPlayPauseButton(_:)))
    nextBarButton = UIBarButtonItem(image: UIImage.init(named: "forward-bar"), style: .plain, target: self, action: #selector(didPressForwardButton))

    
    if UserDefaults.standard.object(forKey: "PopupSettingsBarStyle") as? LNPopupBarStyle == LNPopupBarStyle.compact || ProcessInfo.processInfo.operatingSystemVersion.majorVersion < 10 {
      popupItem.leftBarButtonItems = [ puseBarButton ]
      popupItem.rightBarButtonItems = [ nextBarButton ]
    }
    else {
      popupItem.rightBarButtonItems = [ puseBarButton, nextBarButton ]
    }
    
  }
  
  deinit {
    // Stop listening to the callbacks
    AudioPlayerManager.shared.removePlayStateChangeCallback(self)
    AudioPlayerManager.shared.removePlaybackTimeChangeCallback(self)
  }
  
  //Audio Management
  
  func initPlaybackTimeViews() {
    self.sliderAudio?.value = 0
    self.sliderAudio?.maximumValue = 1.0
    self.lblStartTimer?.text = "-:-"
    self.lblEndTimer?.text = "-:-"
    popupItem.progress = 0
  }

  func updateButtonStates() {
    
    self.btnPrevious?.isEnabled = AudioPlayerManager.shared.canRewind()
    
    let imageName = (AudioPlayerManager.shared.isPlaying() == true ? "pause" : "play")
    
    self.btnPlayPause?.setImage(UIImage(named: imageName), for: UIControl.State())
    
    if AudioPlayerManager.shared.isPlaying() == true{
      popupItem.rightBarButtonItems = [ puseBarButton, nextBarButton ]
    }else{
      popupItem.rightBarButtonItems = [ playBarButton, nextBarButton ]
    }
    
    //self.btnPlayPause?.isEnabled = AudioPlayerManager.shared.canPlay()
    
    
    self.btnNext?.isEnabled = AudioPlayerManager.shared.canForward()
    
    
  }
  
  func updateSongInformation(with track: AudioTrack?) {
    //self.songLabel?.text = "\((track?.nowPlayingInfo?[MPMediaItemPropertyTitle] as? String) ?? "-")"
    //self.albumLabel?.text = "\((track?.nowPlayingInfo?[MPMediaItemPropertyAlbumTitle] as? String) ?? "-")"
    //self.artistLabel?.text = "\((track?.nowPlayingInfo?[MPMediaItemPropertyArtist] as? String) ?? "-")"
    
  }
  
  func updatePlaybackTime(_ track: AudioTrack?) {

    self.lblStartTimer?.text = track?.displayablePlaybackTimeString() ?? "-:-"
    self.lblEndTimer?.text = track?.displayableDurationString() ?? "-:-"
    self.sliderAudio?.value = track?.currentProgress() ?? 0
    popupItem.progress = track?.currentProgress() ?? 0
  }
  
  //***************************** End Audio Player Management ******************************
 
  func updateAudioPlayer(positon:Int){
    
    if screenType == "HanumanChalisha"{
      
      DispatchQueue.main.async {
        
        UserDefaults.standard.set(self.playPosition, forKey: "playposition")
        UserDefaults.standard.set(self.screenType, forKey: "screentype")
        
        self.lblTitleHeader.text = "Hanuman Chalisa"
        self.lblSubTitleHeader.text = "Hanuman Chalish By Morari Bapu"
        self.lblTitle.text = "Hanuman Chalisa"
        self.lblSubTitle.text = "Hanuman Chalish By Morari Bapu"
        
        let placeHolder = UIImage(named: "youtube_placeholder")
        
        self.popupItem.title = "Hanuman Chalisa"
        self.popupItem.subtitle = "Hanuman Chalish By Morari Bapu"
        self.popupItem.image = placeHolder
        
        self.imgThumbnil.kf.indicatorType = .activity
        self.imgThumbnil.kf.setImage(with: URL(string: ""), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
        
        self.imgBigThumbnil.kf.indicatorType = .activity
        self.imgBigThumbnil.kf.setImage(with: URL(string: ""), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
        self.lblOutOfAudio.text = "1/1"
        
        self.lblStartTimer.text = "00:00"
        self.lblEndTimer.text = "06:35"
        
      }
      
    }else{
      
      let dict = arrAudioList[positon]
      
      DispatchQueue.main.async {
        
        UserDefaults.standard.set(self.playPosition, forKey: "playposition")
        UserDefaults.standard.set(self.screenType, forKey: "screentype")
        
        let placeHolder = UIImage(named: "youtube_placeholder")
        
        self.lblTitleHeader.text = dict["name"].stringValue
        self.lblSubTitleHeader.text = "(Duration: \(dict["duration"].stringValue))"
        self.lblTitle.text = dict["name"].stringValue 
        self.lblSubTitle.text = dict["description"].stringValue
        
        self.popupItem.title = dict["name"].stringValue
        self.popupItem.subtitle = "(Duration: \(dict["duration"].stringValue))"
        self.popupItem.image = placeHolder
      
        
        self.imgThumbnil.kf.indicatorType = .activity
        self.imgThumbnil.kf.setImage(with: URL(string: "\(BASE_URL_IMAGE)\(dict["image_file"].stringValue)"), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
        
        self.imgBigThumbnil.kf.indicatorType = .activity
        self.imgBigThumbnil.kf.setImage(with: URL(string: "\(BASE_URL_IMAGE)\(dict["image_file"].stringValue)"), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
        
        if self.arrAudioList.count == positon{
          self.lblOutOfAudio.text = "\(positon+1)/\(self.arrAudioList.count)"
        }else{
          self.lblOutOfAudio.text = "\(positon+1)/\(self.arrAudioList.count)"
        }
        self.lblStartTimer.text = "00:00"
        self.lblEndTimer.text = dict["duration"].stringValue

      }
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
  
  @IBAction func btnVolumeUpDown(_ sender: UISlider) {
    
    do {
      try volume.setVolumeLevel(Double(sender.value), animated: true)
    } catch {
      print("The demo must run on a real device, not the simulator")
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
  
  @IBAction func btnShare(_ sender: Any) {
    
    let share_Content = "Audio \n\nI am listening - \(self.lblTitleHeader.text ?? "") \n\nvia MorariBapu - \(BASE_URL_IMAGE)\(playList[playPosition])\n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
    
    let textToShare = [share_Content]
    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
    
    // exclude some activity types from the list (optional)
    activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
    
    DispatchQueue.main.async {
      self.present(activityViewController, animated: true, completion: nil)
    }
  }
}


// MARK: - IBActions

extension MusicPlayerVC {
  
  @IBAction func didPressRewindButton(_ sender: AnyObject) {
    AudioPlayerManager.shared.rewind()
  }
  
  @IBAction func didPressStopButton(_ sender: AnyObject) {
    AudioPlayerManager.shared.stop()
  }
  
  @IBAction func didPressPlayPauseButton(_ sender: AnyObject) {
    
    if self.screenType == "HanumanChalisha"{
      
      if AudioPlayerManager.shared.isPlaying() != true{
        
        AudioPlayerManager.shared.currentTrack?.nowPlayingInfo?[MPMediaItemPropertyTitle] = "Hanuman Chalisha" as NSObject?
        AudioPlayerManager.shared.currentTrack?.nowPlayingInfo?[MPMediaItemPropertyAlbumTitle] = "Hanuman Chalish By Morari Bapu" as NSObject?
        
        UserDefaults.standard.set(self.playPosition, forKey: "playposition")
        UserDefaults.standard.set(self.screenType, forKey: "screentype")
        
        self.playList = ["http://app.nivida.in/moraribapu/files/chalisa.mp3"]
        AudioPlayerManager.shared.play(urlStrings: self.playList, at: 0)
      }
      
      AudioPlayerManager.shared.togglePlayPause()
    }else{
        AudioPlayerManager.shared.togglePlayPause()
    }
    
  }
  
  @IBAction func didPressForwardButton(_ sender: AnyObject) {
    AudioPlayerManager.shared.forward()
  }
  
  @IBAction func didChangeTimeSliderValue(_ sender: Any) {
    guard let newProgress = self.sliderAudio?.value else {
      return
    }
    
    popupItem.progress = newProgress
    AudioPlayerManager.shared.seek(toProgress: newProgress)
  }
}


extension MusicPlayerVC: SubtleVolumeDelegate {
  func subtleVolume(_ subtleVolume: SubtleVolume, accessoryFor value: Double) -> UIImage? {
    return value > 0 ? #imageLiteral(resourceName: "volume-on.pdf") : #imageLiteral(resourceName: "volume-off.pdf")
  }
  
  func subtleVolume(_ subtleVolume: SubtleVolume, didChange value: Double) {
  }
  
  func subtleVolume(_ subtleVolume: SubtleVolume, willChange value: Double) {
    
  }
}
