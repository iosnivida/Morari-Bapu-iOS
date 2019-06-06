//
//  KathaEBookVC.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 07/10/18.
//  Copyright © 2018 Bhavin Chauhan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import LNPopupController
import AudioPlayerManager

enum AudioScreenIdentifier {
  case Stuti
  case Sankirtan
  case Others
  case WhatsNewAudio
}


class AudioVC: UIViewController {
  
  @IBOutlet weak var lblTitle: UILabel!
  @IBOutlet weak var tblAudio: UITableView!
  var arrAudio = [JSON]()
  var screenDirection = AudioScreenIdentifier.Stuti
  var arrFavourite = NSMutableArray()

  var currentPageNo = Int()
  var totalPageNo = Int()
  var is_Api_Being_Called : Bool = false
  var playingIndex : Int = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    currentPageNo = 1
    
    tblAudio.tableFooterView =  UIView.init(frame: .zero)
    tblAudio.layoutMargins = .zero
    
    tblAudio.rowHeight = 110
    tblAudio.estimatedRowHeight = UITableView.automaticDimension
    
    if screenDirection == .Stuti{
      lblTitle.text = "Stuti"
    }else if screenDirection == .Sankirtan{
      lblTitle.text = "Sankirtan"
    }else if screenDirection == .Others{
      lblTitle.text = "Others"
    }else if screenDirection == .WhatsNewAudio{
      lblTitle.text = "Audio"
    }
    
    DispatchQueue.main.async {
      self.arrAudio.removeAll()
      self.getAudio(pageNo: self.currentPageNo)
    }
    
    
    //***********************
    
