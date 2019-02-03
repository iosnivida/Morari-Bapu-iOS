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

enum WhatsNewVideoScreenIdentify {
  case WhatsNew_Video
  case Other_Videos
  case Daily_Katha_Clip
}

class WhatsNewVideoVC: UIViewController {
  
  @IBOutlet weak var tblVideo: UITableView!
  var arrVideo = [JSON]()
  @IBOutlet weak var lblTitle: UILabel!
  var screenDirection = WhatsNewVideoScreenIdentify.WhatsNew_Video
  var idVideoCategory = String()
  
  var currentPageNo = Int()
  var totalPageNo = Int()
  var is_Api_Being_Called : Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    currentPageNo = 1

    tblVideo.tableFooterView =  UIView.init(frame: .zero)
    tblVideo.layoutMargins = .zero
    
    tblVideo.rowHeight = 110
    tblVideo.estimatedRowHeight = UITableView.automaticDimension
    
    DispatchQueue.main.async {
      self.arrVideo.removeAll()
      self.getWhatsNewVideo(pageNo: 1)
    }
    
    if screenDirection == .WhatsNew_Video{
      lblTitle.text = "Video"
    }else if screenDirection == .Other_Videos{
      lblTitle.text = "Other Video"
      
    }else if screenDirection == .Daily_Katha_Clip{
      lblTitle.text = "Daily Katha Clip"
    }
    
  }
  
  
  //MARK:- Api Call
  func getWhatsNewVideo(pageNo:Int){
    
    var api_url = String()
    var param = NSDictionary()
    
    if screenDirection == .WhatsNew_Video{
      
      param = ["page" : pageNo,
               "favourite_for":"2",
               "app_id":Utility.getDeviceID()] as NSDictionary
      
      api_url = WebService_Whats_New_Video
    }else if screenDirection == .Other_Videos{
      
      param = ["page" : pageNo,
               "app_id":Utility.getDeviceID(),
               "favourite_for":"4",
                "video_cat_id" : idVideoCategory] as NSDictionary
      
      api_url = WebService_Other_Video_Media
      
    }else if screenDirection == .Daily_Katha_Clip{
      
      param = ["page" : pageNo,
               "favourite_for":"4",
               "app_id":Utility.getDeviceID()] as NSDictionary
      
      api_url = WebService_Daily_Katha_Clip
    }
    
    WebServices().CallGlobalAPI(url: api_url,headers: [:], parameters: param, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
      
      if(jsonResponce?.error != nil) {
        
        var errorMess = jsonResponce?.error?.localizedDescription
        errorMess = MESSAGE_Err_Service
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
      }
      else {
        
        if jsonResponce!["status"].stringValue == "true"{
       
          for result in jsonResponce!["data"].arrayValue {
            self.arrVideo.append(result)
          }
          
          self.totalPageNo = jsonResponce!["total_page"].intValue
          
          self.is_Api_Being_Called = false

          if self.arrVideo.count != 0{
            
              self.tblVideo .reloadData()
              Utility.tableNoDataMessage(tableView: self.tblVideo, message: "", messageColor: UIColor.black, displayMessage: .Center)
            }
          else
          {
            
              self.tblVideo .reloadData()
              Utility.tableNoDataMessage(tableView: self.tblVideo, message: "No video", messageColor: UIColor.black, displayMessage: .Center)
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
    Utility.hanuman_chalisha_Show(onViewController: self)
  }
  
  @IBAction func btnBack(_ sender: Any) {
    self.navigationController?.popViewController(animated:true)
  }
  
  @IBAction func backToHome(_ sender: Any) {
    self.navigationController?.popToRootViewController(animated: true)
  }
  
}



//MARK:- Menu Navigation Delegate
extension WhatsNewVideoVC: MenuNavigationDelegate{
  
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

extension WhatsNewVideoVC : UITableViewDelegate, UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return arrVideo.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cellIdentifier = "YoutubeTableViewCell"
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? YoutubeTableViewCell  else {
      fatalError("The dequeued cell is not an instance of MealTableViewCell.")
    }
    
    let data = arrVideo[indexPath.row]
    
    cell.lblTitle.text = data["title"].stringValue
    cell.lblDuration.text = "(Duration: \(data["video_duration"].stringValue))"
    cell.lblDate.text = Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd-MM-yyyy")
    
    let placeHolder = UIImage(named: "youtube_placeholder")
    
    
    
    cell.imgVideo.kf.indicatorType = .activity
    
    let url = URL(string: "https://img.youtube.com/vi/\(Utility.extractYouTubeId(from: data["youtube_link"].stringValue) ?? "")/0.jpg")
    
    cell.imgVideo.kf.setImage(with: url, placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
    
    if data["is_favourite"].boolValue == true{
      cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
    }else{
      cell.btnFavourite.setImage(UIImage(named: "unfavorite"), for: .normal)
    }
    
    if screenDirection == .WhatsNew_Video{
      cell.btnFavourite.isHidden = true
      cell.constraintRightShare.constant = -39
    }else{
      cell.btnFavourite.isHidden = false
    }
    
    cell.btnShare.tag = indexPath.row
    cell.btnYoutube.tag = indexPath.row
    cell.btnFavourite.tag = indexPath.row
    
    cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
    cell.btnYoutube.addTarget(self, action: #selector(btnYoutube), for: UIControl.Event.touchUpInside)
    cell.btnFavourite.addTarget(self, action: #selector(btnFavourite), for: UIControl.Event.touchUpInside)
    
    return cell

  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    if indexPath.row == arrVideo.count - 1{
      if is_Api_Being_Called == false{
        if currentPageNo <  totalPageNo{
          print("Page Load....")
          is_Api_Being_Called = true
          currentPageNo += 1
          self.getWhatsNewVideo(pageNo: currentPageNo)
        }
      }
    }
  }
  
  
  @IBAction func btnShare(_ sender: UIButton) {
    
    let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblVideo)
    let indexPath = self.tblVideo.indexPathForRow(at: buttonPosition)
    
    var share_Content = String()

    let data = arrVideo[indexPath!.row]

    if screenDirection == .WhatsNew_Video{
      
      share_Content = "\(data["title"].stringValue) \n\n\(data["youtube_link"].stringValue) \n(Duration: \(data["video_duration"].stringValue)) \n\nDate: \(Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd-MM-yyyy")) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
      
    }else if screenDirection == .Other_Videos{
      
      share_Content = "\(data["title"].stringValue) \n\n\(data["youtube_link"].stringValue) \n(Duration: \(data["video_duration"].stringValue)) \n\nDate: \(Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd-MM-yyyy")) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
      
    }else if screenDirection == .Daily_Katha_Clip{
      
      share_Content = "\(data["title"].stringValue) \n\n\(data["youtube_link"].stringValue) \n(Duration: \(data["video_duration"].stringValue)) \nDate: \(Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd-MM-yyyy")) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
    }
    
    // set up activity view controller
    let textToShare = [share_Content]
    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
    
    // exclude some activity types from the list (optional)
    activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
    
    // present the view controller
    
    DispatchQueue.main.async {
      self.present(activityViewController, animated: true, completion: nil)
    }
  }
  
  @IBAction func btnYoutube(_ sender: UIButton) {
    
    let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblVideo)
    let indexPath = self.tblVideo.indexPathForRow(at: buttonPosition)
    
    let data = arrVideo[indexPath!.row]

    let link = arrVideo[indexPath!.row]
    let youtubeLink = link["youtube_link"].url
    
    if data["is_read"].intValue == 0{
      
      if screenDirection == .WhatsNew_Video{
        
        let param = ["app_id":Utility.getDeviceID(),
                     "video_id":data["id"].stringValue] as NSDictionary
        
        Utility.readUnread(api_Url: WebService_Video_Whats_New_Read_Unread, parameters: param)
      }else if screenDirection == .Other_Videos{
        
        let param = ["app_id":Utility.getDeviceID(),
                     "kathavideo_other_id":data["id"].stringValue] as NSDictionary
        
        Utility.readUnread(api_Url: WebService_Katha_Other_Video_Read_Unread, parameters: param)
        
      }else if screenDirection == .Daily_Katha_Clip{
   
        let param = ["app_id":Utility.getDeviceID(),
                     "kathavideo_id":data["id"].stringValue] as NSDictionary
        
        Utility.readUnread(api_Url: WebService_Daily_Katha_Video_Read_Unread, parameters: param)
      }
      
    }
    
    if Utility.canOpenURL(link["youtube_link"].stringValue){
      DispatchQueue.main.async {
        UIApplication.shared.open(youtubeLink!, options: [:])
      }
    }else{
      
    }
    
    
  }
  
  @IBAction func btnFavourite(_ sender: UIButton) {
    
    
    let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblVideo)
    let indexPath = self.tblVideo.indexPathForRow(at: buttonPosition)
    
    
    if arrVideo.count != 0{
      
      let data = arrVideo[indexPath!.row]
      var favourite_for = String()
      var favourite_id = String()
      
      if screenDirection == .WhatsNew_Video{
        
      }else if screenDirection == .Other_Videos{
        favourite_for = "4"
        favourite_id = data["id"].stringValue
      }else if screenDirection == .Daily_Katha_Clip{
        favourite_for = "4"
        favourite_id = data["id"].stringValue
      }
      
      let paramater = ["app_id":Utility.getDeviceID(),
                       "favourite_for":favourite_for,
                       "favourite_id":favourite_id]
      
      WebServices().CallGlobalAPI(url: WebService_Favourite,headers: [:], parameters: paramater as NSDictionary, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
        
        if(jsonResponce?.error != nil) {
          
          var errorMess = jsonResponce?.error?.localizedDescription
          errorMess = MESSAGE_Err_Service
          Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
        }
        else {
          
          if jsonResponce!["status"].stringValue == "true"{
            self.arrVideo.removeAll()
            self.getWhatsNewVideo(pageNo: 1)
          }
          else {
            Utility().showAlertMessage(vc: self, titleStr: "", messageStr: jsonResponce!["message"].stringValue)
          }
        }
      }
      
    }
  }
  
  
}
