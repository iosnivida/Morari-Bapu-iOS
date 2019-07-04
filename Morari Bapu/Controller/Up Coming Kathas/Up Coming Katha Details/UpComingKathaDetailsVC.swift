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
  

    @IBOutlet weak var lblHeaderTitle: UILabel!
    var arrUpComingKathas : [JSON] = []
  var indexPosition = IndexPath()
    
  var strId = String()

  @IBOutlet weak var cvUpComingKathaDetails: UICollectionView!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Add reachability observer
    if let reachability = AppDelegate.sharedAppDelegate()?.reachability
    {
      NotificationCenter.default.addObserver( self, selector: #selector( self.reachabilityChanged ),name: Notification.Name.reachabilityChanged, object: reachability)
    }
    
    if arrUpComingKathas.count != 0{
        
        let dict =  arrUpComingKathas[self.indexPosition.row].dictionaryValue
        
        self.lblHeaderTitle.text = dict["UpcomingKatha"]!["title"].stringValue

        DispatchQueue.main.async {
            self.cvUpComingKathaDetails.scrollToItem(at: self.indexPosition, at: .centeredHorizontally, animated: false)
            
            Utility.collectionViewNoDataMessage(collectionView: self.cvUpComingKathaDetails, message: "", textColor: UIColor.white)
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
  
}

//MARK:- Menu Navigation Delegate
extension UpComingKathaDetailsVC: MenuNavigationDelegate{
  
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


extension UpComingKathaDetailsVC : InternetConnectionDelegate{
  
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
        
        if(vc is UpComingKathaDetailsVC){
          Utility.internet_connection_Show(onViewController: self)
        }
      }
      
    }
    
  }
  
  func reloadPage() {
    
   self.viewDidLoad()
    
  }
}


// MARK: CollectionView Delegate
extension UpComingKathaDetailsVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrUpComingKathas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpComingKathaDetailCollectionViewCell", for: indexPath) as! UpComingKathaDetailCollectionViewCell
        
        var dict = arrUpComingKathas[indexPath.row]
        
//            self.arrUpcomingKathaDetails = jsonResponce!["data"]["UpcomingKatha"].dictionaryValue
//            self.arrKathaTiming = jsonResponce!["data"]["UpcomingKathaTime"].arrayValue
            cell.lblOtherInfo.attributedText = NSAttributedString(html: dict["UpcomingKatha"]["other"].stringValue)
        
            cell.lblKathaLoction.text = dict["UpcomingKatha"]["location"].stringValue
            cell.lblKathaLanguages.text = dict["UpcomingKatha"]["language"].stringValue
            cell.lblKathaDates.text = "\(Utility.dateToString(dateStr: (dict["UpcomingKatha"]["from_date"].stringValue), strDateFormat: "EEEE MMM dd'th', yyyy")) - \(Utility.dateToString(dateStr: (dict["UpcomingKatha"]["to_date"].stringValue), strDateFormat: "EEEE MMM dd'th', yyyy"))"
        
            cell.btnShare.tag = indexPath.row
            cell.btnFavourites.tag = indexPath.row
            cell.btnViewMap.tag = indexPath.row
                
            cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
            cell.btnFavourites.addTarget(self, action: #selector(btnFavourite(_:)), for: UIControl.Event.touchUpInside)
            cell.btnViewMap.addTarget(self, action: #selector(btnViewMap(_:)), for: UIControl.Event.touchUpInside)
        
        
        var timings = [String]()

            for kathaTiming in dict["UpcomingKathaTime"].arrayValue{
         
                timings.append("Katha Date: \(Utility.dateToString(dateStr: kathaTiming["from_d"].stringValue, strDateFormat: "dd MMM yyyy")) To \(Utility.dateToString(dateStr: kathaTiming["to_d"].stringValue, strDateFormat: "dd MMM yyyy")) \nfrom Time: \(kathaTiming["from_time"].stringValue) To Time: \(kathaTiming["to_time"].stringValue)\n")
                
            }
        
            let timeString = timings.joined(separator: "\n")
        
            cell.lblKathaTiming.text = timeString

            if dict["is_favourite"].boolValue == true{
                cell.btnFavourites.setImage(UIImage(named: "favorite"), for: .normal)
            }else{
                cell.btnFavourites.setImage(UIImage(named: "unfavorite"), for: .normal)
            }
        
            return cell
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if Device.IS_IPHONE_X{
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
        else{
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    @IBAction func btnShare(_ sender: UIButton) {
        
        var dict = arrUpComingKathas[sender.tag].dictionaryValue
        
        let share_Content = "UpComing Katha \n\n\(dict["UpcomingKatha"]!["title"].stringValue) \n\nDate: \(dict["UpcomingKatha"]!["location"].stringValue) \n\n \(dict["UpcomingKatha"]!["language"].stringValue) \n\n\(Utility.dateToString(dateStr: (dict["UpcomingKatha"]!["from_date"].stringValue), strDateFormat: "EEEE MMM dd'th', yyyy")) - \(Utility.dateToString(dateStr: (dict["UpcomingKatha"]!["to_date"].stringValue), strDateFormat: "EEEE MMM dd'th', yyyy")) \n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
        
        let textToShare = [share_Content]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        DispatchQueue.main.async {
            self.present(activityViewController, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func btnFavourite(_ sender: UIButton) {
        
        var data = arrUpComingKathas[sender.tag]
        
        let paramater = ["app_id":Utility.getDeviceID(),
                         "favourite_for":"14",
                         "favourite_id":data["UpcomingKatha"]["id"].stringValue]
        
        WebServices().CallGlobalAPI(url: WebService_Favourite,headers: [:], parameters: paramater as NSDictionary, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
            
            if(jsonResponce?.error != nil) {
                
                var errorMess = jsonResponce?.error?.localizedDescription
                errorMess = MESSAGE_Err_Service
                Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
            }
            else {
                
                if jsonResponce!["status"].stringValue == "true"{
                   
                    if jsonResponce!["message"].stringValue == "Added in your favourite list"{
                        
                        data["is_favourite"] = true;
                        
                        self.arrUpComingKathas[sender.tag] = data
                        self.cvUpComingKathaDetails.reloadData()
                        //self.delegate?.result(self.arrFavourites)
                        
                    }else{
                        
                        data["is_favourite"] = false;
                        self.arrUpComingKathas[sender.tag] = data
                        self.cvUpComingKathaDetails.reloadData()
                        //self.delegate?.result(self.arrFavourites)
                        
                    }
                    
                }
                else {
                    Utility().showAlertMessage(vc: self, titleStr: "", messageStr: jsonResponce!["message"].stringValue)
                }
            }
        }
    }
    
    @IBAction func btnViewMap(_ sender: UIButton) {
        
        var data = arrUpComingKathas[sender.tag]

        if data["UpcomingKatha"]["map_link"].stringValue != ""{
            DispatchQueue.main.async {
                UIApplication.shared.open(URL(string: data["UpcomingKatha"]["map_link"].stringValue)!, options: [:])
            }
        }
        
    }
    
}

//MARK:- Scrollview Delegate
extension UpComingKathaDetailsVC: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == cvUpComingKathaDetails{
            let x = cvUpComingKathaDetails.contentOffset.x
            let w = cvUpComingKathaDetails.bounds.size.width
            let currentPage = Int(ceil(x/w))
            
            var data = arrUpComingKathas[currentPage]
            
            self.lblHeaderTitle.text = data["UpcomingKatha"]["title"].stringValue
            
        }
    }
    
    
}