    // Add reachability observer
    if let reachability = AppDelegate.sharedAppDelegate()?.reachability
    {
      NotificationCenter.default.addObserver( self, selector: #selector( self.reachabilityChanged ),name: Notification.Name.reachabilityChanged, object: reachability )
    }
    
    //************************
    self.setupMimiMusicPlayerView()
    
    
    if AudioPlayerManager.shared.isPlaying() == false{
      
      let storyboard = UIStoryboard(name: Custome_Storyboard, bundle: nil)
      let mPlayer = storyboard.instantiateViewController(withIdentifier: "MusicPlayerVC") as! MusicPlayerVC
      mPlayer.screenType = "HanumanChalisha"
      mPlayer.playPosition = 0
      self.navigationController?.popupBar.marqueeScrollEnabled = true
      self.navigationController?.presentPopupBar(withContentViewController: mPlayer, animated: true, completion: nil)

      /*let storyboard = UIStoryboard(name: Custome_Storyboard, bundle: nil)
      let mPlayer = storyboard.instantiateViewController(withIdentifier: "MusicPlayerVC") as! MusicPlayerVC
      mPlayer.screenType = "HanumanChalisha"
      mPlayer.playPosition = 0      
      self.navigationController?.pushViewController(mPlayer, animated: false)*/
      
    }
    
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.musicIndicator(_:)), name: NSNotification.Name(rawValue: "playPosition"), object: nil)

    
    //audioDetails(position, listOfAudio, "AudioList")
  }
  

  //MARK:- Api Call
  func getAudio(pageNo:Int){
    
    
    var api_Url = String()
    var param = NSDictionary()
    if screenDirection == .Stuti{
      api_Url = WebService_Stuti_List
      
      param = ["page" : pageNo,
               "app_id":Utility.getDeviceID(),
               "stuti_type_id":"1",
               "favourite_for":"5"] as NSDictionary
      
      
    }else if screenDirection == .Sankirtan{
      api_Url = WebService_Sankirtan_Audio
      
      param = ["page" : pageNo,
               "app_id":Utility.getDeviceID(),
               "favourite_for":"8"] as NSDictionary
      
      
    }else if screenDirection == .Others{
      api_Url = WebService_Stuti_List
      
      param = ["page" : pageNo,
               "app_id":Utility.getDeviceID(),
               "stuti_type_id":"2",
               "favourite_for":"10"] as NSDictionary
      
    }else if screenDirection == .WhatsNewAudio{
      
      api_Url = WebService_Whats_New_Audio
      
      param = ["page" : pageNo,
               "app_id":Utility.getDeviceID(),
               "audio_id":"1",
               "favourite_for":"19"] as NSDictionary
    }
    
    WebServices().CallGlobalAPI(url: api_Url,headers: [:], parameters: param, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
      
      if(jsonResponce?.error != nil) {
        
        var errorMess = jsonResponce?.error?.localizedDescription
        errorMess = MESSAGE_Err_Service
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
      }
      else {
        
        if jsonResponce!["status"].stringValue == "true"{
          self.totalPageNo = jsonResponce!["total_page"].intValue
          
          for result in jsonResponce!["data"].arrayValue {
            self.arrAudio.append(result)
          }
          
          
          for result in jsonResponce!["MyFavourite"].arrayValue {
            self.arrFavourite.add(result.stringValue)
          }
          
          self.is_Api_Being_Called = false


          if self.arrAudio.count != 0{
            
            DispatchQueue.main.async {
              self.tblAudio .reloadData()
              Utility.tableNoDataMessage(tableView: self.tblAudio, message: "", messageColor: UIColor.black, displayMessage: .Center)
            }
          }
          
        }else if jsonResponce!["status"].stringValue == "false"{
          
          if jsonResponce!["message"].stringValue == "No Data Found"{
            
            DispatchQueue.main.async {
              self.tblAudio.reloadData()
              Utility.tableNoDataMessage(tableView: self.tblAudio, message: "Coming Soon", messageColor: UIColor.white, displayMessage: .Center)
            }
          }
        }
        else {
          self.is_Api_Being_Called = false

          Utility().showAlertMessage(vc: self, titleStr: "", messageStr: jsonResponce!["message"].stringValue)
        }
      }
    }
  }
  
  //MARK:- Button Event
  @IBAction func btnMenu(_ sender: Any) {
    Utility.menu_Show(onViewController: self)
  }
  
  @IBAction func btnHanumanChalisha(_ sender: Any) {
    let storyboardCustom : UIStoryboard = UIStoryboard(name: Custome_Storyboard, bundle: nil)
    let objVC = storyboardCustom.instantiateViewController(withIdentifier: "HanumanChalishaVC") as? HanumanChalishaVC
    self.navigationController?.pushViewController(objVC!, animated: true)
  }
  
  @IBAction func btnBack(_ sender: Any) {
    self.navigationController?.popViewController(animated:true)
  }
  
  @IBAction func backToHome(_ sender: Any) {
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  //LNPopupController
  private func setupMimiMusicPlayerView() {
    UIProgressView.appearance(whenContainedInInstancesOf: [LNPopupBar.self]).tintColor = UIColor.colorFromHex("#068201")
    
    self.navigationController?.popupBar.progressViewStyle = .top
    self.navigationController?.popupBar.barStyle = .custom
    self.navigationController?.popupInteractionStyle = .drag
    self.navigationController!.popupContentView.popupCloseButtonStyle = .round
    self.navigationController?.popupBar.imageView.layer.cornerRadius = 5
    self.navigationController?.toolbar.barStyle = .blackOpaque
    self.navigationController?.popupBar.tintColor = .white
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .left
    self.navigationController?.popupBar.subtitleTextAttributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
    self.navigationController?.popupBar.titleTextAttributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
    self.navigationController?.updatePopupBarAppearance()
  }
  
  //MARK:- Misic
  @objc func musicIndicator(_ notification: NSNotification) {
    
    playingIndex = (notification.object as? Int)!
    tblAudio.reloadData()
    
  }
  
  
}

