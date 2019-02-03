//
//  KathaChopaiVC.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 02/10/18.
//  Copyright © 2018 Bhavin Chauhan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import MediaPlayer
import AVKit
import AVFoundation

class ArticlesVC: UIViewController {
  
  @IBOutlet weak var tblArticles: UITableView!
  @IBOutlet weak var lblTitle: UILabel!
  
  var arrArticles : [JSON] = []
  
  var currentPageNo = Int()
  var totalPageNo = Int()
  var is_Api_Being_Called : Bool = false

  override func viewDidLoad() {
    super.viewDidLoad()
    
    currentPageNo = 1

    tblArticles.tableFooterView =  UIView.init(frame: .zero)
    tblArticles.layoutMargins = .zero
    
    tblArticles.rowHeight = 150
    tblArticles.estimatedRowHeight = UITableView.automaticDimension
    
    lblTitle.text = "Articles"
    
    self.arrArticles.removeAll()
    self.getArticlesList(page:currentPageNo)
    
  }
  
  //MARK:- Api Call
  func getArticlesList(page:Int){
    
    let param = ["page" : page,
                 "favourite_for":"7",
                 "app_id":Utility.getDeviceID()] as NSDictionary
    
    WebServices().CallGlobalAPI(url: WebService_Media_Articles,headers: [:], parameters: param, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
      
      if(jsonResponce?.error != nil) {
        
        var errorMess = jsonResponce?.error?.localizedDescription
        errorMess = MESSAGE_Err_Service
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
      }
      else {
        
        if jsonResponce!["status"].stringValue == "true"{
          
          for result in jsonResponce!["data"].arrayValue {
            self.arrArticles.append(result)
          }
          
          self.totalPageNo = jsonResponce!["total_page"].intValue
          self.is_Api_Being_Called = false

          if self.arrArticles.count != 0{
            DispatchQueue.main.async {
              
              Utility.tableNoDataMessage(tableView: self.tblArticles, message: "",messageColor:UIColor.white, displayMessage: .Center)
              
              self.tblArticles .reloadData()
            }
          }
          else
          {
            
            DispatchQueue.main.async {
              self.tblArticles.reloadData()
              Utility.tableNoDataMessage(tableView: self.tblArticles, message: "No Articles",messageColor:UIColor.white, displayMessage: .Center)
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
extension ArticlesVC : UITableViewDelegate, UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrArticles.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let data = arrArticles[indexPath.row]
    
    if data["image"].stringValue == "" && data["video"].stringValue == ""{
      
      let cellIdentifier = "Articles1TableViewCell"
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? Articles1TableViewCell  else {
        fatalError("The dequeued cell is not an instance of MealTableViewCell.")
      }
      
      if data["is_favourite"].boolValue == true{
        cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
      }else{
        cell.btnFavourite.setImage(UIImage(named: "unfavorite"), for: .normal)
      }
      
      cell.lblTitle.text = data["article"].stringValue
      cell.lblLink.text = data["link"].stringValue
      cell.lblLink.useUnderlineLabel(line_Color: UIColor.black)
      cell.lblDate.text = Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd-MMM-yyyy")
      
      cell.btnShare.tag = indexPath.row
      cell.btnYoutube.tag = indexPath.row
      cell.btnFavourite.tag = indexPath.row
      
      cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
      cell.btnYoutube.addTarget(self, action: #selector(btnLinkWebSite), for: UIControl.Event.touchUpInside)
      cell.btnFavourite.addTarget(self, action: #selector(btnFavourite), for: UIControl.Event.touchUpInside)
      return cell
      
   

    }else {
      

      let cellIdentifier = "Articles2TableViewCell"
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? Articles2TableViewCell  else {
        fatalError("The dequeued cell is not an instance of MealTableViewCell.")
      }
      
      cell.lblTitle.text = data["article"].stringValue
      cell.lblLink.text = data["link"].stringValue
      cell.lblLink.useUnderlineLabel(line_Color: UIColor.black)
      cell.lblDate.text = Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd-MMM-yyyy")
      
      let placeHolder = UIImage(named: "youtube_placeholder")
      
      cell.imgVideo.kf.indicatorType = .activity
      cell.imgVideo.kf.setImage(with: URL(string: "\(BASE_URL_IMAGE)\(data["image"].stringValue)"), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
      
      if data["is_favourite"].boolValue == true{
        cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
      }else{
        cell.btnFavourite.setImage(UIImage(named: "unfavorite"), for: .normal)
      }
      
      cell.btnShare.tag = indexPath.row
      cell.btnYoutube.tag = indexPath.row
      cell.btnLink.tag = indexPath.row
      cell.btnFavourite.tag = indexPath.row
      
      cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
      cell.btnYoutube.addTarget(self, action: #selector(btnYoutube), for: UIControl.Event.touchUpInside)
      cell.btnLink.addTarget(self, action: #selector(btnLinkWebSite), for: UIControl.Event.touchUpInside)
      cell.btnFavourite.addTarget(self, action: #selector(btnFavourite), for: UIControl.Event.touchUpInside)
      
      return cell
     
    }
//      let cellIdentifier = "Articles2TableViewCell"
//
//      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? Articles2TableViewCell  else {
//        fatalError("The dequeued cell is not an instance of MealTableViewCell.")
//      }
//
//      cell.lblTitle.text = data["article"].stringValue
//      cell.lblLink.text = data["link"].stringValue
//      cell.lblDate.text = Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd-MMM-yyyy")
//
//      let placeHolder = UIImage(named: "youtube_placeholder")
//
//      cell.imgVideo.kf.indicatorType = .activity
//      cell.imgVideo.kf.setImage(with: URL(string: "\(BASE_URL_IMAGE)\(data["video_image"].stringValue)"), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
//
//      if data["is_favourite"].boolValue == true{
//        cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
//      }else{
//        cell.btnFavourite.setImage(UIImage(named: "unfavorite"), for: .normal)
//      }
//
//      cell.btnShare.tag = indexPath.row
//      cell.btnYoutube.tag = indexPath.row
//      cell.btnFavourite.tag = indexPath.row
//
//      cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
//      cell.btnYoutube.addTarget(self, action: #selector(btnYoutube), for: UIControl.Event.touchUpInside)
//      cell.btnFavourite.addTarget(self, action: #selector(btnFavourite), for: UIControl.Event.touchUpInside)
//
//      return cell
//
//    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let data = arrArticles[indexPath.row]
    
    if data["is_read"].intValue == 0{
      
      let param = ["app_id":Utility.getDeviceID(),
                   "article_id":data["id"].stringValue] as NSDictionary
      
      Utility.readUnread(api_Url: WebService_Article_Read_Unread, parameters: param)
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    if indexPath.row == arrArticles.count - 1{
      if is_Api_Being_Called == false{
        if currentPageNo <  totalPageNo{
          print("Page Load....")
          is_Api_Being_Called = true
          currentPageNo += 1
          self.getArticlesList(page: 1)
        }
      }
    }
  }
  
  
  @IBAction func btnShare(_ sender: UIButton) {
    
    let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblArticles)
    let indexPath = self.tblArticles.indexPathForRow(at: buttonPosition)
    
    let data = arrArticles[indexPath!.row]

    let share_Content = "\(data["article"].stringValue) \n\nThis message has been sent via the Morari Bapu App. You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
  
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
    
    let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblArticles)
    let indexPath = self.tblArticles.indexPathForRow(at: buttonPosition)

    let data = arrArticles[indexPath!.row]

    let videoURL = URL(string: "\(BASE_URL_IMAGE)\(data["video"].stringValue)")
    let player = AVPlayer(url: videoURL!)
    let playerViewController = AVPlayerViewController()
    playerViewController.player = player
    self.present(playerViewController, animated: true) {
      playerViewController.player!.play()
    }
    
   
  }
  
  @IBAction func btnLinkWebSite(_ sender: UIButton) {
    
    let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblArticles)
    let indexPath = self.tblArticles.indexPathForRow(at: buttonPosition)
    
    let data = arrArticles[indexPath!.row]
    
    
    if data["is_read"].intValue == 0{
      
      let param = ["app_id":Utility.getDeviceID(),
                   "article_id":data["id"].stringValue] as NSDictionary
      
      Utility.readUnread(api_Url: WebService_Article_Read_Unread, parameters: param)
    }
    
    let youtubeLink = data["link"].url
    
    if Utility.canOpenURL(data["link"].stringValue){
      DispatchQueue.main.async {
        UIApplication.shared.open(youtubeLink!, options: [:])
      }
    }else{
    }
  }
  
  @IBAction func btnFavourite(_ sender: UIButton) {
    
    let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblArticles)
    let indexPath = self.tblArticles.indexPathForRow(at: buttonPosition)
    
    if arrArticles.count != 0{
      
      let data = arrArticles[indexPath!.row]
      
      let paramater = ["app_id":Utility.getDeviceID(),
                       "favourite_for":"7",
                       "favourite_id":data["id"].stringValue]
      
      WebServices().CallGlobalAPI(url: WebService_Favourite,headers: [:], parameters: paramater as NSDictionary, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
        
        if(jsonResponce?.error != nil) {
          
          var errorMess = jsonResponce?.error?.localizedDescription
          errorMess = MESSAGE_Err_Service
          Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
        }
        else {
          
          if jsonResponce!["status"].stringValue == "true"{
            self.arrArticles.removeAll()
            self.getArticlesList(page: 1)
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
extension ArticlesVC : MenuNavigationDelegate{
  
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
