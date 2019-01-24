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
  var strTitle = String()
  
    override func viewDidLoad() {
        super.viewDidLoad()

      lblTitle.text = strTitle
      
      if lblTitle.text == "Katha Chopai"{
       
        lblSubTitle.text = "\(arrKathaDetails["title"]!.stringValue)-\(arrKathaDetails["title_no"]!.stringValue)"
        lblDate.text = Utility.dateToString(dateStr: arrKathaDetails["from_date"]?.stringValue ?? "", strDateFormat: "dd MMM yyyy")
        lblDescription1.text = arrKathaDetails["katha_gujarati"]!.stringValue
        lblDescription2.text = arrKathaDetails["katha_hindi"]!.stringValue
        lblDescription3.text = arrKathaDetails["katha_english"]!.stringValue
        lblDescription4.text = arrKathaDetails["description"]!.stringValue

      }else if lblTitle.text == "Ram Charit Manas"{
        
        lblSubTitle.text = "\(arrKathaDetails["title"]!.stringValue)-\(arrKathaDetails["title_no"]!.stringValue)"
        lblDate.text = Utility.dateToString(dateStr: arrKathaDetails["date"]?.stringValue ?? "", strDateFormat: "dd MMM yyyy")
        lblDescription1.text = arrKathaDetails["katha_gujarati"]!.stringValue
        lblDescription2.text = arrKathaDetails["katha_hindi"]!.stringValue
        lblDescription3.text = arrKathaDetails["katha_english"]!.stringValue
        lblDescription4.text = arrKathaDetails["description"]!.stringValue
        
      }
      else{
        
        lblSubTitle.text = arrKathaDetails["title"]!.stringValue
        lblDate.text = Utility.dateToString(dateStr: arrKathaDetails["quotes_date"]?.stringValue ?? "", strDateFormat: "dd MMM yyyy")
        lblDescription1.text = arrKathaDetails["quotes_gujarati"]!.stringValue
        lblDescription2.text = arrKathaDetails["quotes_hindi"]!.stringValue
        lblDescription3.text = arrKathaDetails["quotes_english"]!.stringValue

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
    Utility.hanuman_chalisha_Show(onViewController: self)
    
  }
  
  @IBAction func btnShare(_ sender: Any) {
    
    var share_Content = String()
    
    if lblTitle.text == "Katha Chopai"{
      
      share_Content = "\(arrKathaDetails["title"]!.stringValue)-\(arrKathaDetails["title_no"]!.stringValue) \n\nDate: \(Utility.dateToString(dateStr: arrKathaDetails["from_date"]?.stringValue ?? "", strDateFormat: "dd MMM yyyy")) \n\n \(arrKathaDetails["katha_gujarati"]!.stringValue) \n\n\(arrKathaDetails["katha_hindi"]!.stringValue) \n\n\(arrKathaDetails["katha_english"]!.stringValue) \n\n\(arrKathaDetails["description"]!.stringValue) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
      
      
    }else if lblTitle.text == "Ram Charit Manas"{
      
        share_Content = "\(arrKathaDetails["title"]!.stringValue)-\(arrKathaDetails["title_no"]!.stringValue) \n\nDate: \(Utility.dateToString(dateStr: arrKathaDetails["date"]?.stringValue ?? "", strDateFormat: "dd MMM yyyy")) \n\n \(arrKathaDetails["katha_gujarati"]!.stringValue) \n\n\(arrKathaDetails["katha_hindi"]!.stringValue) \n\n\(arrKathaDetails["katha_english"]!.stringValue) \n\n\(arrKathaDetails["description"]!.stringValue) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
    }
    else{
      
        share_Content = "\(arrKathaDetails["title"]!.stringValue) \n\nDate: \(Utility.dateToString(dateStr: arrKathaDetails["quotes_date"]?.stringValue ?? "", strDateFormat: "dd MMM yyyy")) \n\n \(arrKathaDetails["quotes_gujarati"]!.stringValue) \n\n\(arrKathaDetails["quotes_hindi"]!.stringValue) \n\n\(arrKathaDetails["quotes_english"]!.stringValue) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
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
    
    if lblTitle.text == "Katha Chopai"{
  
      let paramater = ["app_id":Utility.getDeviceID(),
                       "favourite_for":"2",
                       "favourite_id":arrKathaDetails["id"]?.stringValue]
      
      WebServices().CallGlobalAPI(url: WebService_Favourite,headers: [:], parameters: paramater as NSDictionary, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
        
        if(jsonResponce?.error != nil) {
          
          var errorMess = jsonResponce?.error?.localizedDescription
          errorMess = MESSAGE_Err_Service
          Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
        }
        else {
          
          if jsonResponce!["status"].stringValue == "true"{
            
            self.btnFavourite.setImage(UIImage(named: "unfavorite"), for: .normal)
            self.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)

            
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
