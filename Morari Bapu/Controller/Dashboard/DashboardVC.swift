//
//  ViewController.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 01/10/18.
//  Copyright © 2018 Bhavin Chauhan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import iCarousel

import MediaPlayer
import AVKit
import AVFoundation
import LNPopupController
import AudioPlayerManager

class DashboardVC: UIViewController, UIScrollViewDelegate {


    var arrSlider  = [JSON]()
    var arrHome  = [JSON]()
    var currentPageNo = Int()
    var totalPageNo = Int()
    var is_Api_Being_Called : Bool = false

  @IBOutlet weak var lblSliderTitle: UILabel!
  @IBOutlet weak var vwCarousel: iCarousel!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet var btnDown: UIButton!
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var constraintHeightTableView: NSLayoutConstraint!
  @IBOutlet weak var carouselHeight: NSLayoutConstraint!
  @IBOutlet weak var imgViewMain: UIImageView!
  
  @IBOutlet weak var tblHome: UITableView!
  
  let screenSize: CGRect = UIScreen.main.bounds

    override func viewDidLoad() {
        super.viewDidLoad()

      self.scrollView.delegate = self
      
      lblSliderTitle.isHidden = true
      currentPageNo = 1
      
      let screenHeight = screenSize.height

      carouselHeight.constant = screenHeight - 130
      self.view.layoutIfNeeded()
      
        tblHome.tableFooterView =  UIView.init(frame: .zero)
        tblHome.layoutMargins = .zero
      
        tblHome.rowHeight = 80
        tblHome.estimatedRowHeight = UITableView.automaticDimension
      
        btnDown.imageColorChange(imageColor: UIColor.black)
        scrollView.isScrollEnabled = false
        pageControl.numberOfPages = 0
        
      
        pageControl.numberOfPages = 0
        pageControl.currentPage = 0
        
      
        self.getSliderList()
        self.fcmRegister()
      
      // Add reachability observer
      if let reachability = AppDelegate.sharedAppDelegate()?.reachability
      {
        NotificationCenter.default.addObserver( self, selector: #selector( self.reachabilityChanged ),name: Notification.Name.reachabilityChanged, object: reachability )
      }
      
      NotificationCenter.default.addObserver(self, selector: #selector(self.notificationRedirect(_:)), name: NSNotification.Name(rawValue: "notifications"), object: nil)
      
    }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    
    if AudioPlayerManager.shared.isPlaying() == true{
     
      carouselHeight.constant = self.view.frame.height - 180
      self.view.layoutIfNeeded()
      
    }
    
  }
 
    //MARK:- Api Call
    func getSliderList(){
        
    
        WebServices().CallGlobalAPI(url: WebService_Slider_Dashboard,headers: [:], parameters: [:], HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
            
            if(jsonResponce?.error != nil) {
                
                var errorMess = jsonResponce?.error?.localizedDescription
                errorMess = MESSAGE_Err_Service
                Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
            }
            else {
                
                if jsonResponce!["status"].stringValue == "true"{
                  self.getHome(pageNo: self.currentPageNo)
                    self.arrSlider = jsonResponce!["data"].arrayValue

                    if self.arrSlider.count != 0{
                      
                      
                          self.pageControl.numberOfPages = self.arrSlider.count
                        
                         /* let title = self.arrSlider[0]
                          
                          if title["link"].stringValue.count != 0 {
                            self.lblSliderTitle.text = "Video"
                          }else{
                            self.lblSliderTitle.text = "Image"
                          }*/
                          

                      DispatchQueue.main.async {
                        self.vwCarousel.type = iCarouselType.linear
                        self.vwCarousel.scrollToItem(at: 0, animated: true)
                        
                        //self.vwCarousel.scroll(byNumberOfItems: self.arrSlider.count, duration: 0.3)
                        //self.vwCarousel.scroll(byOffset: 375.0, duration: 0.3)
                        self.vwCarousel.isScrollEnabled = true
                        
                        
                        self.vwCarousel.autoscroll = -0.3;
                        self.vwCarousel.scrollSpeed = 0.3
                        self.vwCarousel.decelerationRate = 0.3
                        
                        

                        self.vwCarousel.reloadData()
                        self.view.layoutIfNeeded()
                      }
                      
//                          self.vwCarousel.reloadInputViews()
//                          self.vwCarousel.reloadItem(at: 0, animated: true)
                      
                    }
                    else
                    {
                        
                    
                    }
                    
                }
                else {
                        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: jsonResponce!["message"].stringValue)
                    }
                }
            }
    }
    
