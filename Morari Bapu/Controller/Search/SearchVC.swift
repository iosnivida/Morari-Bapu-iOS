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


class SearchVC: UIViewController {
  
  @IBOutlet weak var tblSearch: UITableView!
  @IBOutlet weak var lblTitle: UILabel!
  @IBOutlet weak var txrSearch: UITextField!
  var lastContentOffset: CGFloat = 0

  var arrTitle : [String] = []
  var arrSection = [JSON]()
  
  var currentPageNo = Int()
  var totalPageNo = Int()
  var is_Api_Being_Called : Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tblSearch.tableFooterView =  UIView.init(frame: .zero)
    tblSearch.layoutMargins = .zero
    
    tblSearch.rowHeight = 150
    tblSearch.estimatedRowHeight = UITableView.automaticDimension
    
    txrSearch.layer.masksToBounds = true
    txrSearch.layer.cornerRadius = 3.0
    txrSearch.layer.borderWidth = 1.0
    txrSearch.layer.borderColor = UIColor.lightGray.cgColor
    
    txrSearch.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: txrSearch.frame.height))
    txrSearch.leftViewMode = .always

    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    currentPageNo = 1
    
  }
  

  
  //MARK:- Api Call
  func getSearchResult(pageNo:Int){

    if txrSearch.text?.count != 0{
      
      let param = ["page" : pageNo,
                   "app_id":Utility.getDeviceID(),
                   "filter_name":txrSearch.text!] as NSDictionary
      
      WebServices().CallGlobalAPI(url: WebService_Search,headers: [:], parameters: param, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
        
        if(jsonResponce?.error != nil) {
          
          var errorMess = jsonResponce?.error?.localizedDescription
          errorMess = MESSAGE_Err_Service
          Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
        }
        else {
          
          if jsonResponce!["status"].stringValue == "true"{
            
            self.is_Api_Being_Called = false
            
            self.totalPageNo = jsonResponce!["total_page"].intValue
            
            let keys = jsonResponce!["data"].compactMap(){ $0.0}
            let values = jsonResponce!["data"].compactMap(){ $0.1}
          
            self.arrSection = values
            
            self.arrTitle.removeAll()
            for result in keys {
              self.arrTitle.append(result)
            }
            
            for result in values {
              self.arrSection.append(result)
            }
          
            if self.arrTitle.count != 0{
              DispatchQueue.main.async {
                
                Utility.tableNoDataMessage(tableView: self.tblSearch, message: "",messageColor:UIColor.darkGray, displayMessage: .Top)
                
                self.tblSearch.reloadData()
              }
            }
            else
            {
              
              DispatchQueue.main.async {
                self.tblSearch.reloadData()
                Utility.tableNoDataMessage(tableView: self.tblSearch, message: "No records",messageColor:UIColor.darkGray, displayMessage: .Top)
              }
            }
            
          }
          else {
            self.is_Api_Being_Called = false
            Utility().showAlertMessage(vc: self, titleStr: "", messageStr: jsonResponce!["message"].stringValue)
          }
        }
      }
      
    }else{
      arrTitle.removeAll()
      arrSection.removeAll()
      tblSearch.reloadData()
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
  
  @IBAction func searchText(_ sender: UITextField) {
    
    
    self.arrSection.removeAll()
    self.arrTitle.removeAll()
    
    getSearchResult(pageNo: 1)

    
  }
  
}

//MARK TableView Delegate
extension SearchVC : UITableViewDelegate, UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return arrTitle.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrSection[section].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
    let cellIdentifier = "KathaChopaiTableViewCell"
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? KathaChopaiTableViewCell  else {
      fatalError("The dequeued cell is not an instance of MealTableViewCell.")
    }
    
      var data = arrSection[indexPath.section][indexPath.row]
    
      cell.lblTitle.text = data["title"].stringValue
      cell.lblDescription1.text = data["description"].stringValue
  
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let data = arrSection[indexPath.section][indexPath.row]
    
    if data["module_name"].stringValue == "Event"{
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "EventsDetailsVC") as! EventsDetailsVC
      vc.strId = data["module_id"].stringValue
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if data["module_name"].stringValue == "Quotes"{
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiDetailsVC") as! KathaChopaiDetailsVC
      vc.strId = data["module_id"].stringValue
      vc.strTitle = "Quotes"
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if data["module_name"].stringValue == "Katha Chopai"{
      
    let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiDetailsVC") as! KathaChopaiDetailsVC
    vc.strId = data["module_id"].stringValue
    vc.strTitle = "Katha Chopai"
    navigationController?.pushViewController(vc, animated:  true)
  }
    else if data["module_name"].stringValue == "Sankirtan"{
      
      //Sankirtan
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "AudioVC") as! AudioVC
      vc.screenDirection = .Sankirtan
      navigationController?.pushViewController(vc, animated:  true)
 
    }
    else if data["module_name"].stringValue == "Stuti"{
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "AudioVC") as! AudioVC
      vc.screenDirection = .Stuti
      navigationController?.pushViewController(vc, animated:  true)
      
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    let viewSection = UIView()
    viewSection.backgroundColor = UIColor(displayP3Red: 231.0/255.0, green: 231.0/255.0, blue: 231.0/255.0, alpha: 1.0)
    
    let label = UILabel()
    label.text = arrTitle[section]
    label.font = UIFont(name: MontserratSemiBold, size: 16.0)
    label.textColor = UIColor(displayP3Red: 123.0/255.0, green: 45.0/255.0, blue: 56.0/255.0, alpha: 1.0)
    label.frame = CGRect(x: 16, y:0, width: 200, height: 40)
    viewSection.addSubview(label)
 
    return viewSection
    
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 40
  }
 /*
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
  {
    if (self.lastContentOffset < scrollView.contentOffset.y) {
      // moved to top
      
      if is_Api_Being_Called == false{
        if currentPageNo <  totalPageNo{
          print("Page Load....")
          is_Api_Being_Called = true
          currentPageNo += 1
          self.getSearchResult(pageNo: currentPageNo)
        }
      }
      
    } else if (self.lastContentOffset > scrollView.contentOffset.y) {
      // moved to bottom
      
      
    } else {
      // didn't move
    }
    
  }*/
  
  
  /*func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    if indexPath.row == arrSection[indexPath.section][indexPath.row].count - 1{
      if is_Api_Being_Called == false{
        if currentPageNo <  totalPageNo{
          print("Page Load....")
          is_Api_Being_Called = true
          currentPageNo += 1
          self.getSearchResult(pageNo: currentPageNo)
        }
      }
    }
  }*/
}

extension SearchVC : UITextFieldDelegate{
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    self.arrSection.removeAll()
    self.arrTitle.removeAll()
    
    getSearchResult(pageNo: 1)
    self.view.endEditing(true)
    return true
  }
  
}

//MARK:- Menu Navigation Delegate
extension SearchVC : MenuNavigationDelegate{
  
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
