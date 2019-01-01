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

enum KathaChopaiScreenIdentify {
  case Katha_Chopai
  case Ram_Charit_Manas
}

class KathaChopaiVC: UIViewController {

  @IBOutlet weak var tblKathaChopai: UITableView!
  var screenDirection = KathaChopaiScreenIdentify.Ram_Charit_Manas
  @IBOutlet weak var lblTitle: UILabel!

  var arrKathaChopia : [JSON] = []
  var arrRamCharitManas : [JSON] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()

      tblKathaChopai.tableFooterView =  UIView.init(frame: .zero)
      tblKathaChopai.layoutMargins = .zero
      
      tblKathaChopai.rowHeight = 150
      tblKathaChopai.estimatedRowHeight = UITableView.automaticDimension
      
      if screenDirection == .Katha_Chopai{
        lblTitle.text = "Katha Chopai"
        getKathaChopai()
      }else{
        //Ram Charit Manas
        lblTitle.text = "Ram Charit Manas"
        getRamCharitManas()
      }
      
  }

  //MARK: Api Call
  func getKathaChopai(){
    
    let param = ["page" : "1",
                 "app_id":Utility.getDeviceID(),
                 "favourite_for":"1"] as NSDictionary
    
    WebServices().CallGlobalAPI(url: WebService_Chopai_List,headers: [:], parameters: param, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
      
      if(jsonResponce?.error != nil) {
        
        var errorMess = jsonResponce?.error?.localizedDescription
        errorMess = MESSAGE_Err_Service
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
      }
      else {
        
        if jsonResponce!["status"].stringValue == "true"{
          self.arrKathaChopia = jsonResponce!["data"].arrayValue
          
          if self.arrKathaChopia.count != 0{
              DispatchQueue.main.async {
              
              Utility.tableNoDataMessage(tableView: self.tblKathaChopai, message: "",messageColor:UIColor.white, displayMessage: .Center)

              self.tblKathaChopai .reloadData()
            }
          }
          else
          {
            
            DispatchQueue.main.async {
              self.tblKathaChopai.reloadData()
              Utility.tableNoDataMessage(tableView: self.tblKathaChopai, message: "No records",messageColor:UIColor.white, displayMessage: .Center)
            }
          }
          
        }
        else {
          Utility().showAlertMessage(vc: self, titleStr: "", messageStr: jsonResponce!["message"].stringValue)
        }
      }
    }
  }
  
  func getRamCharitManas(){
    
    let param = ["page" : "1",
                 "app_id":Utility.getDeviceID(),
                 "favourite_for":"1"] as NSDictionary
    
    WebServices().CallGlobalAPI(url: WebService_Ram_Charit_Manas_List,headers: [:], parameters: param, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
      
      if(jsonResponce?.error != nil) {
        
        var errorMess = jsonResponce?.error?.localizedDescription
        errorMess = MESSAGE_Err_Service
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
      }
      else {
        
        if jsonResponce!["status"].stringValue == "true"{
          self.arrRamCharitManas = jsonResponce!["data"].arrayValue
          
          if self.arrRamCharitManas.count != 0{
            DispatchQueue.main.async {
              
              Utility.tableNoDataMessage(tableView: self.tblKathaChopai, message: "",messageColor:UIColor.white, displayMessage: .Center)
              
              self.tblKathaChopai .reloadData()
            }
          }
          else
          {
            
            DispatchQueue.main.async {
              self.tblKathaChopai.reloadData()
              Utility.tableNoDataMessage(tableView: self.tblKathaChopai, message: "No records",messageColor:UIColor.white, displayMessage: .Center)
            }
          }
          
        }
        else {
          Utility().showAlertMessage(vc: self, titleStr: "", messageStr: jsonResponce!["message"].stringValue)
        }
      }
    }
  }
  
  //MARK: Button Event
  @IBAction func btnMenu(_ sender: Any) {
    Utility.menu_Show(onViewController: self)

  }
  
  @IBAction func btnHanumanChalisha(_ sender: Any) {
    Utility.hanuman_chalisha_Show(onViewController: self)

  }
}

//MARK TableView Delegate
extension KathaChopaiVC : UITableViewDelegate, UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if screenDirection == .Katha_Chopai{
      return arrKathaChopia.count
    }else{
      //Ram Charit Manas
      return arrRamCharitManas.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
    let cellIdentifier = "KathaChopaiTableViewCell"
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? KathaChopaiTableViewCell  else {
      fatalError("The dequeued cell is not an instance of MealTableViewCell.")
    }
    
    if screenDirection == .Katha_Chopai{
      
      let data = arrKathaChopia[indexPath.row]
      
      cell.lblTitle.text = data["title"].stringValue
      cell.lblDate.text = Utility.dateToString(dateStr: data["from_date"].stringValue, strDateFormat: "dd MMM yyyy")
      cell.lblDescription1.text = data["katha_english"].stringValue
      cell.lblDescription2.text = data["katha_hindi"].stringValue

      
      return cell
    }else
    {
      //Ram Charit Manas
      
      let data = arrRamCharitManas[indexPath.row]
      
      cell.lblTitle.text = data["title"].stringValue
      cell.lblDate.text = Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd MMM yyyy")
      cell.lblDescription1.text = data["katha_english"].stringValue
      cell.lblDescription2.text = data["katha_hindi"].stringValue
      
      return cell
      
      }
  
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
    if screenDirection == .Katha_Chopai{
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiDetailsVC") as! KathaChopaiDetailsVC
      vc.strTitle = lblTitle.text!
      vc.arrKathaDetails = arrKathaChopia[indexPath.row].dictionaryValue
      navigationController?.pushViewController(vc, animated:  true)
      
    }else{
      //Ram Charit Manas
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiDetailsVC") as! KathaChopaiDetailsVC
      vc.strTitle = lblTitle.text!
      vc.arrKathaDetails = arrRamCharitManas[indexPath.row].dictionaryValue
      navigationController?.pushViewController(vc, animated:  true)
    }
    
  }
}

//MARK: Menu Navigation Delegate
extension KathaChopaiVC : MenuNavigationDelegate{
  
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
      
    }else if ScreenName == "Daily Katha Clip"{
      //Daily Katha Clip
      
      
    }else if ScreenName == "Live Katha Audio"{
      //Live Katha Audio
      
    }else if ScreenName == "You Tube Channel"{
      //You Tube Channel
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
      vc.screenDirection = .Moraribapu_Youtube_Channel
      vc.strTitle = "Morari Bapu Youtube channel"
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Live Katha Video"{
      //Live Katha Video
      
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
