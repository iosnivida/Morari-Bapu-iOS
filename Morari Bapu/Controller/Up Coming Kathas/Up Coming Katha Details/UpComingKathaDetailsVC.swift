//
//  KathaChopaiDetailsVC.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 08/10/18.
//  Copyright © 2018 Bhavin Chauhan. All rights reserved.
//

import UIKit
import SwiftyJSON

class UpComingKathaDetailsVC: UIViewController {
  
  @IBOutlet weak var lblTitle: UILabel!
  @IBOutlet weak var lblKathaLoction: UILabel!
  @IBOutlet weak var lblKathaDates: UILabel!
  @IBOutlet weak var lblKathaLanguages: UILabel!
  @IBOutlet weak var lblOtherInfo: UILabel!
  @IBOutlet weak var lblOtherInfoApi: UILabel!
  
  @IBOutlet weak var btnFavourites: UIButton!
  @IBOutlet weak var scrollView: UIScrollView!

  @IBOutlet weak var imgOtherInfo: UIImageView!
  var arrUpcomingKathaDetails = [String:JSON]()
  var arrKathaTiming = [JSON]()

  var strId = String()
  var arrFavourite = NSMutableArray()

  @IBOutlet weak var tblKathaTiming: UITableView!
  @IBOutlet weak var constraintHeightTableview: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tblKathaTiming.tableFooterView = UIView.init(frame: .zero)
    self.tblKathaTiming.separatorInset = .zero
    self.tblKathaTiming.layoutMargins = .zero
    self.tblKathaTiming.rowHeight = 60
    self.tblKathaTiming.estimatedRowHeight = UITableView.automaticDimension
    
    scrollView.isHidden = true
    
    // Add reachability observer
    if let reachability = AppDelegate.sharedAppDelegate()?.reachability
    {
      NotificationCenter.default.addObserver( self, selector: #selector( self.reachabilityChanged ),name: Notification.Name.reachabilityChanged, object: reachability )
    }
    
    getDetails()

  }
  
  //MARK:- Api Call
  func getDetails(){
    
    let  paramater = ["app_id":Utility.getDeviceID(),
                      "favourite_for":"14",
                      "id":strId]
    let  str_Url = WebService_Upcoming_Katha_Detail
    
    WebServices().CallGlobalAPI(url: str_Url,headers: [:], parameters: paramater as NSDictionary, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
      
      if(jsonResponce?.error != nil) {
        
        var errorMess = jsonResponce?.error?.localizedDescription
        errorMess = MESSAGE_Err_Service
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
      }
      else {
        
        if jsonResponce!["status"].stringValue == "true"{
          
          self.arrUpcomingKathaDetails = jsonResponce!["data"]["UpcomingKatha"].dictionaryValue
          self.arrKathaTiming = jsonResponce!["data"]["UpcomingKathaTime"].arrayValue
          DispatchQueue.main.async {
            
            
            if self.arrKathaTiming.count != 0{
              self.tblKathaTiming.reloadData()
            }else{
              self.constraintHeightTableview.constant = 16
              self.view.layoutIfNeeded()
            }
            self.scrollView.isHidden = false
     
            self.lblOtherInfoApi.text = self.arrUpcomingKathaDetails["other"]?.stringValue
            
            self.lblTitle.text = self.arrUpcomingKathaDetails["title"]?.stringValue
            self.lblKathaLoction.text = self.arrUpcomingKathaDetails["location"]?.stringValue
            self.lblKathaLanguages.text = self.arrUpcomingKathaDetails["language"]?.stringValue
            self.lblKathaDates.text = "\(Utility.dateToString(dateStr: (self.arrUpcomingKathaDetails["from_date"]?.stringValue)!, strDateFormat: "EEEE MMM dd'th', yyyy")) - \(Utility.dateToString(dateStr: (self.arrUpcomingKathaDetails["to_date"]?.stringValue)!, strDateFormat: "EEEE MMM dd'th', yyyy"))"
      
            
            for result in jsonResponce!["MyFavourite"].arrayValue {
              self.arrFavourite.add(result.stringValue)
            }
            
            
            let predicate: NSPredicate = NSPredicate(format: "SELF contains[cd] %@", self.arrUpcomingKathaDetails["id"]!.stringValue)
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
    Utility.hanuman_chalisha_Show(onViewController: self)
    
  }
  
  @IBAction func btnShare(_ sender: Any) {
    
     let share_Content = "UpComing Katha \n\n\(self.arrUpcomingKathaDetails["title"]!.stringValue) \n\nDate: \(self.arrUpcomingKathaDetails["location"]!.stringValue) \n\n \(self.arrUpcomingKathaDetails["language"]!.stringValue) \n\n\(Utility.dateToString(dateStr: (self.arrUpcomingKathaDetails["from_date"]?.stringValue)!, strDateFormat: "EEEE MMM dd'th', yyyy")) - \(Utility.dateToString(dateStr: (self.arrUpcomingKathaDetails["to_date"]?.stringValue)!, strDateFormat: "EEEE MMM dd'th', yyyy")) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
    
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
                     "favourite_for":"14",
                     "favourite_id":self.arrUpcomingKathaDetails["id"]!.stringValue]
    
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
  
  @IBAction func btnViewMap(_ sender: Any) {

    DispatchQueue.main.async {
      UIApplication.shared.open(URL(string: self.arrUpcomingKathaDetails["map_link"]!.stringValue)!, options: [:])
    }

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
      self.viewDidLoad()
      print("Reachable via WiFi & Cellular")
      
    }
    else
    {
      Utility.internet_connection_Show(onViewController: self)
      print("Network not reachable")
    }
    
  }
  
}

//MARK:- - TableView Delgate
extension UpComingKathaDetailsVC : UITableViewDelegate, UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return arrKathaTiming.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
      let cellIdentifier = "KathaTimingTableViewCell"
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? KathaTimingTableViewCell  else {
        fatalError("The dequeued cell is not an instance of DoggopediaLeftTableViewCell.")
      }
      
      let data = arrKathaTiming[indexPath.row]
    
    let paragraphStyle = NSMutableParagraphStyle()
    //line height size
    paragraphStyle.lineSpacing = 5.0
    let attrString = NSMutableAttributedString(string: "Katha Date: \(Utility.dateToString(dateStr: data["from_d"].stringValue, strDateFormat: "dd MMM yyyy")) To \(Utility.dateToString(dateStr: data["to_d"].stringValue, strDateFormat: "dd MMM yyyy")) \nfrom Time: \(data["from_time"].stringValue) To Time: \(data["to_time"].stringValue)")
    attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
    cell.lblTiming.attributedText = attrString
    
    
      self.constraintHeightTableview.constant = tableView.contentSize.height
      self.view.layoutIfNeeded()
      
      return cell
      
   
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    
  }
  
  @IBAction func btnParentSelection(_ sender: Any) {
    
  }
  
}

//MARK:- Menu Navigation Delegate
extension UpComingKathaDetailsVC: MenuNavigationDelegate{
  
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
