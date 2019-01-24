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
  
  var arrFavourites : [JSON] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tblFavourites.tableFooterView =  UIView.init(frame: .zero)
    tblFavourites.layoutMargins = .zero
    
    tblFavourites.rowHeight = 150
    tblFavourites.estimatedRowHeight = UITableView.automaticDimension

    lblTitle.text = "Favourites"
 
    self.getFavouritesList()
    
  }
  
  //MARK:- Api Call
  func getFavouritesList(){
    
    let param = ["page" : "1",
                 "app_id":Utility.getDeviceID()] as NSDictionary
 
    WebServices().CallGlobalAPI(url: WebService_Favourite_List,headers: [:], parameters: param, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
      
      if(jsonResponce?.error != nil) {
        
        var errorMess = jsonResponce?.error?.localizedDescription
        errorMess = MESSAGE_Err_Service
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
      }
      else {
        
        if jsonResponce!["status"].stringValue == "true"{
          
          self.arrFavourites.removeAll()
          self.arrFavourites = jsonResponce!["data"].arrayValue
          
          if self.arrFavourites.count != 0{
            DispatchQueue.main.async {
              
              Utility.tableNoDataMessage(tableView: self.tblFavourites, message: "",messageColor:UIColor.white, displayMessage: .Center)
              
              self.tblFavourites .reloadData()
            }
          }
          else
          {
            
            DispatchQueue.main.async {
              self.tblFavourites.reloadData()
              Utility.tableNoDataMessage(tableView: self.tblFavourites, message: "No Favourites",messageColor:UIColor.white, displayMessage: .Center)
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
      
      cell.lblTitle.text = "\(data["title"].stringValue)-\(data["title_no"].stringValue)"
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
      
      cell.lblTitle.text = "\(data["title"].stringValue)-\(data["title_no"].stringValue)"
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
      
      cell.imgVideo.kf.indicatorType = .activity
      cell.imgVideo.kf.setImage(with: URL(string: "\(BASE_URL_IMAGE)\(data["video_image"].stringValue)"), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
      
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
    else if data["list_heading"].stringValue == "Bapu Articles"{
      //Bapu Articles

      let cellIdentifier = "YoutubeTableViewCell"
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? YoutubeTableViewCell  else {
        fatalError("The dequeued cell is not an instance of MealTableViewCell.")
      }
      
      cell.lblTitle.text = data["article"].stringValue
      cell.lblDuration.text = data["link"].stringValue
      cell.lblDate.text = Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd-MMM-yyyy")
      
      let placeHolder = UIImage(named: "youtube_placeholder")
      
      cell.imgVideo.kf.indicatorType = .activity
      cell.imgVideo.kf.setImage(with: URL(string: "\(BASE_URL_IMAGE)\(data["video_image"].stringValue)"), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
      
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
      cell.lblDuration.numberOfLines = 4
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
      
    }else{
      return UITableViewCell()
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
   
  }
  
  @IBAction func btnFavourite(_ sender: UIButton) {
    
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
      
    }

    
    WebServices().CallGlobalAPI(url: WebService_Favourite,headers: [:], parameters: paramater, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
      
      if(jsonResponce?.error != nil) {
        
        var errorMess = jsonResponce?.error?.localizedDescription
        errorMess = MESSAGE_Err_Service
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
      }
      else {
        
        if jsonResponce!["status"].stringValue == "true"{
         
          self.getFavouritesList()
         
        }
        else if jsonResponce!["status"].stringValue == "false"{
          
          if jsonResponce!["status"].stringValue == "No Data Found"{
            self.getFavouritesList()

          }
          
        }
        else {
          Utility().showAlertMessage(vc: self, titleStr: "", messageStr: jsonResponce!["message"].stringValue)
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
      
      share_Content = "\(data["title"].stringValue) \n\nDate: \(Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd MMM yyyy")) \n\n \(data["quotes_gujarati"].stringValue) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"

      
    }
    else if data["list_heading"].stringValue == "Katha Chopai"{
      //Katha Chopai
      
      share_Content = "\(data["title"].stringValue)-\(data["title_no"].stringValue) \n\nDate: \(Utility.dateToString(dateStr: data["from_date"].stringValue, strDateFormat: "dd MMM yyyy")) \n\n \(data["quotes_hindi"].stringValue) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"


      
    }
    else if data["list_heading"].stringValue == "Ram Charit Manas"{
      //Ram charit manas
      share_Content = "\(data["title"].stringValue)-\(data["title_no"].stringValue) \n\nDate: \(Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd MMM yyyy")) \n\n \(data["description"].stringValue) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"


      
    }
    else if data["list_heading"].stringValue == "Stuti"{
      
      share_Content = "\(data["title"].stringValue) \n\n(Duration: \(data["video_duration"].stringValue)) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"

      
    }else if data["list_heading"].stringValue == "Other Stuti"{
      
      share_Content = "\(data["title"].stringValue) \n\n(Duration: \(data["video_duration"].stringValue)) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"

      
    }else if data["list_heading"].stringValue == "Sankirtan"{
      
      share_Content = "\(data["title"].stringValue) \n\n(Duration: \(data["video_duration"].stringValue)) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"

      
    }
    else if data["list_heading"].stringValue == "Bapufavouriteshayari"{
      
       share_Content = "Shayari \n\n \(data["quotes_gujarati"].stringValue) \n\n\(data["quotes_english"].stringValue) \n\n\(data["quotes_hindi"].stringValue)  \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"

      
    }else if data["list_heading"].stringValue == "Daily Katha Video"{
      
       share_Content = "\(data["title"].stringValue) \n(Duration: \(data["video_duration"].stringValue)) \n \(Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd-MM-yyyy")) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"

      
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
    
    DispatchQueue.main.async {
      UIApplication.shared.open(URL(string: youtubeLink)!, options: [:])
    }
    
  }
  
  @IBAction func btnToSpecificScreen(_ sender: UIButton) {
    
    let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblFavourites)
    let indexPath = self.tblFavourites.indexPathForRow(at: buttonPosition)
    
    let data = arrFavourites[indexPath!.row]
    
    if data["list_heading"].stringValue == "Quotes"{
      //Quotes
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiVC") as! KathaChopaiVC
      vc.screenDirection = .Quotes
      navigationController?.pushViewController(vc, animated:  true)

    }
    else if data["list_heading"].stringValue == "Katha Chopai"{
      //Katha Chopai
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiVC") as! KathaChopaiVC
      vc.screenDirection = .Katha_Chopai
      navigationController?.pushViewController(vc, animated:  true)
      
    }
    else if data["list_heading"].stringValue == "Ram Charit Manas"{
      //Ram charit manas
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiVC") as! KathaChopaiVC
      vc.screenDirection = .Ram_Charit_Manas
      navigationController?.pushViewController(vc, animated:  true)

    }
    else if data["list_heading"].stringValue == "Stuti"{
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "AudioVC") as! AudioVC
      vc.screenDirection = .Stuti
      navigationController?.pushViewController(vc, animated:  true)

    }else if data["list_heading"].stringValue == "Other Stuti"{
      
      //Other Audio
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "AudioVC") as! AudioVC
      vc.screenDirection = .Others
      navigationController?.pushViewController(vc, animated:  true)

    }else if data["list_heading"].stringValue == "Sankirtan"{
      
      //Sankirtan
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "AudioVC") as! AudioVC
      vc.screenDirection = .Sankirtan
      navigationController?.pushViewController(vc, animated:  true)
      
    }
    else if data["list_heading"].stringValue == "Bapufavouriteshayari"{
      
      //Sher O Shayri
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "ShayriVC") as! ShayriVC
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if data["list_heading"].stringValue == "Daily Katha Video"{
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "WhatsNewVideoVC") as! WhatsNewVideoVC
      vc.screenDirection = .Daily_Katha_Clip
      navigationController?.pushViewController(vc, animated:  true)

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
