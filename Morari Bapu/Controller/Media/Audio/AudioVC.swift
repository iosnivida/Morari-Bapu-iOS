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
  var arrFavourite = NSArray()

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
      self.getAudio()
    }
    
  }
  
  
  //MARK:- Api Call
  func getAudio(){
    
    
    var api_Url = String()
    var param = NSDictionary()
    if screenDirection == .Stuti{
      api_Url = WebService_Stuti_List
      
      param = ["page" : "1",
               "app_id":Utility.getDeviceID(),
               "stuti_type_id":"1",
               "favourite_for":"5"] as NSDictionary
      
      
    }else if screenDirection == .Sankirtan{
      api_Url = WebService_Sankirtan_Audio
      
      param = ["page" : "1",
               "app_id":Utility.getDeviceID(),
               "favourite_for":"8"] as NSDictionary
      
      
    }else if screenDirection == .Others{
      api_Url = WebService_Stuti_List
      
      param = ["page" : "1",
               "app_id":Utility.getDeviceID(),
               "stuti_type_id":"2",
               "favourite_for":"10"] as NSDictionary
      
    }else if screenDirection == .WhatsNewAudio{
      
      api_Url = WebService_Whats_New_Audio
      
      param = ["page" : "1",
               "app_id":Utility.getDeviceID(),
               "audio_id":"1"] as NSDictionary
    }
    
    WebServices().CallGlobalAPI(url: api_Url,headers: [:], parameters: param, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
      
      if(jsonResponce?.error != nil) {
        
        var errorMess = jsonResponce?.error?.localizedDescription
        errorMess = MESSAGE_Err_Service
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
      }
      else {
        
        if jsonResponce!["status"].stringValue == "true"{
          self.arrAudio = jsonResponce!["data"].arrayValue
          
          if jsonResponce!["MyFavourite"].count != 0{
              self.arrFavourite = jsonResponce!["MyFavourite"].arrayObject! as NSArray
          }
          

          if self.arrAudio.count != 0{
            
            DispatchQueue.main.async {
              self.tblAudio .reloadData()
              Utility.tableNoDataMessage(tableView: self.tblAudio, message: "", messageColor: UIColor.black, displayMessage: .Center)
            }
          }
          else
          {
            
            DispatchQueue.main.async {
              self.tblAudio .reloadData()
              Utility.tableNoDataMessage(tableView: self.tblAudio, message: "No Audio", messageColor: UIColor.black, displayMessage: .Center)
              
            }
          }
          
        }
        else {
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
    Utility.hanuman_chalisha_Show(onViewController: self)
  }
  
  @IBAction func btnBack(_ sender: Any) {
    self.navigationController?.popViewController(animated:true)
  }
  
  @IBAction func backToHome(_ sender: Any) {
    self.navigationController?.popToRootViewController(animated: true)
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
    
    
    cell.viewMusicIndicator.isHidden = true
    
    
    return cell
    
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let data = arrAudio[indexPath.row]
    
    if screenDirection == .Stuti{
      
      if data["is_read"].intValue == 0{
        
        let param = ["app_id":Utility.getDeviceID(),
                     "stuti_id":data["id"].stringValue] as NSDictionary
        
        Utility.readUnread(api_Url: WebService_Struti_Media_Read_Unread, parameters: param)
        
      }
      
    }else if screenDirection == .Sankirtan{
      
      if data["is_read"].intValue == 0{
        
        let param = ["app_id":Utility.getDeviceID(),
                     "sankirtan_id":data["id"].stringValue] as NSDictionary
        
        Utility.readUnread(api_Url: WebService_Sankirtan_Read_Unread, parameters: param)
        
      }
      
    }else if screenDirection == .Others{
      
    }else if screenDirection == .WhatsNewAudio{
    
      if data["is_read"].intValue == 0{
        
        let param = ["app_id":Utility.getDeviceID(),
                     "audio_id":data["id"].stringValue] as NSDictionary
        
        Utility.readUnread(api_Url: WebService_Audio_Whats_New_Read_Unread, parameters: param)
        
      }
      
    }
    
    
   // Utility.music_Player_Show(onViewController: self, position: indexPath.row, listOfAudio: arrAudio)

    
  }
  
  @IBAction func btnShare(_ sender: UIButton) {
    
    let data = arrAudio[sender.tag]
    var share_Content = String()
    
    if screenDirection == .WhatsNewAudio{
      
      share_Content = "I am listening - \n\(data["title"].stringValue) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"

    }else{
      
      share_Content = "I am listening - \n\(data["name"].stringValue) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"

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
  
  }
    
    WebServices().CallGlobalAPI(url: WebService_Favourite,headers: [:], parameters: paramater, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
      
      if(jsonResponce?.error != nil) {
        
        var errorMess = jsonResponce?.error?.localizedDescription
        errorMess = MESSAGE_Err_Service
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
      }
      else {
        
        if jsonResponce!["status"].stringValue == "true"{
         
          self.getAudio()
         
        }
        else {
          Utility().showAlertMessage(vc: self, titleStr: "", messageStr: jsonResponce!["message"].stringValue)
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
      //Katha Ebook
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaEBookVC") as! KathaEBookVC
      navigationController?.pushViewController(vc, animated:  true)
      
    }
  }
}