  func getHome(pageNo:Int){
      
     // let param = ["page":"\(pageNo)"]
    
    let param = ["page" : pageNo,
                 "app_id":Utility.getDeviceID()] as [String : Any]
      
      WebServices().CallGlobalAPI(url: WebService_Dashboard_List,headers: [:], parameters: param as NSDictionary, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
            
            if(jsonResponce?.error != nil) {
                
                var errorMess = jsonResponce?.error?.localizedDescription
                errorMess = MESSAGE_Err_Service
                Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
            }
            else {
                
                if jsonResponce!["status"].stringValue == "true"{
                  
                  self.is_Api_Being_Called = false

                  for dashboard in jsonResponce!["data"].arrayValue{
                    self.arrHome.append(dashboard)
                  }
                  
                  print("Total Count: \(self.arrHome.count)")
                  
                  if self.arrHome.count != 0{
                    DispatchQueue.main.async {
                      
                      self.totalPageNo = jsonResponce!["total_page"].intValue
                      self.tblHome.reloadData()
                      Utility.tableNoDataMessage(tableView: self.tblHome, message: "",messageColor:UIColor.white, displayMessage: .Center)
                    }
                  }
                  else{
                    self.tblHome.reloadData()
                    Utility.tableNoDataMessage(tableView: self.tblHome, message: "No results found",messageColor:UIColor.white, displayMessage: .Center)
                  }
                }
                else {
                    self.is_Api_Being_Called = false
                    Utility().showAlertMessage(vc: self, titleStr: "", messageStr: jsonResponce!["message"].stringValue)
                }
            }
        }
    }
  
  func fcmRegister(){
    
    let token = UserDefaults.standard.string(forKey: "fcmToken") ?? ""
  
    let  paramater = ["app_id":Utility.getDeviceID(),
                      "device_id":token,
                      "apple_id":token]
  
    WebServices().CallGlobalAPI(url: WebService_Notification_Token_Register,headers: [:], parameters: paramater as NSDictionary, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
      
      if(jsonResponce?.error != nil) {
        
        var errorMess = jsonResponce?.error?.localizedDescription
        errorMess = MESSAGE_Err_Service
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
      }
      else {
        
        if jsonResponce!["status"].stringValue == "true"{
          
       
        }
        else {
          
          if jsonResponce!["status"].stringValue == "false" && jsonResponce!["message"].stringValue == "No Data Found"{
            
         
          }
          Utility().showAlertMessage(vc: self, titleStr: "", messageStr: jsonResponce!["message"].stringValue)
        }
      }
    }
  }
  