extension AudioVC : UITableViewDelegate, UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return arrAudio.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
    let cellIdentifier = "AudioTableViewCell"
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AudioTableViewCell  else {
      fatalError("The dequeued cell is not an instance of MealTableViewCell.")
    }
    
    let data = arrAudio[indexPath.row]
    
 
    if screenDirection == .WhatsNewAudio{
        cell.btnFavourite.isHidden = true
      cell.lblbTitle.text = data["title"].stringValue
      cell.constraintShareRight.constant = 8

    }else{
      cell.btnFavourite.isHidden = false
      cell.lblbTitle.text = data["name"].stringValue

    }
    
    cell.lblDuration.text = "(Duration: \(data["duration"].stringValue))"
    cell.btnShare.tag  = indexPath.row
    cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
    
    cell.btnFavourite.tag  = indexPath.row
    cell.btnFavourite.addTarget(self, action: #selector(btnFavourite), for: UIControl.Event.touchUpInside)

    
    let predicate: NSPredicate = NSPredicate(format: "SELF contains[cd] %@", data["id"].stringValue)
    let result = self.arrFavourite.filtered(using: predicate)
    
    if result.count != 0{
      cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
    }else{
      cell.btnFavourite.setImage(UIImage(named: "unfavorite"), for: .normal)
    }
    
    if UserDefaults.standard.string(forKey: "screentype") != nil && UserDefaults.standard.string(forKey: "playposition") != nil{
    
      let screenType = UserDefaults.standard.string(forKey: "screentype") ?? ""
      self.playingIndex = Int(UserDefaults.standard.string(forKey: "playposition") ?? "") ?? 0
      
      if screenType == "stuti" && screenDirection == .Stuti{
        
        if self.playingIndex == indexPath.row{
          cell.viewMusicIndicator.isHidden = false
          cell.viewMusicIndicator.state = .playing
          cell.viewMusicIndicator.tintColor = .red
          
        }else{
          cell.viewMusicIndicator.isHidden = true
        }
        
      }else if screenType == "sankirtan" && screenDirection == .Sankirtan{
        
        if playingIndex == indexPath.row{
          cell.viewMusicIndicator.isHidden = false
          cell.viewMusicIndicator.state = .playing
          cell.viewMusicIndicator.tintColor = .red
          
        }else{
          cell.viewMusicIndicator.isHidden = true
        }
        
      }else if screenType == "others" && screenDirection == .Others{
        
        if playingIndex == indexPath.row{
          cell.viewMusicIndicator.isHidden = false
          cell.viewMusicIndicator.state = .playing
          cell.viewMusicIndicator.tintColor = .red
          
        }else{
          cell.viewMusicIndicator.isHidden = true
        }
        
      }else if screenType == "whatsnewaudio" && screenDirection == .WhatsNewAudio{
        
        if playingIndex == indexPath.row{
          cell.viewMusicIndicator.isHidden = false
          cell.viewMusicIndicator.state = .playing
          cell.viewMusicIndicator.tintColor = .red
          
        }else{
          cell.viewMusicIndicator.isHidden = true
        }
      }else{
        cell.viewMusicIndicator.isHidden = true
      }
    }else{
      cell.viewMusicIndicator.isHidden = true
    }
    
    
    //Notification readable or not
    if data["is_read"].boolValue == false{
      //Non-Readable notification
      cell.viewBackground.backgroundColor = UIColor.colorFromHex("#d3d3d3")
      
    }else{
      //Readable notification
      cell.viewBackground.backgroundColor = UIColor.colorFromHex("#ffffff")
    }
    
    return cell
    
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    var data = arrAudio[indexPath.row]
    
    if screenDirection == .Stuti{
      
      if data["is_read"].intValue == 0{
        
        data["is_read"] = true;
        
        arrAudio[indexPath.row] = data
        
        let indexPath = NSIndexPath(row: indexPath.row, section: 0)
        tblAudio.reloadRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.none)
        
        let param = ["app_id":Utility.getDeviceID(),
                     "stuti_id":data["id"].stringValue] as NSDictionary
        
        Utility.readUnread(api_Url: WebService_Struti_Media_Read_Unread, parameters: param)
        
      }
      
    }else if screenDirection == .Sankirtan{
      
      if data["is_read"].intValue == 0{
        
        data["is_read"] = true;
        
        arrAudio[indexPath.row] = data
        
        let indexPath = NSIndexPath(row: indexPath.row, section: 0)
        tblAudio.reloadRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.none)
        
        let param = ["app_id":Utility.getDeviceID(),
                     "sankirtan_id":data["id"].stringValue] as NSDictionary
        
        Utility.readUnread(api_Url: WebService_Sankirtan_Read_Unread, parameters: param)
        
      }
      
    }else if screenDirection == .Others{
      
    }else if screenDirection == .WhatsNewAudio{
    
      data["is_read"] = true;
      
      arrAudio[indexPath.row] = data
      
      let indexPath = NSIndexPath(row: indexPath.row, section: 0)
      tblAudio.reloadRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.none)
      
      if data["is_read"].intValue == 0{
        
        let param = ["app_id":Utility.getDeviceID(),
                     "audio_id":data["id"].stringValue] as NSDictionary
        
        Utility.readUnread(api_Url: WebService_Audio_Whats_New_Read_Unread, parameters: param)
        
      }
      
    }
    
    playingIndex = indexPath.row
    
    tblAudio.reloadData()
    
    var playList : [String] = []
    
    for audio in arrAudio{
      playList.append("\(BASE_URL_IMAGE)\(audio["audio_file"].stringValue)")
    }
    
    AudioPlayerManager.shared.play(urlStrings: playList, at: indexPath.row)
    
    if screenDirection == .Stuti{
      
      let storyboard = UIStoryboard(name: Custome_Storyboard, bundle: nil)
      let mPlayer = storyboard.instantiateViewController(withIdentifier: "MusicPlayerVC") as! MusicPlayerVC
      mPlayer.playPosition = indexPath.row
      mPlayer.playList = playList
      mPlayer.arrAudioList = arrAudio
      mPlayer.screenType = "stuti"
      self.navigationController?.popupBar.marqueeScrollEnabled = true
      self.navigationController?.presentPopupBar(withContentViewController: mPlayer, animated: true, completion: nil)
      
    }else if screenDirection == .Sankirtan{
      
      let storyboard = UIStoryboard(name: Custome_Storyboard, bundle: nil)
      let mPlayer = storyboard.instantiateViewController(withIdentifier: "MusicPlayerVC") as! MusicPlayerVC
      mPlayer.playPosition = indexPath.row
      mPlayer.playList = playList
      mPlayer.arrAudioList = arrAudio
      mPlayer.screenType = "sankirtan"
      self.navigationController?.popupBar.marqueeScrollEnabled = true
      self.navigationController?.presentPopupBar(withContentViewController: mPlayer, animated: true, completion: nil)
      
    }else if screenDirection == .Others{
 
      let storyboard = UIStoryboard(name: Custome_Storyboard, bundle: nil)
      let mPlayer = storyboard.instantiateViewController(withIdentifier: "MusicPlayerVC") as! MusicPlayerVC
      mPlayer.playPosition = indexPath.row
      mPlayer.playList = playList
      mPlayer.arrAudioList = arrAudio
      mPlayer.screenType = "others"
      self.navigationController?.popupBar.marqueeScrollEnabled = true
      self.navigationController?.presentPopupBar(withContentViewController: mPlayer, animated: true, completion: nil)
      
    }else if screenDirection == .WhatsNewAudio{
      
      let storyboard = UIStoryboard(name: Custome_Storyboard, bundle: nil)
      let mPlayer = storyboard.instantiateViewController(withIdentifier: "MusicPlayerVC") as! MusicPlayerVC
      mPlayer.playPosition = indexPath.row
      mPlayer.playList = playList
      mPlayer.arrAudioList = arrAudio
      mPlayer.screenType = "whatsnewaudio"
      self.navigationController?.popupBar.marqueeScrollEnabled = true
      self.navigationController?.presentPopupBar(withContentViewController: mPlayer, animated: true, completion: nil)
      
    }
    
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    if indexPath.row == arrAudio.count - 1{
      if is_Api_Being_Called == false{
        if currentPageNo <  totalPageNo{
          print("Page Load....")
          is_Api_Being_Called = true
          currentPageNo += 1
          self.getAudio(pageNo: currentPageNo)
        }
      }
    }
  }
  
  @IBAction func btnShare(_ sender: UIButton) {
    
    let data = arrAudio[sender.tag]
    var share_Content = String()
    
    if screenDirection == .WhatsNewAudio{
      
      share_Content = "Audio \n\nI am listening - \(data["title"].stringValue) \n\nvia MorariBapu - \(BASE_URL_IMAGE)\(data["audio_file"].stringValue) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"

    }else{
      
      share_Content = "Audio \n\nI am listening - \(data["name"].stringValue) \n\nvia MorariBapu - \(BASE_URL_IMAGE)\(data["audio_file"].stringValue) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"

    }
    
    let textToShare = [share_Content]
    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
    
    // exclude some activity types from the list (optional)
    activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
    
    DispatchQueue.main.async {
      self.present(activityViewController, animated: true, completion: nil)
    }
    
  }
  
  @IBAction func btnFavourite(_ sender: UIButton) {
    
    if arrAudio.count != 0{
      
      let data = arrAudio[sender.tag]
      
      var paramater = NSDictionary()
      
      if screenDirection == .Stuti{
        
        paramater = ["app_id":Utility.getDeviceID(),
                     "favourite_for":"5",
                     "favourite_id":data["id"].stringValue]
        
      }else if screenDirection == .Sankirtan{
        
        paramater = ["app_id":Utility.getDeviceID(),
                     "favourite_for":"8",
                     "favourite_id":data["id"].stringValue]
        
      }else if screenDirection == .Others{
       
        paramater = ["app_id":Utility.getDeviceID(),
                     "favourite_for":"2",
                     "favourite_id":data["id"].stringValue]
        
      }else if screenDirection == .WhatsNewAudio{
        
        paramater = ["app_id":Utility.getDeviceID(),
                     "favourite_for":"19",
                     "favourite_id":data["id"].stringValue]
        
      }

      WebServices().CallGlobalAPI(url: WebService_Favourite,headers: [:], parameters: paramater, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
        
        if(jsonResponce?.error != nil) {
          
          var errorMess = jsonResponce?.error?.localizedDescription
          errorMess = MESSAGE_Err_Service
          Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
        }
        else {
          
          if jsonResponce!["status"].stringValue == "true"{
            
            self.arrFavourite.removeAllObjects()
            self.arrAudio.removeAll()
            self.getAudio(pageNo: 1)
            
          }
          else {
            Utility().showAlertMessage(vc: self, titleStr: "", messageStr: jsonResponce!["message"].stringValue)
          }
        }
      }
      
    }
  }
}

