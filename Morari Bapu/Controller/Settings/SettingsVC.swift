//
//  SettingsVC.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 07/10/18.
//  Copyright © 2018 Bhavin Chauhan. All rights reserved.
//

import UIKit
import Toast_Swift
import SwiftyJSON
import Alamofire
import IQKeyboardManagerSwift
import Kingfisher
import SwiftyUserDefaults

enum SettingScreenIdentify {
  case Settings
  case About_Us
  case Media
  case Audios
  case Other_Videos
  case Whats_New
}


class SettingsVC: UIViewController {
  
  @IBOutlet weak var tblSettings: UITableView!
  var screenDirection = SettingScreenIdentify.Settings
  @IBOutlet weak var lblTitle: UILabel!
  var arrMediaUnReadCounts  = [String:JSON]()
  var arrOtherVideo : [JSON] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    
    tblSettings.tableFooterView =  UIView.init(frame: .zero)
    tblSettings.layoutMargins = .zero
    
    tblSettings.rowHeight = 60
    tblSettings.estimatedRowHeight = UITableView.automaticDimension
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if screenDirection == .Settings{
      lblTitle.text = "Settings"
    }else if screenDirection == .About_Us{
      lblTitle.text = "About Us"
    }else if screenDirection == .Media{
      lblTitle.text = "Media"
      self.getUnreadCounter()
    }else if screenDirection == .Audios{
      lblTitle.text = "Audios"
    }
    else if screenDirection == .Other_Videos{
      lblTitle.text = "Other Videos"
      self.getOtherVideosCategories()
      
    }else{
      //What's New
      lblTitle.text = "What's New"
      self.getUnreadCounter()
    }
    
  }
  
  func getOtherVideosCategories(){
    
    let param = ["parent_id" : "0"]
    
    WebServices().CallGlobalAPI(url: WebService_Other_Videos_Categories,headers: [:], parameters: param as NSDictionary, HttpMethod: "POST", ProgressView: false) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
      
      if(jsonResponce?.error != nil) {
        
        var errorMess = jsonResponce?.error?.localizedDescription
        errorMess = MESSAGE_Err_Service
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
      }
      else {
        
        if jsonResponce!["status"].stringValue == "true"{
          self.arrOtherVideo = jsonResponce!["data"].arrayValue
          
          if self.arrOtherVideo.count != 0{
            
            DispatchQueue.main.async {
              self.tblSettings .reloadData()
              Utility.tableNoDataMessage(tableView: self.tblSettings, message: "", messageColor: UIColor.black, displayMessage: .Center)
            }
          }
          else
          {
            
            DispatchQueue.main.async {
              self.tblSettings .reloadData()
              Utility.tableNoDataMessage(tableView: self.tblSettings, message: "No Other VideoS", messageColor: UIColor.black, displayMessage: .Center)
              
            }
          }
          
        }
        else {
          Utility().showAlertMessage(vc: self, titleStr: "", messageStr: jsonResponce!["message"].stringValue)
        }
      }
    }
  }
  
  //MARK:- Api Call
  func getUnreadCounter(){
    
    let param = ["id" : "1",
                 "app_id":Utility.getDeviceID()] as NSDictionary
    
    var api_Url = String()
    
    if screenDirection == .Media{
      api_Url = WebService_Media_Counts
    }else if screenDirection == .Whats_New{
      api_Url = WebService_Whats_New_Counts
    }
    
    WebServices().CallGlobalAPI(url: api_Url,headers: [:], parameters: param, HttpMethod: "POST", ProgressView: false) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
      
      if(jsonResponce?.error != nil) {
        
        var errorMess = jsonResponce?.error?.localizedDescription
        errorMess = MESSAGE_Err_Service
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
      }
      else {
        
        if jsonResponce!["status"].stringValue == "true"{
          
          self.arrMediaUnReadCounts = jsonResponce!["data"].dictionaryValue
          
          if self.arrMediaUnReadCounts.count != 0{
            
            DispatchQueue.main.async {
              self.tblSettings .reloadData()
            }
          }
          else
          {
            
            DispatchQueue.main.async {
              self.tblSettings .reloadData()
              
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

//MARK TableView Delegate
extension SettingsVC : UITableViewDelegate, UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if screenDirection == .Settings{
      return 5
    }else  if screenDirection == .About_Us{
      return 1
    }else if screenDirection == .Media{
      return 6
    }else if screenDirection == .Audios{
      return 3
    }
    else if screenDirection == .Other_Videos{
      return arrOtherVideo.count
    }else{
      //What's New
      return 4
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
    let cellIdentifier = "SettingsTableViewCell"
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SettingsTableViewCell  else {
      fatalError("The dequeued cell is not an instance of MealTableViewCell.")
    }
    
    cell.lblUnReadCount.isHidden = true
    
    cell.lblUnReadCount.layer.masksToBounds = true
    cell.lblUnReadCount.layer.borderColor = UIColor.white.cgColor
    cell.lblUnReadCount.layer.cornerRadius = cell.lblUnReadCount.frame.height / 2
    
    if screenDirection == .Settings{
      if indexPath.row == 0{
        cell.lblTitle.text = "About Us"
        
      }else if indexPath.row == 1{
        cell.lblTitle.text = "About The App"
        
      }else if indexPath.row == 2{
        cell.lblTitle.text = "Feedback"
        
      }else if indexPath.row == 3{
        cell.lblTitle.text = "Share The App"
        
      }
      else if indexPath.row == 4{
        cell.lblTitle.text = "FAQ"
        
      }
      
    }else if screenDirection == .About_Us{
      if indexPath.row == 0{
        cell.lblTitle.text = "About Bapu"
      }
    }else if screenDirection == .Media{
      if indexPath.row == 0{
        cell.lblTitle.text = "Photos"
        
        cell.lblUnReadCount.isHidden = false
        
        if arrMediaUnReadCounts["BapuPhoto"]?.stringValue == ""{
          cell.lblUnReadCount.isHidden = true
        }
        else if arrMediaUnReadCounts["BapuPhoto"]?.intValue ?? 0 < 99{
          cell.lblUnReadCount.text = arrMediaUnReadCounts["BapuPhoto"]?.stringValue
        }else{
          cell.lblUnReadCount.text = " 99+ "
        }
        
      }else if indexPath.row == 1{
        cell.lblTitle.text = "Sher O Shayari"
        
        cell.lblUnReadCount.isHidden = false
        
        if arrMediaUnReadCounts["BapuShayari"]?.stringValue == ""{
          cell.lblUnReadCount.isHidden = true
        }
        else if arrMediaUnReadCounts["BapuShayari"]?.intValue ?? 0 < 99{
          cell.lblUnReadCount.text = arrMediaUnReadCounts["BapuShayari"]?.stringValue
        }else{
          cell.lblUnReadCount.text = " 99+ "
        }
        
        
      }else if indexPath.row == 2{
        cell.lblTitle.text = "Bapu's Thought"
        
        cell.lblUnReadCount.isHidden = false
        
        if arrMediaUnReadCounts["BapuThought"]?.stringValue == ""{
          cell.lblUnReadCount.isHidden = true
        }
        else if arrMediaUnReadCounts["BapuThought"]?.intValue ?? 0 < 99{
          cell.lblUnReadCount.text = arrMediaUnReadCounts["BapuThought"]?.stringValue
        }else{
          cell.lblUnReadCount.text = " 99+ "
        }
        
        
      }else if indexPath.row == 3{
        cell.lblTitle.text = "Other Videos"
        
        cell.lblUnReadCount.isHidden = false
        
        if arrMediaUnReadCounts["OtherVideo"]?.stringValue == ""{
          cell.lblUnReadCount.isHidden = true
        }
        else if arrMediaUnReadCounts["OtherVideo"]?.intValue ?? 0 < 99{
          cell.lblUnReadCount.text = arrMediaUnReadCounts["OtherVideo"]?.stringValue
        }else{
          cell.lblUnReadCount.text = " 99+ "
        }
        
        
      }else if indexPath.row == 4{
        cell.lblTitle.text = "Audios"
        
        cell.lblUnReadCount.isHidden = false
        
        if arrMediaUnReadCounts["Audio"]?.stringValue == ""{
          cell.lblUnReadCount.isHidden = true
        }
        else if arrMediaUnReadCounts["Audio"]?.intValue ?? 0 < 99{
          cell.lblUnReadCount.text = arrMediaUnReadCounts["Audio"]?.stringValue
        }else{
          cell.lblUnReadCount.text = " 99+ "
        }
        
      }else if indexPath.row == 5{
        cell.lblTitle.text = "Press Articles"
        
        cell.lblUnReadCount.isHidden = false
        
        if arrMediaUnReadCounts["Article"]?.stringValue == ""{
          cell.lblUnReadCount.isHidden = true
        }
        else if arrMediaUnReadCounts["Article"]?.intValue ?? 0 < 99{
          cell.lblUnReadCount.text = arrMediaUnReadCounts["Article"]?.stringValue
        }else{
          cell.lblUnReadCount.text = " 99+ "
        }
        
        
      }
      
    }else if screenDirection == .Audios{
      if indexPath.row == 0{
        cell.lblTitle.text = "Stuti"
        
      }else if indexPath.row == 1{
        cell.lblTitle.text = "Sankirtan"
        
      }
      else {
        cell.lblTitle.text = "Others"
      }
    }
    else if screenDirection == .Other_Videos{
      
      var dict = arrOtherVideo[indexPath.row]
      
      cell.lblTitle.text = dict["name"].stringValue
      
    }else{
      //What's New
      if indexPath.row == 0{
        cell.lblTitle.text = "Text"
        
        cell.lblUnReadCount.isHidden = false
        
        if arrMediaUnReadCounts["NewText"]?.stringValue == ""{
          cell.lblUnReadCount.isHidden = true
        }
        else if arrMediaUnReadCounts["NewText"]?.intValue ?? 0 < 99{
          cell.lblUnReadCount.text = arrMediaUnReadCounts["NewText"]?.stringValue
        }else{
          cell.lblUnReadCount.text = " 99+ "
        }
        
      }else if indexPath.row == 1{
        cell.lblTitle.text = "Photo"
        
        cell.lblUnReadCount.isHidden = false
        
        if arrMediaUnReadCounts["NewImage"]?.stringValue == ""{
          cell.lblUnReadCount.isHidden = true
        }
        else if arrMediaUnReadCounts["NewImage"]?.intValue ?? 0 < 99{
          cell.lblUnReadCount.text = arrMediaUnReadCounts["NewImage"]?.stringValue
        }else{
          cell.lblUnReadCount.text = " 99+ "
        }
        
      }
      else if indexPath.row == 2{
        cell.lblTitle.text = "Video"
        
        cell.lblUnReadCount.isHidden = false
        
        if arrMediaUnReadCounts["NewVideo"]?.stringValue == ""{
          cell.lblUnReadCount.isHidden = true
        }
        else if arrMediaUnReadCounts["NewVideo"]?.intValue ?? 0 < 99{
          cell.lblUnReadCount.text = arrMediaUnReadCounts["NewVideo"]?.stringValue
        }else{
          cell.lblUnReadCount.text = " 99+ "
        }
        
      }
      else {
        cell.lblTitle.text = "Audio"
        
        cell.lblUnReadCount.isHidden = false
        
        if arrMediaUnReadCounts["NewAudio"]?.stringValue == ""{
          cell.lblUnReadCount.isHidden = true
        }
        else if arrMediaUnReadCounts["NewAudio"]?.intValue ?? 0 < 99{
          cell.lblUnReadCount.text = arrMediaUnReadCounts["NewAudio"]?.stringValue
        }else{
          cell.lblUnReadCount.text = " 99+ "
        }
        
      }
    }
    
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if screenDirection == .Settings{
      if indexPath.row == 0{
        //About Us
        
        let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        vc.screenDirection = .About_Us
        navigationController?.pushViewController(vc, animated:  true)
        
      }else if indexPath.row == 1{
        //About The App
        
        let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AboutTheAppVC") as! AboutTheAppVC
        vc.strTitle = "About The App"
        navigationController?.pushViewController(vc, animated:  true)
        
      }else if indexPath.row == 2{
        //Feedback
        
        let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FeedbackVC") as! FeedbackVC
        navigationController?.pushViewController(vc, animated:  true)
        
      }else if indexPath.row == 3{
        
        DispatchQueue.main.async {
          // text to share
          let text = "This message has been sent via the Morari Bapu App.\nYou can download it too from this link: https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
          
          // set up activity view controller
          let textToShare = [ text ]
          let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
          activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
          
          // exclude some activity types from the list (optional)
          activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
          
          self.present(activityViewController, animated: true, completion: nil)
          
        }
        
      }
      else if indexPath.row == 4{
        let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FaqVC") as! FaqVC
        navigationController?.pushViewController(vc, animated:  true)
      }
      
    }else if screenDirection == .About_Us{
      //About Us
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "AboutTheAppVC") as! AboutTheAppVC
      vc.strTitle = "About Bapu"
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if screenDirection == .Media{
      
      if indexPath.row == 0{
        
        //Photos
        
        let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WhatsNewPhotosVC") as! WhatsNewPhotosVC
        vc.screenDirection = .Media_Photos
        navigationController?.pushViewController(vc, animated:  true)
        
      }else if indexPath.row == 1{
        
        //Sher O Shayri
        
        let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShayriVC") as! ShayriVC
        navigationController?.pushViewController(vc, animated:  true)
        
        
      }else if indexPath.row == 2{
        
        //Bapu's Thoughts
        let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BapuThoughtsVC") as! BapuThoughtsVC
        navigationController?.pushViewController(vc, animated:  true)
        
      }else if indexPath.row == 3{
        
        //Other Videos
        
        let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        vc.screenDirection = .Other_Videos
        navigationController?.pushViewController(vc, animated:  true)
        
      }else if indexPath.row == 4{
        
        //Audios
        let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        vc.screenDirection = .Audios
        navigationController?.pushViewController(vc, animated:  true)
        
      }else if indexPath.row == 5{
        
        //Press Article
        let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ArticlesVC") as! ArticlesVC
        navigationController?.pushViewController(vc, animated:  true)
        
      }
      
    }else if screenDirection == .Audios{
      
      if indexPath.row == 0{
        
        //Stuti
        let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AudioVC") as! AudioVC
        vc.screenDirection = .Stuti
        navigationController?.pushViewController(vc, animated:  true)
        
      }else if indexPath.row == 1{
        
        //Sankirtan
        let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AudioVC") as! AudioVC
        vc.screenDirection = .Sankirtan
        navigationController?.pushViewController(vc, animated:  true)
        
      }
      else {
        
        //Other Audio
        let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AudioVC") as! AudioVC
        vc.screenDirection = .Others
        navigationController?.pushViewController(vc, animated:  true)
        
      }
      
    }
    else if screenDirection == .Other_Videos{
      
      var dict = arrOtherVideo[indexPath.row]
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "WhatsNewVideoVC") as! WhatsNewVideoVC
      vc.idVideoCategory = dict["id"].stringValue
      vc.screenDirection = .Other_Videos
      
      navigationController?.pushViewController(vc, animated:  true)
      
    }else{
      //What's New
      
      if indexPath.row == 0{
        //Text
        
        let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WhatsNewTextVC") as! WhatsNewTextVC
        navigationController?.pushViewController(vc, animated:  true)
        
      }else if indexPath.row == 1{
        //Photo
        
        let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WhatsNewPhotosVC") as! WhatsNewPhotosVC
        vc.screenDirection = .Whats_New_Photos
        navigationController?.pushViewController(vc, animated:  true)
      }
      else if indexPath.row == 2{
        //Video
        
        let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WhatsNewVideoVC") as! WhatsNewVideoVC
        vc.screenDirection = .WhatsNew_Video
        navigationController?.pushViewController(vc, animated:  true)
        
      }
      else {
        //Audio
        
        let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AudioVC") as! AudioVC
        vc.screenDirection = .WhatsNewAudio
        navigationController?.pushViewController(vc, animated:  true)
        
      }
      
    }
    
  }
}


//MARK:- Menu Navigation Delegate
extension SettingsVC: MenuNavigationDelegate{
  
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
      //Katha Ebook
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaEBookVC") as! KathaEBookVC
      navigationController?.pushViewController(vc, animated:  true)
      
    }
  }
}

