//
//  KathaChopaiDetailsVC.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 08/10/18.
//  Copyright © 2018 Bhavin Chauhan. All rights reserved.
//

import UIKit
import SwiftyJSON

class KathaChopaiDetailsVC: UIViewController {

  @IBOutlet weak var lblTitle: UILabel!
  @IBOutlet weak var lblSubTitle: UILabel!
  @IBOutlet weak var btnShare: UIButton!
  @IBOutlet weak var btnFavourite: UIButton!
  @IBOutlet weak var lblDate: UILabel!
  @IBOutlet weak var lblDescription1: UILabel!
  @IBOutlet weak var lblDescription2: UILabel!
  @IBOutlet weak var lblDescription3: UILabel!
  @IBOutlet weak var lblDescription4: UILabel!

  var arrKathaDetails = [String:JSON]()
  var arrFavourite = NSArray()

  var strTitle = String()
  var strId = String()
  
    override func viewDidLoad() {
        super.viewDidLoad()

      lblDate.text = ""
      lblDescription1.text = ""
      
      lblTitle.text = strTitle
      
      getDetails()
    
      // Add reachability observer
      if let reachability = AppDelegate.sharedAppDelegate()?.reachability
      {
        NotificationCenter.default.addObserver( self, selector: #selector( self.reachabilityChanged ),name: Notification.Name.reachabilityChanged, object: reachability )
      }
      
    }
  
  //MARK:- Api Call
  func getDetails(){
    

    var paramater = NSDictionary()
    var str_Url = String()

    if lblTitle.text == "Katha Chopai"{
      
      paramater = ["app_id":Utility.getDeviceID(),
                   "favourite_for":"2",
                   "id":strId]
      str_Url = WebService_Katha_Chopai_Details
      
    }else if lblTitle.text == "Ram Charit Manas"{
      
      paramater = ["app_id":Utility.getDeviceID(),
                   "favourite_for":"3",
                   "id":strId]

      str_Url = WebService_Ram_Charit_Manas_Detail
    }
    else{
      
      paramater = ["app_id":Utility.getDeviceID(),
                   "favourite_for":"1",
                   "id":strId]

      str_Url = WebService_Quotes_Details
    }
    
    WebServices().CallGlobalAPI(url: str_Url,headers: [:], parameters: paramater, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
      
      if(jsonResponce?.error != nil) {
        
        var errorMess = jsonResponce?.error?.localizedDescription
        errorMess = MESSAGE_Err_Service
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
      }
      else {
        
        if jsonResponce!["status"].stringValue == "true"{
 
          
          self.lblTitle.text = self.strTitle
          
          if self.lblTitle.text == "Katha Chopai"{
            
            self.arrKathaDetails = jsonResponce!["data"]["KathaChopai"].dictionaryValue
            self.arrFavourite = jsonResponce!["MyFavourite"].arrayObject! as NSArray
            
            
            self.lblSubTitle.text = "\(self.arrKathaDetails["title"]!.stringValue)"
            self.lblDate.text = Utility.dateToString(dateStr: self.arrKathaDetails["from_date"]?.stringValue ?? "", strDateFormat: "dd MMM yyyy")
            self.lblDescription1.text = self.arrKathaDetails["katha_hindi"]!.stringValue
            self.lblDescription2.text = self.arrKathaDetails["katha_gujarati"]!.stringValue
            self.lblDescription3.text = self.arrKathaDetails["katha_english"]!.stringValue
            self.lblDescription4.text = self.arrKathaDetails["description"]!.stringValue
            
            
            let predicate: NSPredicate = NSPredicate(format: "SELF contains[cd] %@", self.arrKathaDetails["id"]!.stringValue)
            let result = self.arrFavourite.filtered(using: predicate)
            
            if result.count != 0{
              self.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
            }else{
              self.btnFavourite.setImage(UIImage(named: "unfavorite"), for: .normal)
            }
            
            
          }else if self.lblTitle.text == "Ram Charit Manas"{
            
            self.arrKathaDetails = jsonResponce!["data"]["Ramcharit"].dictionaryValue
            self.arrFavourite = jsonResponce!["MyFavourite"].arrayObject! as NSArray
            
            
            self.lblSubTitle.text = "\(self.arrKathaDetails["title"]!.stringValue)"
            self.lblDate.text = Utility.dateToString(dateStr: self.arrKathaDetails["date"]?.stringValue ?? "", strDateFormat: "dd MMM yyyy")
            self.lblDescription1.text = self.arrKathaDetails["katha_gujarati"]!.stringValue
            self.lblDescription2.text = self.arrKathaDetails["katha_hindi"]!.stringValue
            self.lblDescription3.text = self.arrKathaDetails["katha_english"]!.stringValue
            self.lblDescription4.text = self.arrKathaDetails["description"]!.stringValue
            
           let predicate: NSPredicate = NSPredicate(format: "SELF contains[cd] %@", self.arrKathaDetails["id"]!.stringValue)
            let result = self.arrFavourite.filtered(using: predicate)
            
            if result.count != 0{
              self.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
            }else{
              self.btnFavourite.setImage(UIImage(named: "unfavorite"), for: .normal)
            }
            
          }
          else{
            
            self.arrKathaDetails = jsonResponce!["data"]["Quote"].dictionaryValue
            self.arrFavourite = jsonResponce!["MyFavourite"].arrayObject! as NSArray
            
            
            self.lblSubTitle.text = self.arrKathaDetails["title"]!.stringValue
            self.lblDate.text = Utility.dateToString(dateStr: self.arrKathaDetails["quotes_date"]?.stringValue ?? "", strDateFormat: "dd MMM yyyy")
            self.lblDescription1.text = self.arrKathaDetails["quotes_gujarati"]!.stringValue
            self.lblDescription2.text = self.arrKathaDetails["quotes_hindi"]!.stringValue
            self.lblDescription3.text = self.arrKathaDetails["quotes_english"]!.stringValue
            
            let predicate: NSPredicate = NSPredicate(format: "SELF contains[cd] %@", self.arrKathaDetails["id"]!.stringValue)
            let result = self.arrFavourite.filtered(using: predicate)
            
            if result.count != 0{
              self.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
            }else{
              self.btnFavourite.setImage(UIImage(named: "unfavorite"), for: .normal)
            }
            
          }
        }
        else {
          
          if jsonResponce!["status"].stringValue == "false" && jsonResponce!["message"].stringValue == "No Data Found"{
           
            self.lblTitle.text = ""
            self.lblSubTitle.text = ""
            self.lblDate.text = ""
            self.lblDescription1.text = ""
            self.lblDescription2.text = ""
            self.lblDescription3.text = ""
            self.lblDescription4.text = ""
            self.btnShare.isHidden = true
            self.btnFavourite.isHidden = true
            
          }
          Utility().showAlertMessage(vc: self, titleStr: "", messageStr: jsonResponce!["message"].stringValue)
        }
      }
    }
  }
  
  //MARK : Button Event
  @IBAction func btnBack(_ sender: Any) {
    self.navigationController?.popViewController(animated:true)
  }
  
  @IBAction func backToHome(_ sender: Any) {
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  @IBAction func btnMenu(_ sender: Any) {
    Utility.menu_Show(onViewController: self)
    
  }
  
  @IBAction func btnHanumanChalisha(_ sender: Any) {
    let storyboardCustom : UIStoryboard = UIStoryboard(name: Custome_Storyboard, bundle: nil)
    let objVC = storyboardCustom.instantiateViewController(withIdentifier: "HanumanChalishaVC") as? HanumanChalishaVC
    self.navigationController?.pushViewController(objVC!, animated: true)
    
  }
  
  @IBAction func btnShare(_ sender: Any) {
    
    var share_Content = String()
    
    if lblTitle.text == "Katha Chopai"{
      
      share_Content = "Katha Chopai \n\n\(arrKathaDetails["title"]!.stringValue) \n\nDate: \(Utility.dateToString(dateStr: arrKathaDetails["from_date"]?.stringValue ?? "", strDateFormat: "dd MMM yyyy")) \n\n \(arrKathaDetails["katha_gujarati"]!.stringValue) \n\n\(arrKathaDetails["katha_hindi"]!.stringValue) \n\n\(arrKathaDetails["katha_english"]!.stringValue) \n\n\(arrKathaDetails["description"]!.stringValue) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
      
      
    }else if lblTitle.text == "Ram Charit Manas"{
      
        share_Content = "Ram Charit Manas \n\n\(arrKathaDetails["title"]!.stringValue) \n\nDate: \(Utility.dateToString(dateStr: arrKathaDetails["date"]?.stringValue ?? "", strDateFormat: "dd MMM yyyy")) \n\n \(arrKathaDetails["katha_gujarati"]!.stringValue) \n\n\(arrKathaDetails["katha_hindi"]!.stringValue) \n\n\(arrKathaDetails["katha_english"]!.stringValue) \n\n\(arrKathaDetails["description"]!.stringValue) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
    }
    else{
      
        share_Content = "Quotes \n\n\(arrKathaDetails["title"]!.stringValue) \n\nDate: \(Utility.dateToString(dateStr: arrKathaDetails["quotes_date"]?.stringValue ?? "", strDateFormat: "dd MMM yyyy")) \n\n \(arrKathaDetails["quotes_gujarati"]!.stringValue) \n\n\(arrKathaDetails["quotes_hindi"]!.stringValue) \n\n\(arrKathaDetails["quotes_english"]!.stringValue) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
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
  
  @IBAction func btnFavourite(_ sender: Any) {
    
    var paramater = NSDictionary()
    
    if lblTitle.text == "Katha Chopai"{
      
      paramater = ["app_id":Utility.getDeviceID(),
                       "favourite_for":"2",
                       "favourite_id":arrKathaDetails["id"]!.stringValue]
      
      
      }else if lblTitle.text == "Ram Charit Manas"{
      
          paramater = ["app_id":Utility.getDeviceID(),
                       "favourite_for":"3",
                       "favourite_id":arrKathaDetails["id"]!.stringValue]
      
      }
      else{
      
          paramater = ["app_id":Utility.getDeviceID(),
                       "favourite_for":"1",
                       "favourite_id":arrKathaDetails["id"]!.stringValue]
      
      }
    
    WebServices().CallGlobalAPI(url: WebService_Favourite,headers: [:], parameters: paramater as NSDictionary, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
      
      if(jsonResponce?.error != nil) {
        
        var errorMess = jsonResponce?.error?.localizedDescription
        errorMess = MESSAGE_Err_Service
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
      }
      else {
        
        if jsonResponce!["status"].stringValue == "true"{
          
          if jsonResponce!["message"].stringValue == "Added in your favourite list"{
            self.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
          }else{
            self.btnFavourite.setImage(UIImage(named: "unfavorite"), for: .normal)
          }
        }
        else {
          Utility().showAlertMessage(vc: self, titleStr: "", messageStr: jsonResponce!["message"].stringValue)
        }
      }
    }
  }
  
  
}

//MARK:- Menu Navigation Delegate
extension KathaChopaiDetailsVC: MenuNavigationDelegate{
  
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

extension KathaChopaiDetailsVC : InternetConnectionDelegate{
  
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
        
        if(vc is KathaChopaiDetailsVC){
          Utility.internet_connection_Show(onViewController: self)
        }
      }
      
    }
    
  }
  
  func reloadPage() {
    
    self.viewDidLoad()
    
  }
}