//MARK:- Menu Navigation Delegate
extension AudioVC: MenuNavigationDelegate{
  
  func SelectedMenu(ScreenName: String?) {
    
    if ScreenName == "Home"{
      //Home
      self.navigationController?.popToRootViewController(animated: true)
      
    }else if ScreenName == "Katha Chopai"{
      //Katha Chopai
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiVC") as! KathaChopaiVC
      vc.screenDirection = .Katha_Chopai
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Ram Charitra Manas"{
      //Ram Charitra Manas
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiVC") as! KathaChopaiVC
      vc.screenDirection = .Ram_Charit_Manas
      navigationController?.pushViewController(vc, animated:  true)
      
     }else if ScreenName == "Upcoing Katha"{
      //Upcoing Katha
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "UpComingKathasVC") as! UpComingKathasVC
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Quotes"{
      //Quotes
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiVC") as! KathaChopaiVC
      vc.screenDirection = .Quotes
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Daily Katha Clip"{
      //Daily Katha Clip
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "WhatsNewVideoVC") as! WhatsNewVideoVC
      vc.screenDirection = .Daily_Katha_Clip
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Live Katha Audio"{
      //Live Katha Audio
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
      vc.screenDirection = .Live_Katha_Streaming_Audio
      vc.strTitle = "Live Katha Audio"
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "You Tube Channel"{
      //You Tube Channel
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
      vc.screenDirection = .Moraribapu_Youtube_Channel
      vc.strTitle = "Morari Bapu Youtube Channel"
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Live Katha Video"{
      //Live Katha Video
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
      vc.screenDirection = .Live_Katha_Streaming_Video
      vc.strTitle = "Live Katha Video"
      navigationController?.pushViewController(vc, animated:  true)
      
    }
    else if ScreenName == "Media"{
      //Media
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
      vc.screenDirection = .Media
      navigationController?.pushViewController(vc, animated:  true)
      
      
    }else if ScreenName == "What's New"{
      //What's New
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
      vc.screenDirection = .Whats_New
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Sangeet Ni Duniya"{
      //Sangeet Ni Duniya
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
      vc.screenDirection = .Sangeet_Ni_Duniya_Online_Shop
      vc.strTitle = "Sangeet Ni Duniya Online Shop"
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Setting"{
      //Setting
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
      vc.screenDirection = .Settings
      navigationController?.pushViewController(vc, animated:  true)
      
     }else if ScreenName == "Search"{
      //Search
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Favourites"{
      //Favourites
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "FavouriteVC") as! FavouriteVC
      navigationController?.pushViewController(vc, animated:  true)
    }else if ScreenName == "Events"{
      //Events
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "EventsVC") as! EventsVC
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Katha Ebook"{
      //Katha Ebook`   .
      
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaEBookVC") as! KathaEBookVC
      navigationController?.pushViewController(vc, animated:  true)
      
    }
  }
  
}

extension AudioVC : InternetConnectionDelegate{
  
  @objc private func reachabilityChanged( notification: NSNotification )
  {
    guard let reachability = notification.object as? Reachability else
    {
      return
    }
    
    if reachability.connection == .wifi || reachability.connection == .cellular {
      
    }else{
      
      if let wd = UIApplication.shared.delegate?.window {
        var vc = wd!.rootViewController
        if(vc is UINavigationController){
          vc = (vc as! UINavigationController).visibleViewController
        }
        
        if(vc is AudioVC){
          Utility.internet_connection_Show(onViewController: self)
        }
      }
      
    }
    
  }
  
  func reloadPage() {
    
      self.arrAudio.removeAll()
      self.getAudio(pageNo: 0)
    
  }
}
