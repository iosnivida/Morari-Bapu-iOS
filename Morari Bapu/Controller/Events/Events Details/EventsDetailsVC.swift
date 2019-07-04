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

class EventsDetailsVC: UIViewController {
  
  var arrEvents = [String:JSON]()
  var arrFavourite = NSMutableArray()
  
  var strId = String()
  
  @IBOutlet weak var lblDate: UILabel!
  @IBOutlet weak var lblTitle: UILabel!
  @IBOutlet weak var lblDescription: UILabel!
  @IBOutlet weak var btnShare: UIButton!
  @IBOutlet weak var btnFavourites: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    getDetails()
    
    // Add reachability observer
    if let reachability = AppDelegate.sharedAppDelegate()?.reachability
    {
      NotificationCenter.default.addObserver( self, selector: #selector( self.reachabilityChanged ),name: Notification.Name.reachabilityChanged, object: reachability )
    }
  
  }
  
  //MARK:- Api Call
  func getDetails(){
  
     let  paramater = ["app_id":Utility.getDeviceID(),
                       "favourite_for":"15",
                       "id":strId]
    
     let  str_Url = WebService_Event_Detail
    
    
    WebServices().CallGlobalAPI(url: str_Url,headers: [:], parameters: paramater as NSDictionary, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
      
      if(jsonResponce?.error != nil) {
        
        var errorMess = jsonResponce?.error?.localizedDescription
        errorMess = MESSAGE_Err_Service
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
      }
      else {
        
        if jsonResponce!["status"].stringValue == "true"{
          
          self.arrEvents = jsonResponce!["data"]["Event"].dictionaryValue
          
          DispatchQueue.main.async {
            
            self.lblDescription.text = self.arrEvents["description"]?.stringValue
            
            self.lblDate.text = "\(Utility.dateToString(dateStr: self.arrEvents["from_date"]!.stringValue, strDateFormat: "dd-MM-yyyy")) To \(Utility.dateToString(dateStr: self.arrEvents["to_date"]!.stringValue, strDateFormat: "dd-MM-yyyy"))"
            
            self.lblTitle.text = self.arrEvents["title"]?.stringValue
            
            for result in jsonResponce!["MyFavourite"].arrayValue {
              self.arrFavourite.add(result.stringValue)
            }
            
            
            let predicate: NSPredicate = NSPredicate(format: "SELF contains[cd] %@", self.arrEvents["id"]!.stringValue)
            let result = self.arrFavourite.filtered(using: predicate)
            
            if result.count != 0{
              self.btnFavourites.setImage(UIImage(named: "favorite"), for: .normal)
            }else{
              self.btnFavourites.setImage(UIImage(named: "unfavorite"), for: .normal)
            }
            
          }
        }
        else {
          
          if jsonResponce!["status"].stringValue == "false" && jsonResponce!["message"].stringValue == "No Data Found"{
            
            self.lblDate.text = ""
            self.lblTitle.text = ""
            self.lblDescription.text = ""
            
          }
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
  
  @IBAction func btnShare(_ sender: Any) {
    
    let share_Content = "Event \n\n\(self.arrEvents["title"]!.stringValue) \n\n\(self.arrEvents["description"]!.stringValue) \n\nDate: \(Utility.dateToString(dateStr: self.arrEvents["from_date"]!.stringValue, strDateFormat: "dd-MM-yyyy")) To \(Utility.dateToString(dateStr: self.arrEvents["to_date"]!.stringValue, strDateFormat: "dd-MM-yyyy"))  \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
    
    let textToShare = [share_Content]
    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
    
    // exclude some activity types from the list (optional)
    activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
    
    DispatchQueue.main.async {
      self.present(activityViewController, animated: true, completion: nil)
    }
    
  }
  
  @IBAction func btnFavourites(_ sender: Any) {
    
    let paramater = ["app_id":Utility.getDeviceID(),
                     "favourite_for":"15",
                     "favourite_id":self.arrEvents["id"]!.stringValue]
    
    WebServices().CallGlobalAPI(url: WebService_Favourite,headers: [:], parameters: paramater as NSDictionary, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
      
      if(jsonResponce?.error != nil) {
        
        var errorMess = jsonResponce?.error?.localizedDescription
        errorMess = MESSAGE_Err_Service
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
      }
      else {
        
        if jsonResponce!["status"].stringValue == "true"{
          if jsonResponce!["message"].stringValue == "Added in your favourite list"{
            self.btnFavourites.setImage(UIImage(named: "favorite"), for: .normal)
          }else{
            self.btnFavourites.setImage(UIImage(named: "unfavorite"), for: .normal)
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
extension EventsDetailsVC: MenuNavigationDelegate{
  
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

extension EventsDetailsVC : InternetConnectionDelegate{
  
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
        
        if(vc is EventsDetailsVC){
          Utility.internet_connection_Show(onViewController: self)
        }
      }
      
    }
    
  }
  
  func reloadPage() {
    
    self.viewDidLoad()
    
  }
}
