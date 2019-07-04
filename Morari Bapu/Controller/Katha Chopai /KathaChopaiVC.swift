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
import LNPopupController

enum KathaChopaiScreenIdentify {
  case Katha_Chopai
  case Ram_Charit_Manas
  case Quotes

}

class KathaChopaiVC: UIViewController {

  @IBOutlet weak var tblKathaChopai: UITableView!
  var screenDirection = KathaChopaiScreenIdentify.Ram_Charit_Manas
  @IBOutlet weak var lblTitle: UILabel!

  var arrKathaChopia : [JSON] = []
  var arrFavourite = NSMutableArray()
  
  var currentPageNo = Int()
  var totalPageNo = Int()
  var is_Api_Being_Called : Bool = false
  
    override func viewDidLoad() {
        super.viewDidLoad()

      tblKathaChopai.tableFooterView =  UIView.init(frame: .zero)
      tblKathaChopai.layoutMargins = .zero
      
      tblKathaChopai.rowHeight = 150
      tblKathaChopai.estimatedRowHeight = UITableView.automaticDimension
    
      currentPageNo = 1
     
      // Add reachability observer
      if let reachability = AppDelegate.sharedAppDelegate()?.reachability
      {
        NotificationCenter.default.addObserver( self, selector: #selector( self.reachabilityChanged ),name: Notification.Name.reachabilityChanged, object: reachability )
      }
      
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if screenDirection == .Katha_Chopai{
        //Katha Chopai
        
        lblTitle.text = "Katha Chopai"
        self.arrKathaChopia.removeAll()
        self.arrFavourite.removeAllObjects()
        getKathaChopai(pageNo: currentPageNo)
    }else if screenDirection == .Ram_Charit_Manas{
        //Ram Charit Manas
        
        lblTitle.text = "Ram Charit Manas"
        self.arrKathaChopia.removeAll()
        self.arrFavourite.removeAllObjects()
        getKathaChopai(pageNo: currentPageNo)
    }
    else{
        //Quotes
        
        lblTitle.text = "Quotes"
        self.arrKathaChopia.removeAll()
        self.arrFavourite.removeAllObjects()
        getKathaChopai(pageNo: currentPageNo)
    }
    

    
  }

  //MARK:- Api Call
  func getKathaChopai(pageNo:Int){
    
    
    
    var api_Url = String()
    var param = NSDictionary()
    
    if screenDirection == .Katha_Chopai{
      //Katha Chopai
      
      param = ["page" : pageNo,
                   "app_id":Utility.getDeviceID(),
                   "favourite_for":"2"] as NSDictionary
      
      api_Url = WebService_Chopai_List
      
    }else if screenDirection == .Ram_Charit_Manas{
      //Ram Charit Manas
      
      param = ["page" : pageNo,
                   "app_id":Utility.getDeviceID(),
                   "favourite_for":"3"] as NSDictionary
      
      api_Url = WebService_Ram_Charit_Manas_List
    }
    else{
      //Quotes
      
      param = ["page" : pageNo,
                   "app_id":Utility.getDeviceID(),
                   "favourite_for":"1"] as NSDictionary
      
      api_Url = WebService_Quotes_List
    }
    
    WebServices().CallGlobalAPI(url: api_Url,headers: [:], parameters: param, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
      
      if(jsonResponce?.error != nil) {
        
        var errorMess = jsonResponce?.error?.localizedDescription
        errorMess = MESSAGE_Err_Service
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
      }
      else {
        
        if jsonResponce!["status"].stringValue == "true"{
          
          for result in jsonResponce!["data"].arrayValue{
            self.arrKathaChopia.append(result)
          }
          
          for result in jsonResponce!["MyFavourite"].arrayValue{
            self.arrFavourite.add(result.stringValue)
          }
          
          self.totalPageNo = jsonResponce!["total_page"].intValue
          
          self.is_Api_Being_Called = false

          
          if self.arrKathaChopia.count != 0{
              DispatchQueue.main.async {
              
              Utility.tableNoDataMessage(tableView: self.tblKathaChopai, message: "",messageColor:UIColor.white, displayMessage: .Center)

              self.tblKathaChopai .reloadData()
            }
          }
          
        }else if jsonResponce!["status"].stringValue == "false"{
          
          if jsonResponce!["message"].stringValue == "No Data Found"{
            
            DispatchQueue.main.async {
              self.tblKathaChopai .reloadData()
              Utility.tableNoDataMessage(tableView: self.tblKathaChopai, message: "Coming Soon", messageColor: UIColor.white, displayMessage: .Center)
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
  
}

//MARK TableView Delegate
extension KathaChopaiVC : UITableViewDelegate, UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return arrKathaChopia.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
    let cellIdentifier = "KathaChopaiTableViewCell"
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? KathaChopaiTableViewCell  else {
      fatalError("The dequeued cell is not an instance of MealTableViewCell.")
    }
  
      let data = arrKathaChopia[indexPath.row]
      
    if screenDirection == .Katha_Chopai {
      
      cell.lblTitle.text = "\(data["title"].stringValue)"
      cell.lblDate.text = Utility.dateToString(dateStr: data["from_date"].stringValue, strDateFormat: "dd MMM yyyy")
      cell.lblDescription1.text = data["katha_hindi"].stringValue
      
    }else if screenDirection == .Ram_Charit_Manas{
      
      cell.lblTitle.text = "\(data["title"].stringValue)"
      cell.lblDate.text = Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd MMM yyyy")
      cell.lblDescription1.text = data["katha_hindi"].stringValue
      
    }
    else{
      
      cell.lblTitle.text = data["title"].stringValue
      cell.lblTitle.numberOfLines = 1
      cell.lblDate.text = Utility.dateToString(dateStr: data["quotes_date"].stringValue, strDateFormat: "dd MMM yyyy")
      cell.lblDescription1.text = data["quotes_hindi"].stringValue
      
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
   
    var data = arrKathaChopia[indexPath.row]
    
    if data["is_read"].intValue == 0{
      
      data["is_read"] = true;
      
      arrKathaChopia[indexPath.row] = data
      
      let indexPath = NSIndexPath(row: indexPath.row, section: 0)
      tblKathaChopai.reloadRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.none)
      
      if screenDirection == .Katha_Chopai{
        
        let param = ["app_id":Utility.getDeviceID(),
                     "katha_chopai_id":data["id"].stringValue] as NSDictionary
        
        Utility.readUnread(api_Url: WebService_Katha_Chopai_Read_Unread, parameters: param)
     
      }
      else if screenDirection == .Ram_Charit_Manas{
        
        let param = ["app_id":Utility.getDeviceID(),
                     "ram_charit_manas_id":data["id"].stringValue] as NSDictionary
        
        Utility.readUnread(api_Url: WebService_Ram_Charit_Manas_Read_Unread, parameters: param)
     
      }else{
        
        let param = ["app_id":Utility.getDeviceID(),
                     "quote_id":data["id"].stringValue] as NSDictionary
        
        Utility.readUnread(api_Url: WebService_Quotes_Read_Unread, parameters: param)
  
      }
    }
    if screenDirection == .Katha_Chopai{
    
      let storyboard = UIStoryboard(name: Dashboard_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiDetailsVC") as! KathaChopaiDetailsVC
      vc.strTitle = lblTitle.text!
      vc.strId = data["id"].stringValue
      vc.arrKathaDetails = arrKathaChopia
      vc.indexPosition = indexPath
      navigationController?.pushViewController(vc, animated:  true)
      
    }
    else if screenDirection == .Ram_Charit_Manas{
    
      let storyboard = UIStoryboard(name: Dashboard_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiDetailsVC") as! KathaChopaiDetailsVC
      vc.strTitle = lblTitle.text!
      vc.strId = data["id"].stringValue
      vc.arrKathaDetails = arrKathaChopia
      vc.indexPosition = indexPath

      navigationController?.pushViewController(vc, animated:  true)
      
    }else{
    
      let storyboard = UIStoryboard(name: Dashboard_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiDetailsVC") as! KathaChopaiDetailsVC
      vc.strTitle = lblTitle.text!
      vc.strId = data["id"].stringValue
      vc.arrKathaDetails = arrKathaChopia
      vc.indexPosition = indexPath

      navigationController?.pushViewController(vc, animated:  true)
      
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    if indexPath.row == arrKathaChopia.count - 1{
      if is_Api_Being_Called == false{
        if currentPageNo <  totalPageNo{
          print("Page Load....")
          is_Api_Being_Called = true
          currentPageNo += 1
          self.getKathaChopai(pageNo: currentPageNo)
        }
      }
    }
  }
  
  
  
}

//MARK:- Menu Navigation Delegate
extension KathaChopaiVC : MenuNavigationDelegate{
  
  func SelectedMenu(ScreenName: String?) {
    
    if ScreenName == "Home"{
      //Home
      self.navigationController?.popToRootViewController(animated: true)
      
    }else if ScreenName == "Katha Chopai"{
      //Katha Chopai
      
      let storyboard = UIStoryboard(name: Dashboard_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiVC") as! KathaChopaiVC
      vc.screenDirection = .Katha_Chopai
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Ram Charitra Manas"{
      //Ram Charitra Manas
      let storyboard = UIStoryboard(name: Dashboard_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiVC") as! KathaChopaiVC
      vc.screenDirection = .Ram_Charit_Manas
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Upcoing Katha"{
      //Upcoing Katha
      
      let storyboard = UIStoryboard(name: Dashboard_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "UpComingKathasVC") as! UpComingKathasVC
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Quotes"{
      //Quotes
      let storyboard = UIStoryboard(name: Dashboard_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiVC") as! KathaChopaiVC
      vc.screenDirection = .Quotes
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Daily Katha Clip"{
      //Daily Katha Clip
      let storyboard = UIStoryboard(name: Media_Storyboard, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DailyKathaClipVC") as! DailyKathaClipVC
            navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Live Katha Audio"{
      //Live Katha Audio
      let storyboard = UIStoryboard(name: Menu_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
      vc.screenDirection = .Live_Katha_Streaming_Audio
      vc.strTitle = "Live Katha Audio"
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "You Tube Channel"{
      //You Tube Channel
      let storyboard = UIStoryboard(name: Menu_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
      vc.screenDirection = .Moraribapu_Youtube_Channel
      vc.strTitle = "Morari Bapu Youtube Channel"
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Live Katha Video"{
      //Live Katha Video
      let storyboard = UIStoryboard(name: Menu_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
      vc.screenDirection = .Live_Katha_Streaming_Video
      vc.strTitle = "Live Katha Video"
      navigationController?.pushViewController(vc, animated:  true)
      
    }
    else if ScreenName == "Media"{
      //Media
      
      let storyboard = UIStoryboard(name: Menu_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
      vc.screenDirection = .Media
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated:  true)
        }
      
      
    }else if ScreenName == "What's New"{
      //What's New
      let storyboard = UIStoryboard(name: Menu_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
      vc.screenDirection = .Whats_New
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Sangeet Ni Duniya"{
      //Sangeet Ni Duniya
      let storyboard = UIStoryboard(name: Menu_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
      vc.screenDirection = .Sangeet_Ni_Duniya_Online_Shop
      vc.strTitle = "Sangeet Ni Duniya Online Shop"
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Setting"{
      //Setting
      
      let storyboard = UIStoryboard(name: Menu_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
      vc.screenDirection = .Settings
      navigationController?.pushViewController(vc, animated:  true)
      
     }else if ScreenName == "Search"{
      //Search
      
   let storyboard = UIStoryboard(name: Menu_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated:  true)
        }
       }else if ScreenName == "Favourites"{
      //Favourites
      
      let storyboard = UIStoryboard(name: Media_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "FavouriteVC") as! FavouriteVC
      navigationController?.pushViewController(vc, animated:  true)
    }else if ScreenName == "Events"{
      //Events
      let storyboard = UIStoryboard(name: Dashboard_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "EventsVC") as! EventsVC
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Katha Ebook"{
      //Katha Ebook
      
      let storyboard = UIStoryboard(name: Menu_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaEBookVC") as! KathaEBookVC
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated:  true)
        }
      
    }else if ScreenName == "Privacy Notice"{
      //Privacy Notice

      let storyboard = UIStoryboard(name: Menu_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "AboutTheAppVC") as! AboutTheAppVC
      vc.strTitle = "Privacy Notice"
      DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated:  true)
      }
      
    }
  }
}

extension KathaChopaiVC : InternetConnectionDelegate{
  
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
        
        if(vc is KathaChopaiVC){
          Utility.internet_connection_Show(onViewController: self)
        }
      }
     
      
    }
    
  }
  
  func reloadPage() {
    
    self.arrKathaChopia.removeAll()
    self.arrFavourite.removeAllObjects()
    getKathaChopai(pageNo: 1)
    
  }
}


