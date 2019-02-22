//
//  KathaChopaiVC.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 02/10/18.
//  Copyright © 2018 Bhavin Chauhan. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class UpComingKathasVC: UIViewController {
  
  @IBOutlet weak var tblUpComingKathas: UITableView!
  @IBOutlet weak var lblTitle: UILabel!
  
  var arrUpComingKathas : [JSON] = []
  
  var currentPageNo = Int()
  var totalPageNo = Int()
  var is_Api_Being_Called : Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tblUpComingKathas.tableFooterView =  UIView.init(frame: .zero)
    tblUpComingKathas.layoutMargins = .zero
    
    tblUpComingKathas.rowHeight = 108
    tblUpComingKathas.estimatedRowHeight = UITableView.automaticDimension
    
    currentPageNo = 1
    
    lblTitle.text = "Upcoming Kathas"
    
    arrUpComingKathas.removeAll()
    getUpcomingKathas(pageNo: currentPageNo)
    
    // Add reachability observer
    if let reachability = AppDelegate.sharedAppDelegate()?.reachability
    {
      NotificationCenter.default.addObserver( self, selector: #selector( self.reachabilityChanged ),name: Notification.Name.reachabilityChanged, object: reachability )
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
   
 

  }
  
  //MARK:- Api Call
  func getUpcomingKathas(pageNo:Int){
    
     let param = ["page" : pageNo,
               "app_id":Utility.getDeviceID(),
               "favourite_for":"14"] as NSDictionary
    
    WebServices().CallGlobalAPI(url: WebService_Upcoming_Katha_List,headers: [:], parameters: param, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
      
      if(jsonResponce?.error != nil) {
        
        var errorMess = jsonResponce?.error?.localizedDescription
        errorMess = MESSAGE_Err_Service
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
      }
      else {
        
        if jsonResponce!["status"].stringValue == "true"{
          
          for result in jsonResponce!["data"].arrayValue {
            self.arrUpComingKathas.append(result)
          }
          
          self.totalPageNo = jsonResponce!["total_page"].intValue

          self.is_Api_Being_Called = false

          if self.arrUpComingKathas.count != 0{
            DispatchQueue.main.async {
              
              Utility.tableNoDataMessage(tableView: self.tblUpComingKathas, message: "",messageColor:UIColor.white, displayMessage: .Center)
              
              self.tblUpComingKathas .reloadData()
            }
          }
          
          
        }else if jsonResponce!["status"].stringValue == "false"{
          
          if jsonResponce!["message"].stringValue == "No Data Found"{
            
            DispatchQueue.main.async {
              self.tblUpComingKathas .reloadData()
              Utility.tableNoDataMessage(tableView: self.tblUpComingKathas, message: "Coming Soon", messageColor: UIColor.white, displayMessage: .Center)
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

  //MARK:- Internet Checking
  @objc private func reachabilityChanged( notification: NSNotification )
  {
    guard let reachability = notification.object as? Reachability else
    {
      return
    }
    
    if reachability.connection == .wifi || reachability.connection == .cellular {
      
      Utility.internet_connection_hide(onViewController: self)
      arrUpComingKathas.removeAll()
      getUpcomingKathas(pageNo: 1)
      print("Reachable via WiFi & Cellular")
      
    }
    else
    {
      Utility.internet_connection_Show(onViewController: self)
      print("Network not reachable")
    }
    
  }
  
}

//MARK TableView Delegate
extension UpComingKathasVC : UITableViewDelegate, UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrUpComingKathas.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cellIdentifier = "UpcomingKathaTableViewCell"
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UpcomingKathaTableViewCell  else {
      fatalError("The dequeued cell is not an instance of MealTableViewCell.")
    }
    
    let data = arrUpComingKathas[indexPath.row]

    
    cell.lblDay.text = Utility.dateToString(dateStr: data["from_date"].stringValue, strDateFormat: "dd")
    cell.lblTitle.text = data["title"].stringValue
    cell.lblDate.text = Utility.dateToString(dateStr: data["from_date"].stringValue, strDateFormat: "MM, yyyy")
    cell.lblScheduleDate.text = "\(Utility.dateToString(dateStr: data["from_date"].stringValue, strDateFormat: "dd'th' MMM, yyyy")) To \(Utility.dateToString(dateStr: data["to_date"].stringValue, strDateFormat: "dd'th' MMM, yyyyy"))"
    
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
    
    var data = arrUpComingKathas[indexPath.row]
    
    if data["is_read"].intValue == 0{
      
      arrUpComingKathas[indexPath.row] = data
      
      let indexPath = NSIndexPath(row: indexPath.row, section: 0)
      tblUpComingKathas.reloadRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.none)
      
      
        let param = ["app_id":Utility.getDeviceID(),
                     "upcoming_katha_id":data["id"].stringValue] as NSDictionary
        
        Utility.readUnread(api_Url: WebService_UpComming_Katha_Read_Unread, parameters: param)
        
      }
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "UpComingKathaDetailsVC") as! UpComingKathaDetailsVC
      vc.strId = data["id"].stringValue
      navigationController?.pushViewController(vc, animated:  true)
    
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    if indexPath.row == arrUpComingKathas.count - 1{
      if is_Api_Being_Called == false{
        if currentPageNo <  totalPageNo{
          print("Page Load....")
          is_Api_Being_Called = true
          currentPageNo += 1
          self.getUpcomingKathas(pageNo: currentPageNo)
        }
      }
    }
  }
  
}

//MARK:- Menu Navigation Delegate
extension UpComingKathasVC : MenuNavigationDelegate{
  
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