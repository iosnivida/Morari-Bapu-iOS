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
import Kingfisher


class FavouriteVC: UIViewController {
  
  @IBOutlet weak var tblFavourites: UITableView!
  @IBOutlet weak var lblTitle: UILabel!
  
  var currentPageNo = Int()
  var totalPageNo = Int()
  var is_Api_Being_Called : Bool = false
  
  var arrFavourites : [JSON] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    currentPageNo = 1
    
    tblFavourites.tableFooterView =  UIView.init(frame: .zero)
    tblFavourites.layoutMargins = .zero
    
    tblFavourites.rowHeight = 150
    tblFavourites.estimatedRowHeight = UITableView.automaticDimension
    
    lblTitle.text = "Favourites"
    
    self.arrFavourites.removeAll()
    self.getFavouritesList(pageNo: 1)

    // Add reachability observer
    if let reachability = AppDelegate.sharedAppDelegate()?.reachability
    {
      NotificationCenter.default.addObserver( self, selector: #selector( self.reachabilityChanged ),name: Notification.Name.reachabilityChanged, object: reachability )
    }
    
    
  }
  
  //MARK:- Api Call
  func getFavouritesList(pageNo:Int){
    
    let param = ["page" : pageNo,
                 "app_id":Utility.getDeviceID()] as NSDictionary
    
    WebServices().CallGlobalAPI(url: WebService_Favourite_List,headers: [:], parameters: param, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
      
      if(jsonResponce?.error != nil) {
        
        var errorMess = jsonResponce?.error?.localizedDescription
        errorMess = MESSAGE_Err_Service
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
      }
      else {
        
        if jsonResponce!["status"].stringValue == "true"{
          
          self.is_Api_Being_Called = false
          
          for result in jsonResponce!["data"].arrayValue {
            self.arrFavourites.append(result)
          }
          
          self.totalPageNo = jsonResponce!["total_page"].intValue
          
          if self.arrFavourites.count != 0{
  
              Utility.tableNoDataMessage(tableView: self.tblFavourites, message: "",messageColor:UIColor.white, displayMessage: .Center)
              
              self.tblFavourites .reloadData()
            
          }
          else
          {
            
              self.tblFavourites.reloadData()
              Utility.tableNoDataMessage(tableView: self.tblFavourites, message: "No Favourites",messageColor:UIColor.white, displayMessage: .Center)

          }
          
        }
        else if jsonResponce!["status"].stringValue == "false"{
            if jsonResponce!["message"].stringValue == "No Data Found"{
                self.arrFavourites.removeAll()
                self.tblFavourites.reloadData()
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
extension FavouriteVC : UITableViewDelegate, UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrFavourites.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let data = arrFavourites[indexPath.row]
    
    if data["list_heading"].stringValue == "Quotes"{
      //Quotes
      
      let cellIdentifier = "KathaChopaiTableViewCell"
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? KathaChopaiTableViewCell  else {
        fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        
      }
      
      cell.lblTitle.text = data["title"].stringValue
      cell.lblDate.text = Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd MMM yyyy")
      cell.lblDescription1.text = data["quotes_gujarati"].stringValue
      cell.btnTitle.setTitle(data["list_heading"].stringValue, for: .normal)
      
      cell.btnFavourite.tag = indexPath.row
      cell.btnShare.tag = indexPath.row
      cell.btnTitle.tag = indexPath.row
      
      cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
      
      cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
      cell.btnFavourite.addTarget(self, action: #selector(btnFavourite(_:)), for: UIControl.Event.touchUpInside)
      cell.btnTitle.addTarget(self, action: #selector(btnToSpecificScreen(_:)), for: UIControl.Event.touchUpInside)
      
      return cell
      
    }
    else if data["list_heading"].stringValue == "Katha Chopai"{
      //Katha Chopai
      
      let cellIdentifier = "KathaChopaiTableViewCell"
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? KathaChopaiTableViewCell  else {
        fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        
      }
      
      cell.lblTitle.text = "\(data["title"].stringValue)"
      cell.lblDate.text = Utility.dateToString(dateStr: data["from_date"].stringValue, strDateFormat: "dd MMM yyyy")
      cell.lblDescription1.text = data["quotes_hindi"].stringValue
      cell.btnTitle.setTitle(data["list_heading"].stringValue, for: .normal)
      cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
      
      cell.btnFavourite.tag = indexPath.row
      cell.btnShare.tag = indexPath.row
      cell.btnTitle.tag = indexPath.row
      
      cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
      cell.btnFavourite.addTarget(self, action: #selector(btnFavourite(_:)), for: UIControl.Event.touchUpInside)
      cell.btnTitle.addTarget(self, action: #selector(btnToSpecificScreen(_:)), for: UIControl.Event.touchUpInside)
      cell.btnTitle.addTarget(self, action: #selector(btnToSpecificScreen(_:)), for: UIControl.Event.touchUpInside)
      
      
      return cell
      
      
    }
    else if data["list_heading"].stringValue == "Ram Charit Manas"{
      //Ram charit manas
      
      let cellIdentifier = "KathaChopaiTableViewCell"
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? KathaChopaiTableViewCell  else {
        fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        
      }
      
      cell.lblTitle.text = "\(data["title"].stringValue)"
      cell.lblDate.text = Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd MMM yyyy")
      cell.lblDescription1.text = data["description"].stringValue
      cell.btnTitle.setTitle(data["list_heading"].stringValue, for: .normal)
      cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
      
      cell.btnFavourite.tag = indexPath.row
      cell.btnShare.tag = indexPath.row
      cell.btnTitle.tag = indexPath.row
      
      cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
      cell.btnFavourite.addTarget(self, action: #selector(btnFavourite(_:)), for: UIControl.Event.touchUpInside)
      cell.btnTitle.addTarget(self, action: #selector(btnToSpecificScreen(_:)), for: UIControl.Event.touchUpInside)
      cell.btnTitle.addTarget(self, action: #selector(btnToSpecificScreen(_:)), for: UIControl.Event.touchUpInside)
      
      
      return cell
      
    }
    else if data["list_heading"].stringValue == "Daily Katha Video"{
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
      
      let url = URL(string: "https://img.youtube.com/vi/\(Utility.extractYouTubeId(from: data["youtube_link"].stringValue) ?? "")/0.jpg")
      
      cell.imgVideo.kf.indicatorType = .activity
      cell.imgVideo.kf.setImage(with: url, placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
      
      cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
      
      
      cell.btnShare.tag = indexPath.row
      cell.btnYoutube.tag = indexPath.row
      cell.btnFavourite.tag = indexPath.row
      cell.btnTitle.tag = indexPath.row
      
      cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
      cell.btnYoutube.addTarget(self, action: #selector(btnYoutube), for: UIControl.Event.touchUpInside)
      cell.btnFavourite.addTarget(self, action: #selector(btnFavourite), for: UIControl.Event.touchUpInside)
      cell.btnTitle.addTarget(self, action: #selector(btnToSpecificScreen(_:)), for: UIControl.Event.touchUpInside)
      
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
      
      cell.btnShare.tag  = indexPath.row
      cell.btnTitle.tag = indexPath.row
      
      cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
      
      cell.btnFavourite.tag  = indexPath.row
      cell.btnFavourite.addTarget(self, action: #selector(btnFavourite), for: UIControl.Event.touchUpInside)
      
      cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
      cell.btnTitle.addTarget(self, action: #selector(btnToSpecificScreen(_:)), for: UIControl.Event.touchUpInside)
      
      
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
      //cell.lblDuration.numberOfLines = 4
      cell.btnTitle.setTitle("Shayari", for: .normal)
      
      cell.btnShare.tag  = indexPath.row
      cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
      
      cell.btnFavourite.tag  = indexPath.row
      cell.btnFavourite.addTarget(self, action: #selector(btnFavourite), for: UIControl.Event.touchUpInside)
      
      cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
      cell.viewMusicIndicator.isHidden = true
      
      cell.btnTitle.tag = indexPath.row
      
      cell.btnTitle.addTarget(self, action: #selector(btnToSpecificScreen(_:)), for: UIControl.Event.touchUpInside)
      
      
      return cell
      
    }
    else if data["list_heading"].stringValue == "NewText"{
      //Text
      
      let cellIdentifier = "KathaChopaiTableViewCell"
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? KathaChopaiTableViewCell  else {
        fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        
      }
      
      cell.lblTitle.text = "\(data["title"].stringValue)"
      cell.lblDate.text = data["date"].stringValue
      cell.lblDescription1.text = data["description"].stringValue
      cell.btnTitle.setTitle("What's New(Text)", for: .normal)
      cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
      
      cell.btnFavourite.tag = indexPath.row
      cell.btnShare.tag = indexPath.row
      cell.btnTitle.tag = indexPath.row
      
      cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
      cell.btnFavourite.addTarget(self, action: #selector(btnFavourite(_:)), for: UIControl.Event.touchUpInside)
      cell.btnTitle.addTarget(self, action: #selector(btnToSpecificScreen(_:)), for: UIControl.Event.touchUpInside)
      cell.btnTitle.addTarget(self, action: #selector(btnToSpecificScreen(_:)), for: UIControl.Event.touchUpInside)
      
      
      return cell
      
    }else if data["list_heading"].stringValue == "BapuThought"{
      //Thought
      
      let cellIdentifier = "KathaChopaiTableViewCell"
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? KathaChopaiTableViewCell  else {
        fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        
      }
      
      cell.lblTitle.text = "\(data["title"].stringValue)"
      cell.lblDate.text = data["date"].stringValue
      cell.lblDescription1.text = data["description"].stringValue
      cell.btnTitle.setTitle("Thought", for: .normal)
      cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
      
      cell.btnFavourite.tag = indexPath.row
      cell.btnShare.tag = indexPath.row
      cell.btnTitle.tag = indexPath.row
      
      cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
      cell.btnFavourite.addTarget(self, action: #selector(btnFavourite(_:)), for: UIControl.Event.touchUpInside)
      cell.btnTitle.addTarget(self, action: #selector(btnToSpecificScreen(_:)), for: UIControl.Event.touchUpInside)
      cell.btnTitle.addTarget(self, action: #selector(btnToSpecificScreen(_:)), for: UIControl.Event.touchUpInside)
      
      
      return cell
      
    }else if data["list_heading"].stringValue == "NewImage"{
      //Thought
      
      let cellIdentifier = "BapuDarshanUITableViewCell"
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BapuDarshanUITableViewCell  else {
        fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        
      }
      
      
      let placeHolder = UIImage(named: "youtube_placeholder")
      cell.imgBapuDarshan.kf.indicatorType = .activity
      cell.imgBapuDarshan.kf.setImage(with: URL(string: "\(BASE_URL_IMAGE)\(data["image_file"].stringValue)"), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
      
      cell.btnTitle.setTitle("Bapu's Photo", for: .normal)
      cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
      
      cell.btnFavourite.tag = indexPath.row
      cell.btnShare.tag = indexPath.row
      cell.btnTitle.tag = indexPath.row
      
      cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
      cell.btnFavourite.addTarget(self, action: #selector(btnFavourite(_:)), for: UIControl.Event.touchUpInside)
      cell.btnTitle.addTarget(self, action: #selector(btnToSpecificScreen(_:)), for: UIControl.Event.touchUpInside)
      
      
      return cell
      
    }else if data["list_heading"].stringValue == "BapuDarshan"{
      //Thought
      
      let cellIdentifier = "BapuDarshanUITableViewCell"
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BapuDarshanUITableViewCell  else {
        fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        
      }
      
      let placeHolder = UIImage(named: "youtube_placeholder")
      cell.imgBapuDarshan.kf.indicatorType = .activity
      cell.imgBapuDarshan.kf.setImage(with: URL(string: "\(BASE_URL_IMAGE)\(data["image_file"].stringValue)"), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
      
      cell.btnTitle.setTitle("What's New(Photo)", for: .normal)
      cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
      
      cell.btnFavourite.tag = indexPath.row
      cell.btnShare.tag = indexPath.row
      cell.btnTitle.tag = indexPath.row
      
      cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
      cell.btnFavourite.addTarget(self, action: #selector(btnFavourite(_:)), for: UIControl.Event.touchUpInside)
      cell.btnTitle.addTarget(self, action: #selector(btnToSpecificScreen(_:)), for: UIControl.Event.touchUpInside)
      
      
      return cell
      
    }
    else if data["list_heading"].stringValue == "Article"{
      //Articles
      
      if data["image"].stringValue == "" && data["video"].stringValue == ""{
        
        let cellIdentifier = "Articles1TableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? Articles1TableViewCell  else {
          fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
      
        cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
   
        cell.lblTitle.text = data["description"].stringValue
        cell.lblLink.text = data["html_link"].stringValue
        cell.lblLink.useUnderlineLabel(line_Color: UIColor.black)
        cell.lblDate.text = Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd-MMM-yyyy")
        
        cell.btnShare.tag = indexPath.row
        cell.btnYoutube.tag = indexPath.row
        cell.btnFavourite.tag = indexPath.row
        
        cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
        cell.btnYoutube.addTarget(self, action: #selector(btnLinkWebSite), for: UIControl.Event.touchUpInside)
        cell.btnFavourite.addTarget(self, action: #selector(btnFavourite), for: UIControl.Event.touchUpInside)
        return cell
        
        
        
      }else {
        
        
        let cellIdentifier = "Articles2TableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? Articles2TableViewCell  else {
          fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        cell.lblTitle.text = data["description"].stringValue
        cell.lblLink.text = data["html_link"].stringValue
        cell.lblLink.useUnderlineLabel(line_Color: UIColor.black)
        cell.lblDate.text = Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd-MMM-yyyy")
        
        let placeHolder = UIImage(named: "youtube_placeholder")
        
        cell.imgVideo.kf.indicatorType = .activity
        cell.imgVideo.kf.setImage(with: URL(string: "\(BASE_URL_IMAGE)\(data["image"].stringValue)"), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
        
  
        cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
        
        cell.btnShare.tag = indexPath.row
        cell.btnYoutube.tag = indexPath.row
        cell.btnLink.tag = indexPath.row
        cell.btnFavourite.tag = indexPath.row
        
        cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
        cell.btnYoutube.addTarget(self, action: #selector(btnYoutube), for: UIControl.Event.touchUpInside)
        cell.btnLink.addTarget(self, action: #selector(btnLinkWebSite), for: UIControl.Event.touchUpInside)
        cell.btnFavourite.addTarget(self, action: #selector(btnFavourite), for: UIControl.Event.touchUpInside)
        
        return cell
        
      }
      
    }else{
      return UITableViewCell()
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    /*
    let data = arrFavourites[indexPath.row]

    if data["list_heading"].stringValue == "Article"{
        return 0
    }else{
        return UITableView.automaticDimension
    }*/
    
    return UITableView.automaticDimension
    
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    
    let data = arrFavourites[indexPath.row]

    if data["list_heading"].stringValue == "Article"{
      return 0
    }else{
      return UITableView.automaticDimension
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    if indexPath.row == arrFavourites.count - 1{
      if is_Api_Being_Called == false{
        if currentPageNo <  totalPageNo{
          print("Page Load....")
          is_Api_Being_Called = true
          currentPageNo += 1
          self.getFavouritesList(pageNo: currentPageNo)
        }
      }
    }
  }
  
  @IBAction func btnFavourite(_ sender: UIButton) {
    
    if arrFavourites.count != 0{
      
      let data = arrFavourites[sender.tag]
      
      var paramater = NSDictionary()
      
      if data["list_heading"].stringValue == "Quotes"{
        //Quotes
        
        paramater = ["app_id":Utility.getDeviceID(),
                     "favourite_for":data["favourite_for"].stringValue,
                     "favourite_id":data["quote_id"].stringValue]
        
      }
      else if data["list_heading"].stringValue == "Katha Chopai"{
        //Katha Chopai
        
        paramater = ["app_id":Utility.getDeviceID(),
                     "favourite_for":data["favourite_for"].stringValue,
                     "favourite_id":data["katha_chopai_id"].stringValue]
        
      }
      else if data["list_heading"].stringValue == "Ram Charit Manas"{
        //Ram charit manas
        
        paramater = ["app_id":Utility.getDeviceID(),
                     "favourite_for":data["favourite_for"].stringValue,
                     "favourite_id":data["ram_charit_manas_id"].stringValue]
        
      }
      else if data["list_heading"].stringValue == "Stuti"{
        
        paramater = ["app_id":Utility.getDeviceID(),
                     "favourite_for":data["favourite_for"].stringValue,
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
        
      }else if data["list_heading"].stringValue == "Daily Katha Video"{
        
        paramater = ["app_id":Utility.getDeviceID(),
                     "favourite_for":data["favourite_for"].stringValue,
                     "favourite_id":data["daily_katha_id"].stringValue]
        
      }else if data["list_heading"].stringValue == "Article"{
        
        paramater = ["app_id":Utility.getDeviceID(),
                     "favourite_for":data["favourite_for"].stringValue,
                     "favourite_id":data["article_id"].stringValue]
        
      }else if data["list_heading"].stringValue == "NewText"{
        
        paramater = ["app_id":Utility.getDeviceID(),
                     "favourite_for":data["favourite_for"].stringValue,
                     "favourite_id":data["new_text_id"].stringValue]
      }else if data["list_heading"].stringValue == "BapuThought"{
        
        paramater = ["app_id":Utility.getDeviceID(),
                     "favourite_for":data["favourite_for"].stringValue,
                     "favourite_id":data["bapu_thought_id"].stringValue]
        
      }else if data["list_heading"].stringValue == "NewImage"{
        
        paramater = ["app_id":Utility.getDeviceID(),
                     "favourite_for":data["favourite_for"].stringValue,
                     "favourite_id":data["new_image_id"].stringValue]
        
      }else if data["list_heading"].stringValue == "BapuDarshan"{
        
        paramater = ["app_id":Utility.getDeviceID(),
                     "favourite_for":data["favourite_for"].stringValue,
                     "favourite_id":data["bapu_darshan_id"].stringValue]
        
      }
      
      
      WebServices().CallGlobalAPI(url: WebService_Favourite,headers: [:], parameters: paramater, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
        
        if(jsonResponce?.error != nil) {
          
          var errorMess = jsonResponce?.error?.localizedDescription
          errorMess = MESSAGE_Err_Service
          Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
        }
        else {
          
          if jsonResponce!["status"].stringValue == "true"{
            
            self.arrFavourites.removeAll()
            self.getFavouritesList(pageNo: 1)
            
            
          }
          else if jsonResponce!["status"].stringValue == "false"{
            
            if jsonResponce!["message"].stringValue == "No Data Found"{
              self.arrFavourites.removeAll()
              self.getFavouritesList(pageNo: 1)
              
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
    
    let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblFavourites)
    let indexPath = self.tblFavourites.indexPathForRow(at: buttonPosition)
    
    var share_Content = String()
    
    let data = arrFavourites[indexPath!.row]
    
    if data["list_heading"].stringValue == "Quotes"{
      //Quotes
      
      share_Content = "Quotes \n\n\(data["title"].stringValue) \n\nDate: \(Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd MMM yyyy")) \n\n \(data["quotes_gujarati"].stringValue) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
      
      
    }
    else if data["list_heading"].stringValue == "Katha Chopai"{
      //Katha Chopai
      
      share_Content = "Katha Chopai \n\n\(data["title"].stringValue) \n\nDate: \(Utility.dateToString(dateStr: data["from_date"].stringValue, strDateFormat: "dd MMM yyyy")) \n\n \(data["quotes_hindi"].stringValue) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
      
      
      
    }
    else if data["list_heading"].stringValue == "Ram Charit Manas"{
      //Ram charit manas
      share_Content = "Ram Charit Manas \n\n\(data["title"].stringValue) \n\nDate: \(Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd MMM yyyy")) \n\n \(data["description"].stringValue) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
      
      
      
    }
    else if data["list_heading"].stringValue == "Stuti"{
      
      share_Content = "Stuti \n\n\(data["title"].stringValue) \n\n(Duration: \(data["video_duration"].stringValue)) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
      
      
    }else if data["list_heading"].stringValue == "Other Stuti"{
      
      share_Content = "Other Stuti \n\n\(data["title"].stringValue) \n\n(Duration: \(data["video_duration"].stringValue)) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
      
      
    }else if data["list_heading"].stringValue == "Sankirtan"{
      
      share_Content = "Sankirtan \n\n\(data["title"].stringValue) \n\n(Duration: \(data["video_duration"].stringValue)) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
      
      
    }
    else if data["list_heading"].stringValue == "Bapufavouriteshayari"{
      
      share_Content = "Shayari \n\n \(data["quotes_gujarati"].stringValue) \n\n\(data["quotes_english"].stringValue) \n\n\(data["quotes_hindi"].stringValue)  \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
      
      
    }else if data["list_heading"].stringValue == "Daily Katha Video"{
      
      share_Content = "Daily Katha Video \n\n\(data["title"].stringValue) \n(Duration: \(data["video_duration"].stringValue)) \n \(Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd-MM-yyyy")) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
      
      
    }else if data["list_heading"].stringValue == "Article"{
      
      share_Content = "Article \n\n\(data["description"].stringValue) \n\nThis message has been sent via the Morari Bapu App. You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"

      
    }else if data["list_heading"].stringValue == "NewText"{
      
      share_Content = "Text \n\n\(data["title"].stringValue) \n\nDate: \(data["date"].stringValue) \n\n\(data["description"].stringValue)  \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
      
    }else if data["list_heading"].stringValue == "BapuThought"{
      
      share_Content = "Text \n\n\(data["title"].stringValue) \n\nDate: \(data["date"].stringValue) \n\n\(data["description"].stringValue)  \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
      
    }else if data["list_heading"].stringValue == "BapuDarshan"{
      
      share_Content = "Text \n\n\(data["title"].stringValue) \n\nDate: \(data["date"].stringValue) \n\n\(data["description"].stringValue)  \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
      
    }else if data["list_heading"].stringValue == "NewImage"{
      
      let imageUrl = URL(string: "\(BASE_URL_IMAGE)\(data["image_file"].stringValue)")
      let text = "\n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
      
      let data = try? Data(contentsOf: imageUrl!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
      let image = UIImage(data: data!)
      let imageShare = [image as Any  ,text] as [Any]
      
      let activityViewController = UIActivityViewController(activityItems: imageShare as [Any] , applicationActivities: nil)
      activityViewController.popoverPresentationController?.sourceView = self.view
      
      DispatchQueue.main.async {
        self.present(activityViewController, animated: true, completion: nil)
      }
      
      return
      
    }else if data["list_heading"].stringValue == "BapuDarshan"{
      
      let imageUrl = URL(string: "\(BASE_URL_IMAGE)\(data["image_file"].stringValue)")
      let text = "\n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
      
      let data = try? Data(contentsOf: imageUrl!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
      let image = UIImage(data: data!)
      let imageShare = [image as Any  ,text] as [Any]
      
      let activityViewController = UIActivityViewController(activityItems: imageShare as [Any] , applicationActivities: nil)
      activityViewController.popoverPresentationController?.sourceView = self.view
      
      DispatchQueue.main.async {
        self.present(activityViewController, animated: true, completion: nil)
      }
      
      return
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
    
    let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblFavourites)
    let indexPath = self.tblFavourites.indexPathForRow(at: buttonPosition)
    
    let data = arrFavourites[indexPath!.row]
    
    var youtubeLink = String()
    
    if data["favourite_for"].intValue == 4{
      
      youtubeLink = data["youtube_link"].stringValue
      
    }else{
      youtubeLink = data["youtube_link"].stringValue
    }
    
    if Utility.canOpenURL(data["youtube_link"].stringValue){
      DispatchQueue.main.async {
        UIApplication.shared.open(URL(string: youtubeLink)!, options: [:])
      }
    }else{
      
    }
    
    
    
  }
  
  @IBAction func btnToSpecificScreen(_ sender: UIButton) {
    
    let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblFavourites)
    let indexPath = self.tblFavourites.indexPathForRow(at: buttonPosition)
    
    let data = arrFavourites[indexPath!.row]
    
    if data["list_heading"].stringValue == "Quotes"{
      //Quotes
      
      let storyboard = UIStoryboard(name: Dashboard_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiVC") as! KathaChopaiVC
      vc.screenDirection = .Quotes
      navigationController?.pushViewController(vc, animated:  true)
      
    }
    else if data["list_heading"].stringValue == "Katha Chopai"{
      //Katha Chopai
      
      let storyboard = UIStoryboard(name: Dashboard_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiVC") as! KathaChopaiVC
      vc.screenDirection = .Katha_Chopai
      navigationController?.pushViewController(vc, animated:  true)
      
    }
    else if data["list_heading"].stringValue == "Ram Charit Manas"{
      //Ram charit manas
      let storyboard = UIStoryboard(name: Dashboard_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiVC") as! KathaChopaiVC
      vc.screenDirection = .Ram_Charit_Manas
      navigationController?.pushViewController(vc, animated:  true)
      
    }
    else if data["list_heading"].stringValue == "Stuti"{
      
      let storyboard = UIStoryboard(name: Media_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "AudioVC") as! AudioVC
      vc.screenDirection = .Stuti
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if data["list_heading"].stringValue == "Other Stuti"{
      
      //Other Audio
      let storyboard = UIStoryboard(name: Media_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "AudioVC") as! AudioVC
      vc.screenDirection = .Others
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if data["list_heading"].stringValue == "Sankirtan"{
      
      //Sankirtan
      let storyboard = UIStoryboard(name: Media_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "AudioVC") as! AudioVC
      vc.screenDirection = .Sankirtan
      navigationController?.pushViewController(vc, animated:  true)
      
    }
    else if data["list_heading"].stringValue == "Bapufavouriteshayari"{
      
      //Sher O Shayri
      
      let storyboard = UIStoryboard(name: Dashboard_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "ShayriVC") as! ShayriVC
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if data["list_heading"].stringValue == "Daily Katha Video"{
      
      let storyboard = UIStoryboard(name: Media_Storyboard, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DailyKathaClipVC") as! DailyKathaClipVC
            navigationController?.pushViewController(vc, animated:  true)
      
    }else if data["list_heading"].stringValue == "NewText"{
      
      let storyboard = UIStoryboard(name: Media_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "WhatsNewTextVC") as! WhatsNewTextVC
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if data["list_heading"].stringValue == "BapuThought"{
      
      //Bapu's Thoughts
      let storyboard = UIStoryboard(name: Dashboard_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "BapuThoughtsVC") as! BapuThoughtsVC
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if data["list_heading"].stringValue == "BapuDarshan"{
      
      let storyboard = UIStoryboard(name: Media_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "WhatsNewPhotosVC") as! WhatsNewPhotosVC
      vc.screenDirection = .Media_Photos
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if data["list_heading"].stringValue == "NewImage"{
      
      //Bapu's Thoughts
      let storyboard = UIStoryboard(name: Media_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "WhatsNewPhotosVC") as! WhatsNewPhotosVC
      vc.screenDirection = .Whats_New_Photos
      navigationController?.pushViewController(vc, animated:  true)
      
    }
  }
  
  @IBAction func btnLinkWebSite(_ sender: UIButton) {
    
    let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblFavourites)
    let indexPath = self.tblFavourites.indexPathForRow(at: buttonPosition)
    
    let data = arrFavourites[indexPath!.row]

    let youtubeLink = data["html_link"].url
    
    if Utility.canOpenURL(data["html_link"].stringValue){
      DispatchQueue.main.async {
        UIApplication.shared.open(youtubeLink!, options: [:])
      }
    }else{
    }
  }
  
  
  
}

//MARK:- Menu Navigation Delegate
extension FavouriteVC : MenuNavigationDelegate{
  
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

extension FavouriteVC : InternetConnectionDelegate{
  
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
        
        if(vc is FavouriteVC){
          Utility.internet_connection_Show(onViewController: self)
        }
      }
      
    }
    
  }
  
  func reloadPage() {
    
    self.arrFavourites.removeAll()
    self.getFavouritesList(pageNo: 1)
    
  }
}
