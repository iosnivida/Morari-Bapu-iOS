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
import FolioReaderKit
import  SVProgressHUD

class KathaEBookVC: UIViewController {

  var arrKathaEBook  = [JSON]()
  var selectedBook  = [String:JSON]()

  @IBOutlet weak var tblKathaEBook: UITableView!
  @IBOutlet weak var viewBookType: UIView!

  override func viewDidLoad() {
        super.viewDidLoad()

    viewBookType.isHidden = true
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
          
        }else if jsonResponce!["status"].stringValue == "false"{
          
          if jsonResponce!["message"].stringValue == "No Data Found"{
            
            DispatchQueue.main.async {
              self.tblKathaEBook.reloadData()
              Utility.tableNoDataMessage(tableView: self.tblKathaEBook, message: "Coming Soon", messageColor: UIColor.white, displayMessage: .Center)
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
  
  
  @IBAction func dismissView(_ sender: Any) {
    viewBookType.isHidden = true

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
    cell.lblDate.text = data["date"].stringValue
    
    cell.btnViewEBook.tag = indexPath.row
    cell.btnViewEBook.addTarget(self, action: #selector(btnViewEbook), for: UIControl.Event.touchUpInside)
    
    cell.btnShare.tag = indexPath.row
    cell.btnShare.addTarget(self, action: #selector(btnShare(_:)), for: UIControl.Event.touchUpInside)

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
    

    
    
  }
  
  @IBAction func btnViewEbook(_ sender: UIButton) {
    
    viewBookType.isHidden = false
    self.view.bringSubviewToFront(viewBookType)
    
    selectedBook = arrKathaEBook[sender.tag].dictionaryValue
    
    var dict = arrKathaEBook[sender.tag]

    if selectedBook["is_read"]!.intValue == 0{
      
      dict["is_read"] = true;
      
      arrKathaEBook[sender.tag] = dict
      
      let indexPath = NSIndexPath(row: sender.tag, section: 0)
      tblKathaEBook.reloadRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.none)
      
      let param = ["app_id":Utility.getDeviceID(),
                   "katha_ebook_id":selectedBook["id"]!.stringValue] as NSDictionary
      
      Utility.readUnread(api_Url: WebService_Katha_E_Book_Read_Unread, parameters: param)
    }
    
    
    
  }
  
  @IBAction func btnEnglishEbookDetails(_ sender: UIButton) {

    viewBookType.isHidden = true
    let config = FolioReaderConfig()
    config.scrollDirection = .horizontalWithVerticalContent
    config.tintColor = color_Maroon
    let folioReader = FolioReader()

    
    let urlStr = "\(BASE_URL_IMAGE)\(selectedBook["android_english"]!.stringValue)"
    let filename = (urlStr as NSString).lastPathComponent

    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let filePath = documentsURL.appendingPathComponent(filename)

    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: filePath.path) {
      print("FILE AVAILABLE")
      
      let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
      let filePath = "\(documentsPath)/\(filename)"
      print(filePath)
      folioReader.presentReader(parentViewController: self, withEpubPath: filePath, andConfig: config)
      
    } else {
      print("FILE NOT AVAILABLE")
      
      SVProgressHUD.show()
      
      Alamofire.request(urlStr).downloadProgress(closure : { (progress) in
        
        print(progress.fractionCompleted)
        
        
        
      }).responseData{ (response) in
        print(response)
        print(response.result.value!)
        print(response.result.description)
        if let data = response.result.value {
          
          do {
            try data.write(to: filePath)

            DispatchQueue.main.async {
              SVProgressHUD.dismiss()
              
              let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
              let filePath = "\(documentsPath)/\(filename)"
              print(filePath)
              folioReader.presentReader(parentViewController: self, withEpubPath: filePath, andConfig: config)
            }
          
            
          } catch {
            print("Something went wrong!")
          }
          
        }
      }
      
    }

  }
  
  @IBAction func btnGujaratiEbookDetails(_ sender: UIButton) {
    
    viewBookType.isHidden = true
    let config = FolioReaderConfig()
    config.scrollDirection = .horizontalWithVerticalContent
    config.tintColor = color_Maroon
    let folioReader = FolioReader()
    
    
    let urlStr = "\(BASE_URL_IMAGE)\(selectedBook["android_gujarati"]!.stringValue)"
    let filename = (urlStr as NSString).lastPathComponent
    
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let filePath = documentsURL.appendingPathComponent(filename)
    
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: filePath.path) {
      print("FILE AVAILABLE")
      
      let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
      let filePath = "\(documentsPath)/\(filename)"
      print(filePath)
      folioReader.presentReader(parentViewController: self, withEpubPath: filePath, andConfig: config)
      
    } else {
      print("FILE NOT AVAILABLE")
      
      SVProgressHUD.show()
      
      Alamofire.request(urlStr).downloadProgress(closure : { (progress) in
        
        print(progress.fractionCompleted)
        
        
        
      }).responseData{ (response) in
        print(response)
        print(response.result.value!)
        print(response.result.description)
        if let data = response.result.value {
          
          do {
            try data.write(to: filePath)
            
            DispatchQueue.main.async {
              SVProgressHUD.dismiss()
              
              let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
              let filePath = "\(documentsPath)/\(filename)"
              print(filePath)
              folioReader.presentReader(parentViewController: self, withEpubPath: filePath, andConfig: config)
            }
            
          } catch {
            print("Something went wrong!")
          }
          
        }
      }
      
    }
    
  }
  
  @IBAction func btnHindiEbookDetails(_ sender: UIButton) {
    
    viewBookType.isHidden = true
    let config = FolioReaderConfig()
    config.scrollDirection = .horizontalWithVerticalContent
    config.tintColor = color_Maroon
    let folioReader = FolioReader()
    
    
    let urlStr = "\(BASE_URL_IMAGE)\(selectedBook["android_hindi"]!.stringValue)"
    let filename = (urlStr as NSString).lastPathComponent
    
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let filePath = documentsURL.appendingPathComponent(filename)
    
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: filePath.path) {
      print("FILE AVAILABLE")
      
      let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
      let filePath = "\(documentsPath)/\(filename)"
      print(filePath)
      folioReader.presentReader(parentViewController: self, withEpubPath: filePath, andConfig: config)
      
    } else {
      print("FILE NOT AVAILABLE")
      
      SVProgressHUD.show()
      
      Alamofire.request(urlStr).downloadProgress(closure : { (progress) in
        
        print(progress.fractionCompleted)
        
        
        
      }).responseData{ (response) in
        print(response)
        print(response.result.value!)
        print(response.result.description)
        if let data = response.result.value {
          
          do {
            try data.write(to: filePath)
            
            DispatchQueue.main.async {
              SVProgressHUD.dismiss()
              
              let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
              let filePath = "\(documentsPath)/\(filename)"
              print(filePath)
              folioReader.presentReader(parentViewController: self, withEpubPath: filePath, andConfig: config)
            }
            
          } catch {
            print("Something went wrong!")
          }
          
        }
      }
      
    }
    
  }
  
  @IBAction func btnShare(_ sender: UIButton) {
    
    let data = arrKathaEBook[sender.tag]
    
    let urleng = "\(BASE_URL_IMAGE)\(data["android_english"].stringValue)"
    let urlhindi = "\(BASE_URL_IMAGE)\(data["android_hindi"].stringValue)"
    let urlguj = "\(BASE_URL_IMAGE)\(data["android_gujarati"].stringValue)"
    
    let share_Content = "Katha E-Book \n\n\(data["title"].stringValue) \n\nDate: \(data["date"].stringValue) \n\n \(urleng) \n\n\(urlhindi) \n\n\(urlguj) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
  
    let textToShare = [share_Content]
    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
    
    // exclude some activity types from the list (optional)
    activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
    
    DispatchQueue.main.async {
      self.present(activityViewController, animated: true, completion: nil)
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
