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

class KathaEBookVC: UIViewController {

  var arrKathaEBook  = [JSON]()

  @IBOutlet weak var tblKathaEBook: UITableView!
  
  override func viewDidLoad() {
        super.viewDidLoad()

    tblKathaEBook.tableFooterView =  UIView.init(frame: .zero)
    tblKathaEBook.layoutMargins = .zero
    
    tblKathaEBook.rowHeight = 80
    tblKathaEBook.estimatedRowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    
    DispatchQueue.main.async {
      self.getKathaEBook()
    }
    
    }
    
  //MARK:- Api Call
  func getKathaEBook(){
    
    let param = ["id" : "1",
      "app_id":Utility.getDeviceID(),
      "favourite_for":"1"] as NSDictionary
    
    WebServices().CallGlobalAPI(url: WebService_Katha_EBook,headers: [:], parameters: param, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
      
      if(jsonResponce?.error != nil) {
        
        var errorMess = jsonResponce?.error?.localizedDescription
        errorMess = MESSAGE_Err_Service
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
      }
      else {
        
        if jsonResponce!["status"].stringValue == "true"{
          self.arrKathaEBook = jsonResponce!["data"].arrayValue
          
          if self.arrKathaEBook.count != 0{
            
            DispatchQueue.main.async {
              self.tblKathaEBook .reloadData()
              Utility.tableNoDataMessage(tableView: self.tblKathaEBook, message: "", messageColor: UIColor.black, displayMessage: .Center)
            }
          }
          else
          {
            
            DispatchQueue.main.async {
              self.tblKathaEBook .reloadData()
              Utility.tableNoDataMessage(tableView: self.tblKathaEBook, message: "No E-Book", messageColor: UIColor.black, displayMessage: .Center)

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
extension KathaEBookVC : UITableViewDelegate, UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return arrKathaEBook.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
      let cellIdentifier = "KathaEBookTableViewCell"
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? KathaEBookTableViewCell  else {
        fatalError("The dequeued cell is not an instance of MealTableViewCell.")
      }

    let data = arrKathaEBook[indexPath.row]

    cell.lblTitle.text = data["title"].stringValue
    cell.lblDescription1.text = data["android_english"].stringValue
    cell.lblDescription2.text = data["android_hindi"].stringValue
    cell.lblDescription3.text = data["android_gujarati"].stringValue

    cell.btnEnglish.tag = indexPath.row
    cell.btnHindi.tag = indexPath.row
    cell.btnGujarati.tag = indexPath.row
    
    cell.btnEnglish.addTarget(self, action: #selector(btnEnglishEbookDetails), for: UIControl.Event.touchUpInside)
    cell.btnHindi.addTarget(self, action: #selector(btnHindiEbookDetails), for: UIControl.Event.touchUpInside)
    cell.btnGujarati.addTarget(self, action: #selector(btnGujaratiEbookDetails), for: UIControl.Event.touchUpInside)

    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
//    let data = arrKathaEBook[indexPath.row]
//
//    if let url = data["android_gujarati"].url {
//      UIApplication.shared.open(url, options: [:])
//    }
    
  }
  
  @IBAction func btnEnglishEbookDetails(_ sender: UIButton) {

    let data = arrKathaEBook[sender.tag]

    if data["is_read"].intValue == 0{

      let param = ["app_id":Utility.getDeviceID(),
                   "katha_ebook_id":data["id"].stringValue] as NSDictionary
      
        Utility.readUnread(api_Url: WebService_Katha_E_Book_Read_Unread, parameters: param)
    }
      
    let urlStr = "\(BASE_URL_IMAGE)\(data["android_gujarati"].stringValue)"
    
    if #available(iOS 10.0, *) {
      UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
      
    } else {
      UIApplication.shared.openURL(URL(string: urlStr)!)
    }
    

  }
  
  @IBAction func btnGujaratiEbookDetails(_ sender: UIButton) {
    
    let data = arrKathaEBook[sender.tag]
   
    if data["is_read"].intValue == 0{
      
      let param = ["app_id":Utility.getDeviceID(),
                   "katha_ebook_id":data["id"].stringValue] as NSDictionary
      Utility.readUnread(api_Url: WebService_Katha_E_Book_Read_Unread, parameters: param)
    }
    
    let urlStr = "\(BASE_URL_IMAGE)\(data["android_gujarati"].stringValue)"
    
    if #available(iOS 10.0, *) {
      UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
      
    } else {
      UIApplication.shared.openURL(URL(string: urlStr)!)
    }
  
  }
  
  @IBAction func btnHindiEbookDetails(_ sender: UIButton) {
    
    let data = arrKathaEBook[sender.tag]
    
    if data["is_read"].intValue == 0{
      
      let param = ["app_id":Utility.getDeviceID(),
                   "katha_ebook_id":data["id"].stringValue] as NSDictionary
      
      Utility.readUnread(api_Url: WebService_Katha_E_Book_Read_Unread, parameters: param)
    }
    
    let urlStr = "\(BASE_URL_IMAGE)\(data["android_hindi"].stringValue)"
    
    if #available(iOS 10.0, *) {
      UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
      
    } else {
      UIApplication.shared.openURL(URL(string: urlStr)!)
    }
    
  }

}

//MARK:- Menu Navigation Delegate
extension KathaEBookVC: MenuNavigationDelegate{
  
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
