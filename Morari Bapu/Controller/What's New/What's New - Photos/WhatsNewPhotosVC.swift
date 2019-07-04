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

enum PhotosScreenIdentify {
  case Whats_New_Photos
  case Media_Photos
}

class WhatsNewPhotosVC: UIViewController {
  
  var arrPhotos : [JSON] = []
  var arrFavourite = NSMutableArray()

  @IBOutlet weak var lblTitle: UILabel!

  @IBOutlet weak var cvPhotos: UICollectionView!
  
  var screenDirection = PhotosScreenIdentify.Whats_New_Photos

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    if screenDirection == .Whats_New_Photos{
      //Whats_New_Photos
      
      lblTitle.text = "Photo"
      DispatchQueue.main.async {
        self.getKathaEBook()
      }
    }else{
      //Media_Photos
      
      lblTitle.text = "Bapu's Photo"
      DispatchQueue.main.async {
        self.getKathaEBook()
      }
    }
    
    
    // Add reachability observer
    if let reachability = AppDelegate.sharedAppDelegate()?.reachability
    {
      NotificationCenter.default.addObserver( self, selector: #selector( self.reachabilityChanged ),name: Notification.Name.reachabilityChanged, object: reachability )
    }
    
  }
  
  //MARK:- Api Call
  func getKathaEBook(){
  
    var api_Url = String()
    var param = NSDictionary()
    
    if screenDirection == .Whats_New_Photos{
      //Whats_New_Photos
      
      param = ["id" : "1",
                   "app_id":Utility.getDeviceID(),
                   "favourite_for":"11"] as NSDictionary
      
      api_Url = WebService_Whats_New_Photos
      
    }else{
      //Media_Photos
      
          param = ["id" : "1",
                   "app_id":Utility.getDeviceID(),
                   "favourite_for":"12"] as NSDictionary
      
      api_Url = WebService_Media_Photos

    }
    
    WebServices().CallGlobalAPI(url: api_Url,headers: [:], parameters: param, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
      
      if(jsonResponce?.error != nil) {
        
        var errorMess = jsonResponce?.error?.localizedDescription
        errorMess = MESSAGE_Err_Service
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
      }
      else {
        
        if jsonResponce!["status"].stringValue == "true"{
          
          self.arrPhotos = jsonResponce!["data"].arrayValue
          
          for favourite in jsonResponce!["MyFavourite"].arrayValue{
              self.arrFavourite.add(favourite.stringValue)
          }

          if self.arrPhotos.count != 0{
            
            DispatchQueue.main.async {
              self.cvPhotos .reloadData()
            }
          }
          else
          {
            
            DispatchQueue.main.async {
              self.cvPhotos .reloadData()
              
            }
          }
        }else if jsonResponce!["status"].stringValue == "false"{
          
          if jsonResponce!["message"].stringValue == "No Data Found"{
            
            DispatchQueue.main.async {
              self.cvPhotos.reloadData()
              Utility.collectionViewNoDataMessage(collectionView: self.cvPhotos, message: "Coming Soon", textColor: UIColor.white)
              
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

// MARK: CollectionView Delegate
extension WhatsNewPhotosVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return arrPhotos.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WhatsNewPhotosCollectionViewCell", for: indexPath) as! WhatsNewPhotosCollectionViewCell
    
    
    var dict = arrPhotos[indexPath.row]
    
    let placeHolder = UIImage(named: "chat_placeholder")
    cell.imgPhotos.kf.indicatorType = .activity
    cell.imgPhotos.kf.setImage(with: URL(string: "\(BASE_URL_IMAGE)\(dict["image_file"].stringValue)"), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
    
    cell.imgPhotos.layer.masksToBounds = true
    cell.imgPhotos.layer.cornerRadius = 3
    
    //Notification readable or not
    if dict["is_read"].boolValue == false{
      //Non-Readable notification
      cell.viewBackground.backgroundColor = UIColor.colorFromHex("#d3d3d3")
      
    }else{
      //Readable notification
      cell.viewBackground.backgroundColor = UIColor.colorFromHex("#ffffff")
    }
    
    
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    if UIDevice.current.userInterfaceIdiom == .pad{
      return CGSize(width: ((collectionView.frame.size.width) - 24) / 3, height: ((collectionView.frame.size.width) - 24) / 3)

    }
    else if UIDevice.current.userInterfaceIdiom == .phone{
      return CGSize(width: ((collectionView.frame.size.width) - 24) / 3, height: ((collectionView.frame.size.width) - 24) / 3)
    }
    else
    {
      return CGSize(width: ((collectionView.frame.size.width) - 24) / 3, height: ((collectionView.frame.size.width) - 24) / 3)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    var data = arrPhotos[indexPath.row]

    
    if screenDirection == .Media_Photos{
      
      if data["is_read"].intValue == 0{
        
        data["is_read"] = true;
        
        arrPhotos[indexPath.row] = data
        
        let indexPath = NSIndexPath(row: indexPath.row, section: 0)
        
        var indexPaths = [IndexPath]()
        indexPaths.append(indexPath as IndexPath)
        
        if cvPhotos != nil {
          cvPhotos.reloadItems(at: indexPaths)
        }
        
        let param = ["app_id":Utility.getDeviceID(),
                     "bapudarshan_id":data["id"].stringValue] as NSDictionary
        
        Utility.readUnread(api_Url: WebService_Bapu_Photos_Read_Unread, parameters: param)
      }
      
    }else if screenDirection == .Whats_New_Photos{
      
      if data["is_read"].intValue == 0{
        
        data["is_read"] = true;
        
        arrPhotos[indexPath.row] = data
        
        let indexPath = NSIndexPath(row: indexPath.row, section: 0)
        
        var indexPaths = [IndexPath]()
        indexPaths.append(indexPath as IndexPath)
        
        if cvPhotos != nil {
          cvPhotos.reloadItems(at: indexPaths)
        }
        
        let param = ["app_id":Utility.getDeviceID(),
                     "image_id":data["id"].stringValue] as NSDictionary
        
        Utility.readUnread(api_Url: WebService_Image_Whats_New_Read_Unread, parameters: param)
      }
      
    }
    
    if screenDirection == .Whats_New_Photos{
      //Whats_New_Photos
      
      Utility.image_Viewer_Show(onViewController: self, screenDirection: .Whats_New_Photos, indexPosition: indexPath, arrFavourites: arrFavourite, images: arrPhotos)
      
    }else{
      //Media_Photos
      
      Utility.image_Viewer_Show(onViewController: self, screenDirection: .Media_Photos, indexPosition: indexPath, arrFavourites: arrFavourite, images: arrPhotos)
      
    }
    
   
    
  }
  
}




//MARK:- Menu Navigation Delegate
extension WhatsNewPhotosVC: MenuNavigationDelegate{
  
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


extension WhatsNewPhotosVC : ImageViewerDelegate{
 
  
  func result(_ favouritesList: NSMutableArray) {
    arrFavourite.removeAllObjects()
    arrFavourite = favouritesList
  }
  
}

extension WhatsNewPhotosVC : InternetConnectionDelegate{
  
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
        
        if(vc is WhatsNewPhotosVC){
          Utility.internet_connection_Show(onViewController: self)
        }
      }
      
    }
    
  }
  
  func reloadPage() {
    
    DispatchQueue.main.async {
      self.getKathaEBook()
    }
    
  }
}