  //MARK:- Notification Redirection
  @objc func notificationRedirect(_ notification: NSNotification) {

    
    /*
     
     "aps" : {
     "sound" : "default",
     "alert" : "Live Katha",
     "badge" : 1
     },
     "id" : "1",
     "type" : "1"
     
     {
     "type" : 1,
     "aps" : {
     "badge" : 1,
     "sound" : "default",
     "alert" : "Quotes"
     },
     "id" : "66"
     }
     */
    
    /*
     {
     "id" : "77",
     "type" : 12,
     "aps" : {
     "badge" : 1,
     "sound" : "default",
     "alert" : "Bapu Photo"
     }
     }
     
     "id" : "47",
     "aps" : {
     "sound" : "default",
     "badge" : 1,
     "alert" : "New Photo"
     },
     "type" : 11
     
     
     */
    
    
    if (notification.object as? JSON) != nil {
      
      let dictResult = notification.object as? JSON

      if dictResult!["type"].intValue == 1{
        //Quotes
        
        DispatchQueue.main.async {
          let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
          let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiDetailsVC") as! KathaChopaiDetailsVC
          vc.strTitle = "Quotes"
          vc.strId = dictResult!["id"].stringValue
          self.navigationController?.pushViewController(vc, animated:  true)
          
        }
      }else if dictResult!["type"].intValue == 11{
        //New Photo
        
        DispatchQueue.main.async {
          let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
          let vc = storyboard.instantiateViewController(withIdentifier: "WhatsNewPhotosVC") as! WhatsNewPhotosVC
          vc.screenDirection = .Whats_New_Photos
          self.navigationController?.pushViewController(vc, animated:  true)
          
        }
      }else if dictResult!["type"].intValue == 12{
        //Bapu Photo
        
        DispatchQueue.main.async {
          let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
          let vc = storyboard.instantiateViewController(withIdentifier: "WhatsNewPhotosVC") as! WhatsNewPhotosVC
          vc.screenDirection = .Media_Photos
          self.navigationController?.pushViewController(vc, animated:  true)
          
        }
      }else if dictResult!["type"].intValue == 14{
        //UpComing Katha
        
        DispatchQueue.main.async {
          
          let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
          let vc = storyboard.instantiateViewController(withIdentifier: "UpComingKathaDetailsVC") as! UpComingKathaDetailsVC
          vc.strId = dictResult!["id"].stringValue
          self.navigationController?.pushViewController(vc, animated:  true)
          
        }
      }
      else{
          //Live Katha
          let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
          let vc = storyboard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
          vc.screenDirection = .Live_Katha_Streaming_Video
          vc.strTitle = "Live Katha Video"
          self.navigationController?.pushViewController(vc, animated:  true)
        
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
  
  @IBAction func swipeUp(_ sender: Any) {
        scrollView.isScrollEnabled = true
    scrollView.scrollRectToVisible(self.view.frame, animated: true)
    }
}




//MARK TableView Delegate
extension DashboardVC : UITableViewDelegate, UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return arrHome.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let data = arrHome[indexPath.row]
    
    if data["list_heading"].stringValue == "Upcoming Katha"{

    let cellIdentifier = "UpcomingKathaTableViewCell"
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UpcomingKathaTableViewCell  else {
      fatalError("The dequeued cell is not an instance of MealTableViewCell.")
    }
    
    cell.lblDay.text = Utility.dateToString(dateStr: data["from_date"].stringValue, strDateFormat: "dd")
    cell.lblTitle.text = data["title"].stringValue
    cell.btnTitle.setTitle(data["list_heading"].stringValue, for: .normal)
    cell.lblDate.text = Utility.dateToString(dateStr: data["from_date"].stringValue, strDateFormat: "MM, yyyy")
    cell.lblScheduleDate.text = "\(Utility.dateToString(dateStr: data["from_date"].stringValue, strDateFormat: "dd-MM-yyyy"))"
    
    cell.btnTitle.tag = indexPath.row
    cell.btnTitle.addTarget(self, action: #selector(btnToSpecificScreen(_:)), for: UIControl.Event.touchUpInside)

      DispatchQueue.main.async {
        self.constraintHeightTableView.constant = self.tblHome.contentSize.height
        self.view.layoutIfNeeded()
      }
    
    print("TableView Height: \(constraintHeightTableView.constant)")
      
    return cell
    
    }
    else if data["list_heading"].stringValue == "Quotes"{
      //Quotes
      
      let cellIdentifier = "KathaChopaiTableViewCell"
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? KathaChopaiTableViewCell  else {
        fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        
      }
      
      cell.lblTitle.text = data["title"].stringValue
      cell.lblDate.text = Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd MMM yyyy")
      cell.lblDescription1.text = data["quotes_english"].stringValue
      cell.btnTitle.setTitle(data["list_heading"].stringValue, for: .normal)
      
//      cell.btnFavourite.isHidden = true
//      cell.btnShare.isHidden = true
      
      //cell.btnFavourite.tag = indexPath.row
      //cell.btnShare.tag = indexPath.row
      cell.btnTitle.tag = indexPath.row
      
      //cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
      
      //cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
      //cell.btnFavourite.addTarget(self, action: #selector(btnFavourite(_:)), for: UIControl.Event.touchUpInside)
      cell.btnTitle.addTarget(self, action: #selector(btnToSpecificScreen(_:)), for: UIControl.Event.touchUpInside)
      DispatchQueue.main.async {
        self.constraintHeightTableView.constant = self.tblHome.contentSize.height
        self.view.layoutIfNeeded()
      }
    
    print("TableView Height: \(constraintHeightTableView.constant)")
      return cell
      
    }
    else if data["list_heading"].stringValue == "KathaChopai"{
      //Katha Chopai
      
      let cellIdentifier = "KathaChopaiTableViewCell"
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? KathaChopaiTableViewCell  else {
        fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        
      }
      
      cell.lblTitle.text = "\(data["title"].stringValue)"
      cell.lblDate.text = Utility.dateToString(dateStr: data["from_date"].stringValue, strDateFormat: "dd MMM yyyy")
      cell.lblDescription1.text = data["description"].stringValue
      cell.btnTitle.setTitle(data["list_heading"].stringValue, for: .normal)
      //cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
      
      //cell.btnFavourite.tag = indexPath.row
      //cell.btnShare.tag = indexPath.row
      cell.btnTitle.tag = indexPath.row
      
      //cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
      //cell.btnFavourite.addTarget(self, action: #selector(btnFavourite(_:)), for: UIControl.Event.touchUpInside)
      
//      cell.btnFavourite.isHidden = true
//      cell.btnShare.isHidden = true

      cell.btnTitle.addTarget(self, action: #selector(btnToSpecificScreen(_:)), for: UIControl.Event.touchUpInside)
      cell.btnTitle.addTarget(self, action: #selector(btnToSpecificScreen(_:)), for: UIControl.Event.touchUpInside)
      
      DispatchQueue.main.async {
        self.constraintHeightTableView.constant = self.tblHome.contentSize.height
        self.view.layoutIfNeeded()
      }
    
    print("TableView Height: \(constraintHeightTableView.constant)")
      return cell
      
      
    }
    else if data["list_heading"].stringValue == "Ramcharit"{
      //Ram charit manas
      
      let cellIdentifier = "KathaChopaiTableViewCell"
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? KathaChopaiTableViewCell  else {
        fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        
      }
      
      cell.lblTitle.text = "\(data["title"].stringValue)"
      cell.lblDate.text = Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd MMM yyyy")
      cell.lblDescription1.text = data["description"].stringValue
      cell.btnTitle.setTitle("Ram Charit Manas", for: .normal)
      //cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
      
      //cell.btnFavourite.tag = indexPath.row
      //cell.btnShare.tag = indexPath.row
      cell.btnTitle.tag = indexPath.row
      
      //cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
      //cell.btnFavourite.addTarget(self, action: #selector(btnFavourite(_:)), for: UIControl.Event.touchUpInside)
      
//      cell.btnFavourite.isHidden = true
//      cell.btnShare.isHidden = true

      cell.btnTitle.addTarget(self, action: #selector(btnToSpecificScreen(_:)), for: UIControl.Event.touchUpInside)
      cell.btnTitle.addTarget(self, action: #selector(btnToSpecificScreen(_:)), for: UIControl.Event.touchUpInside)
      
      DispatchQueue.main.async {
        self.constraintHeightTableView.constant = self.tblHome.contentSize.height
        self.view.layoutIfNeeded()
      }
    
    print("TableView Height: \(constraintHeightTableView.constant)")
      return cell
      
    }
    else if data["list_heading"].stringValue == "Daily Katha Clip"{
      //Daily Katha
      
      let cellIdentifier = "YoutubeTableViewCell"
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? YoutubeTableViewCell  else {
        fatalError("The dequeued cell is not an instance of MealTableViewCell.")
      }
      
      cell.lblTitle.text = data["title"].stringValue
      cell.lblDuration.text = "(Duration: \(data["video_duration"].stringValue))"
      cell.lblDate.text = Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd-MM-yyyy")
      cell.btnTitle.setTitle(data["list_heading"].stringValue, for: .normal)
      
      let placeHolder = UIImage(named: "youtube_placeholder")
      
      cell.imgVideo.kf.indicatorType = .activity
      cell.imgVideo.kf.setImage(with: URL(string: "\(BASE_URL_IMAGE)\(data["video_image"].stringValue)"), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
      
      cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
      
      
      //cell.btnShare.tag = indexPath.row
      cell.btnYoutube.tag = indexPath.row
      //cell.btnFavourite.tag = indexPath.row
      cell.btnTitle.tag = indexPath.row
      
      //cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
      cell.btnYoutube.addTarget(self, action: #selector(btnYoutube), for: UIControl.Event.touchUpInside)
      //cell.btnFavourite.addTarget(self, action: #selector(btnFavourite), for: UIControl.Event.touchUpInside)
//
      cell.btnFavourite.isHidden = true
      cell.btnShare.isHidden = true

      cell.btnTitle.addTarget(self, action: #selector(btnToSpecificScreen(_:)), for: UIControl.Event.touchUpInside)
      DispatchQueue.main.async {
        self.constraintHeightTableView.constant = self.tblHome.contentSize.height
        self.view.layoutIfNeeded()
      }
    
    print("TableView Height: \(constraintHeightTableView.constant)")
      return cell
      
    }
    else if data["list_heading"].stringValue == "Bapu Articles"{
      //Bapu Articles
      
      let cellIdentifier = "YoutubeTableViewCell"
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? YoutubeTableViewCell  else {
        fatalError("The dequeued cell is not an instance of MealTableViewCell.")
      }
      
      cell.lblTitle.text = data["article"].stringValue
      cell.lblDuration.text = data["link"].stringValue
      cell.lblDate.text = Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd-MMM-yyyy")
      
      let placeHolder = UIImage(named: "youtube_placeholder")
      
      cell.imgVideo.kf.indicatorType = .activity
      cell.imgVideo.kf.setImage(with: URL(string: "\(BASE_URL_IMAGE)\(data["video_image"].stringValue)"), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
      
      cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
      
      //cell.btnShare.tag = indexPath.row
      cell.btnYoutube.tag = indexPath.row
      //cell.btnFavourite.tag = indexPath.row
      cell.btnTitle.tag = indexPath.row
      
      //cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
      cell.btnYoutube.addTarget(self, action: #selector(btnYoutube), for: UIControl.Event.touchUpInside)
      //cell.btnFavourite.addTarget(self, action: #selector(btnFavourite), for: UIControl.Event.touchUpInside)
      cell.btnTitle.addTarget(self, action: #selector(btnToSpecificScreen(_:)), for: UIControl.Event.touchUpInside)
      DispatchQueue.main.async {
        self.constraintHeightTableView.constant = self.tblHome.contentSize.height
        self.view.layoutIfNeeded()
      }
    
    print("TableView Height: \(constraintHeightTableView.constant)")
      return cell
      
    }
    else if data["list_heading"].stringValue == "Stuti" || data["list_heading"].stringValue == "Other Stuti" || data["list_heading"].stringValue == "Sankirtan"{
      //Sankirtan
      
      let cellIdentifier = "AudioTableViewCell"
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AudioTableViewCell  else {
        fatalError("The dequeued cell is not an instance of MealTableViewCell.")
      }
      
      cell.lblbTitle.text = data["title"].stringValue
      cell.lblDuration.text = "(Duration: \(data["video_duration"].stringValue))"
      cell.btnTitle.setTitle(data["list_heading"].stringValue, for: .normal)
      
      //cell.btnShare.tag  = indexPath.row
      cell.btnTitle.tag = indexPath.row
      
      //cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
      
      //cell.btnFavourite.tag  = indexPath.row
      //cell.btnFavourite.addTarget(self, action: #selector(btnFavourite), for: UIControl.Event.touchUpInside)
      
      //cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
      
//      cell.btnFavourite.isHidden = true
//      cell.btnShare.isHidden = true

      cell.btnTitle.addTarget(self, action: #selector(btnToSpecificScreen(_:)), for: UIControl.Event.touchUpInside)
      DispatchQueue.main.async {
        self.constraintHeightTableView.constant = self.tblHome.contentSize.height
        self.view.layoutIfNeeded()
      }
    print("TableView Height: \(constraintHeightTableView.constant)")
      
      return cell
      
      
    }
    else if data["list_heading"].stringValue == "Bapufavouriteshayari"{
      //Shayri
      
      let cellIdentifier = "AudioTableViewCell"
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AudioTableViewCell  else {
        fatalError("The dequeued cell is not an instance of MealTableViewCell.")
      }
      
      cell.lblbTitle.text = data["title"].stringValue
      cell.lblDuration.text = "\(data["quotes_english"].stringValue)\n\(data["quotes_hindi"].stringValue)"
      cell.lblDuration.numberOfLines = 4
      cell.btnTitle.setTitle("Shayari", for: .normal)
      
      //cell.btnShare.tag  = indexPath.row
      //cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
      
      //cell.btnFavourite.tag  = indexPath.row
      //cell.btnFavourite.addTarget(self, action: #selector(btnFavourite), for: UIControl.Event.touchUpInside)
      
      //cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
      
//      cell.btnFavourite.isHidden = true
//      cell.btnShare.isHidden = true

      cell.viewMusicIndicator.isHidden = true
      
      cell.btnTitle.tag = indexPath.row
      
      cell.btnTitle.addTarget(self, action: #selector(btnToSpecificScreen(_:)), for: UIControl.Event.touchUpInside)
      DispatchQueue.main.async {
        self.constraintHeightTableView.constant = self.tblHome.contentSize.height
        self.view.layoutIfNeeded()
      }
    print("TableView Height: \(constraintHeightTableView.constant)")
      
      return cell
      
    }
    else if data["list_heading"].stringValue == "Event"{
      //Quotes
      
      let cellIdentifier = "KathaChopaiTableViewCell"
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? KathaChopaiTableViewCell  else {
        fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        
      }
      
      cell.lblTitle.text = data["title"].stringValue
      cell.lblDate.text = Utility.dateToString(dateStr: data["from_date"].stringValue, strDateFormat: "dd MMM yyyy")
      //cell.lblDescription1.text = data["quotes_gujarati"].stringValue
      //cell.btnTitle.setTitle(data["list_heading"].stringValue, for: .normal)
      
//      cell.btnFavourite.isHidden = true
//      cell.btnShare.isHidden = true
      
//      cell.btnFavourite.tag = indexPath.row
//      cell.btnShare.tag = indexPath.row
      
      cell.btnTitle.tag = indexPath.row
      cell.btnTitle.setTitle(data["list_heading"].stringValue, for: .normal)
      
      
      //cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
      
//      cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
//      cell.btnFavourite.addTarget(self, action: #selector(btnFavourite(_:)), for: UIControl.Event.touchUpInside)
      cell.btnTitle.addTarget(self, action: #selector(btnToSpecificScreen(_:)), for: UIControl.Event.touchUpInside)
  
      DispatchQueue.main.async {
        self.constraintHeightTableView.constant = self.tblHome.contentSize.height
        self.view.layoutIfNeeded()
      }
      
      
      print("TableView Height: \(constraintHeightTableView.constant)")
      return cell
      
    }
    else{
      return UITableViewCell()
    }
    
  }
  

  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
  {
    if is_Api_Being_Called == false{
      if currentPageNo <  totalPageNo{
        print("Page Load....")
        is_Api_Being_Called = true
        currentPageNo += 1
        self.getHome(pageNo: currentPageNo)
      }
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
 
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  
    let data = arrHome[indexPath.row]
    
    if data["list_heading"].stringValue == "Quotes"{
      //Quotes
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiDetailsVC") as! KathaChopaiDetailsVC
      vc.strTitle = "Quotes"
      vc.strId = data["quotes_id"].stringValue
      navigationController?.pushViewController(vc, animated:  true)
      
    }
    else if data["list_heading"].stringValue == "KathaChopai"{
      //Katha Chopai
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiDetailsVC") as! KathaChopaiDetailsVC
      vc.strTitle = "Katha Chopai"
      vc.strId = data["katha_chopai_id"].stringValue
      navigationController?.pushViewController(vc, animated:  true)
      
    }
    else if data["list_heading"].stringValue == "Ramcharit"{
      //Ram charit manas
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiDetailsVC") as! KathaChopaiDetailsVC
      vc.strTitle = "Ram Charit Manas"
      vc.strId = data["ram_charit_id"].stringValue
      navigationController?.pushViewController(vc, animated:  true)
      
    }
    else if data["list_heading"].stringValue == "Stuti"{
      
    
      
    }else if data["list_heading"].stringValue == "Other Stuti"{
      
    
      
    }else if data["list_heading"].stringValue == "Sankirtan"{
      
      
    }
    else if data["list_heading"].stringValue == "Bapufavouriteshayari"{
      
     
      
    }else if data["list_heading"].stringValue == "Daily Katha Clip"{
      
     
      
    }else if data["list_heading"].stringValue == "Upcoming Katha"{
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "UpComingKathaDetailsVC") as! UpComingKathaDetailsVC
      vc.strId = data["upcoming_katha_id"].stringValue
      navigationController?.pushViewController(vc, animated:  true)
      
    }
    else if data["list_heading"].stringValue == "Event"{
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "EventsDetailsVC") as! EventsDetailsVC
      vc.strId = data["event_id"].stringValue
      navigationController?.pushViewController(vc, animated:  true)
      
    }
  }
  
  @IBAction func btnFavourite(_ sender: UIButton) {
    
    let data = arrHome[sender.tag]
    
    if arrHome.count != 0{
      
      var paramater = NSDictionary()
      
      if data["list_heading"].stringValue == "Quotes"{
        //Quotes
        
        paramater = ["app_id":Utility.getDeviceID(),
                     "favourite_for":1,
                     "favourite_id":data["quote_id"].stringValue]
        
      }
      else if data["list_heading"].stringValue == "KathaChopai"{
        //Katha Chopai
        
        paramater = ["app_id":Utility.getDeviceID(),
                     "favourite_for":2,
                     "favourite_id":data["katha_chopai_id"].stringValue]
        
      }
      else if data["list_heading"].stringValue == "Ramcharit"{
        //Ram charit manas
        
        paramater = ["app_id":Utility.getDeviceID(),
                     "favourite_for":3,
                     "favourite_id":data["ram_charit_manas_id"].stringValue]
        
      }
      else if data["list_heading"].stringValue == "Stuti"{
        
        paramater = ["app_id":Utility.getDeviceID(),
                     "favourite_for":5,
                     "favourite_id":data["stuti_id"].stringValue]
        
      }else if data["list_heading"].stringValue == "Other Stuti"{
        
        paramater = ["app_id":Utility.getDeviceID(),
                     "favourite_for":data["favourite_for"].stringValue,
                     "favourite_id":data["ram_charit_manas_id"].stringValue]
        
      }else if data["list_heading"].stringValue == "Sankirtan"{
        
        paramater = ["app_id":Utility.getDeviceID(),
                     "favourite_for":data["favourite_for"].stringValue,
                     "favourite_id":data["sankirtan_id"].stringValue]
        
      }
      else if data["list_heading"].stringValue == "Bapufavouriteshayari"{
        
        paramater = ["app_id":Utility.getDeviceID(),
                     "favourite_for":data["favourite_for"].stringValue,
                     "favourite_id":data["bapu_shayari_id"].stringValue]
        
      }else if data["list_heading"].stringValue == "Daily Katha Clip"{
        
        paramater = ["app_id":Utility.getDeviceID(),
                     "favourite_for":4,
                     "favourite_id":data["daily_katha_id"].stringValue]
        
      }
      
      
      WebServices().CallGlobalAPI(url: WebService_Favourite,headers: [:], parameters: paramater, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
        
        if(jsonResponce?.error != nil) {
          
          var errorMess = jsonResponce?.error?.localizedDescription
          errorMess = MESSAGE_Err_Service
          Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
        }
        else {
          
          if jsonResponce!["status"].stringValue == "true"{
            
            self.arrHome.removeAll()
            self.getHome(pageNo: 0)
            
          }
          else if jsonResponce!["status"].stringValue == "false"{
            
            if jsonResponce!["status"].stringValue == "No Data Found"{
              self.arrHome.removeAll()
              self.getHome(pageNo: 0)
              
            }
            
          }
          else {
            Utility().showAlertMessage(vc: self, titleStr: "", messageStr: jsonResponce!["message"].stringValue)
          }
        }
      }
      
    }
    
  }
  
  @IBAction func btnShare(_ sender: UIButton) {
    
    let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblHome)
    let indexPath = self.tblHome.indexPathForRow(at: buttonPosition)
    
    var share_Content = String()
    
    let data = arrHome[indexPath!.row]
    
    if data["list_heading"].stringValue == "Quotes"{
      //Quotes
      
      share_Content = "\(data["title"].stringValue) \n\nDate: \(Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd MMM yyyy")) \n\n \(data["quotes_gujarati"].stringValue) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
      
      
    }
    else if data["list_heading"].stringValue == "KathaChopai"{
      //Katha Chopai
      
      share_Content = "\(data["title"].stringValue) \n\nDate: \(Utility.dateToString(dateStr: data["from_date"].stringValue, strDateFormat: "dd MMM yyyy")) \n\n \(data["quotes_hindi"].stringValue) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
      
      
      
    }
    else if data["list_heading"].stringValue == "Ramcharit"{
      //Ram charit manas
      share_Content = "\(data["title"].stringValue) \n\nDate: \(Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd MMM yyyy")) \n\n \(data["description"].stringValue) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
      
      
      
    }
    else if data["list_heading"].stringValue == "Stuti"{
      
      share_Content = "\(data["title"].stringValue) \n\n(Duration: \(data["video_duration"].stringValue)) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
      
      
    }else if data["list_heading"].stringValue == "Other Stuti"{
      
      share_Content = "\(data["title"].stringValue) \n\n(Duration: \(data["video_duration"].stringValue)) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
      
      
    }else if data["list_heading"].stringValue == "Sankirtan"{
      
      share_Content = "\(data["title"].stringValue) \n\n(Duration: \(data["video_duration"].stringValue)) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
      
      
    }
    else if data["list_heading"].stringValue == "Bapufavouriteshayari"{
      
      share_Content = "Shayari \n\n \(data["quotes_gujarati"].stringValue) \n\n\(data["quotes_english"].stringValue) \n\n\(data["quotes_hindi"].stringValue)  \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
      
      
    }else if data["list_heading"].stringValue == "Daily Katha Clip"{
      
      share_Content = "\(data["title"].stringValue) \n(Duration: \(data["video_duration"].stringValue)) \n \(Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd-MM-yyyy")) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
      
      
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
    
    let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblHome)
    let indexPath = self.tblHome.indexPathForRow(at: buttonPosition)
    
    let data = arrHome[indexPath!.row]

    if data["youtube_link"].stringValue != ""{
      
      let videoURL = URL(string: "\(data["youtube_link"].stringValue)")
      
      if Utility.verifyUrl(urlString: data["youtube_link"].stringValue) == true{
        DispatchQueue.main.async {
          UIApplication.shared.open(videoURL!, options: [:])
        }
      }
      
    }else{
      
      let videoURL = URL(string: "\(BASE_URL_IMAGE)\(data["video_file"].stringValue)")
      
      let player = AVPlayer(url: videoURL!)
      let playerViewController = AVPlayerViewController()
      playerViewController.player = player
      self.present(playerViewController, animated: true) {
        playerViewController.player!.play()
        
      }
    }
  
    
  }
  
  @IBAction func btnToSpecificScreen(_ sender: UIButton) {
    
    let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblHome)
    let indexPath = self.tblHome.indexPathForRow(at: buttonPosition)
    
    let data = arrHome[indexPath!.row]
    
    if data["list_heading"].stringValue == "Quotes"{
      //Quotes
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiVC") as! KathaChopaiVC
      vc.screenDirection = .Quotes
      navigationController?.pushViewController(vc, animated:  true)
      
    }
    else if data["list_heading"].stringValue == "KathaChopai"{
      //Katha Chopai
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiVC") as! KathaChopaiVC
      vc.screenDirection = .Katha_Chopai
      navigationController?.pushViewController(vc, animated:  true)
      
    }
    else if data["list_heading"].stringValue == "Ramcharit"{
      //Ram charit manas
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiVC") as! KathaChopaiVC
      vc.screenDirection = .Ram_Charit_Manas
      navigationController?.pushViewController(vc, animated:  true)
      
    }
    else if data["list_heading"].stringValue == "Stuti"{
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "AudioVC") as! AudioVC
      vc.screenDirection = .Stuti
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if data["list_heading"].stringValue == "Other Stuti"{
      
      //Other Audio
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "AudioVC") as! AudioVC
      vc.screenDirection = .Others
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if data["list_heading"].stringValue == "Sankirtan"{
      
      //Sankirtan
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "AudioVC") as! AudioVC
      vc.screenDirection = .Sankirtan
      navigationController?.pushViewController(vc, animated:  true)
      
    }
    else if data["list_heading"].stringValue == "Bapufavouriteshayari"{
      
      //Sher O Shayri
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "ShayriVC") as! ShayriVC
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if data["list_heading"].stringValue == "Daily Katha Clip"{
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "WhatsNewVideoVC") as! WhatsNewVideoVC
      vc.screenDirection = .Daily_Katha_Clip
      navigationController?.pushViewController(vc, animated:  true)
      
    }
    else if data["list_heading"].stringValue == "Upcoming Katha"{
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "UpComingKathasVC") as! UpComingKathasVC
      navigationController?.pushViewController(vc, animated:  true)
      
    }
    else if data["list_heading"].stringValue == "Event"{
      
      //Events
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "EventsVC") as! EventsVC
      navigationController?.pushViewController(vc, animated:  true)
      
    }
    
    
  }
  
}

extension DashboardVC : iCarouselDataSource, iCarouselDelegate{
 
  func numberOfItems(in carousel: iCarousel) -> Int {
     return arrSlider.count
  }
  
  func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
    
   
    switch (option) {
    case .spacing: return 1.34 // 8 points spacing
    case .wrap:return 1;
    default: return value
    }
   
    
  }
  
  func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
    var itemView: UIImageView
    if (view == nil)
    {
      let screenWidth = screenSize.width * 0.70
      
      let screenHeight = screenSize.height
      
      itemView = UIImageView(frame:CGRect(x:0, y:0, width:screenWidth, height:screenHeight - 160))
      itemView.contentMode = .scaleAspectFit
    }
    else
    {
      itemView = view as! UIImageView;
    }
    
    let image = arrSlider[index]
    
    let placeHolder = UIImage(named: "youtube_placeholder")
    let imageStr = "\(BASE_URL_IMAGE)\(image["image"].stringValue)"
    let imageString = imageStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    
    
    itemView.kf.setImage(with: URL(string: imageString!), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
    
    return itemView
  }
  
  func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
    
    if arrSlider.count != 0{
      
   
      let image = arrSlider[carousel.currentItemIndex]
      
      let placeHolder = UIImage(named: "youtube_placeholder")
      let imageStr = "\(BASE_URL_IMAGE)\(image["image"].stringValue)"
      let imageString = imageStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
      
      self.imgViewMain.kf.setImage(with: URL(string: imageString!), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
      
      self.pageControl.currentPage = carousel.currentItemIndex
    }
    
    
  }
  
  
  
  private func carousel(carousel: iCarousel, didSelectItemAtIndex index: Int)
  {
    print(index)
  }
  
  
  
}

//MARK:- Menu Navigation Delegate
extension DashboardVC: MenuNavigationDelegate{
  
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
      
    }else if ScreenName == "Privacy Notice"{
      //Privacy Notice

      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "AboutTheAppVC") as! AboutTheAppVC
      vc.strTitle = "Privacy Notice"
      navigationController?.pushViewController(vc, animated:  true)
      
    }
  }
}

extension DashboardVC : InternetConnectionDelegate{
  
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
        
        if(vc is DashboardVC){
          Utility.internet_connection_Show(onViewController: self)
        }
      }
      
    }
    
  }
  
  func reloadPage() {
   
      self.arrHome.removeAll()
      self.getHome(pageNo: 0)
      
      if arrSlider.count == 0{
        self.getSliderList()
      }
    
  }
}
