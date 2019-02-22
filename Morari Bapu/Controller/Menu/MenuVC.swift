//
//  DropdownVC.swift
//  Doggie
//
//  Created by Bhavin Chauhan on 07/08/18.
//  Copyright © 2018 Bhavin Chauhan. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import IQKeyboardManagerSwift
import Kingfisher
import SwiftyUserDefaults

protocol MenuNavigationDelegate: class {
  func SelectedMenu(ScreenName: String?)
}


class MenuVC: UIViewController {
    
    @IBOutlet var cvMenu: UICollectionView!
    
     var arrMenu  = [String:JSON]()
  
    weak var delegate: MenuNavigationDelegate?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
    
      DispatchQueue.main.async {
        self.getUnreadCounter()
      }
        
    }

  override func viewWillDisappear(_ animated: Bool) {
    
    Utility.menu_Hide(onViewController: self)

  }
  
  //MARK:- Api Call
  func getUnreadCounter(){
    
    let param = ["app_id":Utility.getDeviceID()] as NSDictionary
    
    WebServices().CallGlobalAPI(url: WebService_Menu_Counts,headers: [:], parameters: param, HttpMethod: "POST", ProgressView: false) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
      
      if(jsonResponce?.error != nil) {
        
        var errorMess = jsonResponce?.error?.localizedDescription
        errorMess = MESSAGE_Err_Service
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
      }
      else {
        
        if jsonResponce!["status"].stringValue == "true"{
          
          self.arrMenu = jsonResponce!["data"].dictionaryValue
          
          if self.arrMenu.count != 0{
            
            DispatchQueue.main.async {
              self.cvMenu .reloadData()
            }
          }
          else
          {
            
            DispatchQueue.main.async {
              self.cvMenu .reloadData()
              
            }
          }
          
        }
        else {
          Utility().showAlertMessage(vc: self, titleStr: "", messageStr: jsonResponce!["message"].stringValue)
        }
      }
    }
  }
  
   
}



// MARK: CollectionView Delegate
extension MenuVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
      return 17
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath) as! MenuCollectionViewCell
      
      cell.imgMenu.image = UIImage(named: "menu_\(indexPath.row+1)")
      
      
      cell.lblCounter.layer.masksToBounds = true
      cell.lblCounter.layer.borderWidth = 1.5
      cell.lblCounter.layer.borderColor = UIColor.white.cgColor
      cell.lblCounter.layer.cornerRadius = cell.lblCounter.frame.height / 2
      
      cell.lblCounter.isHidden = true
      
      if indexPath.row == 0{
        cell.lblTitle.text = "Home"
        cell.lblCounter.isHidden = true
      }
      else if indexPath.row == 1{
        //Katha Chopai
        
        cell.lblTitle.text = "Katha Chopai"
        
        if arrMenu["KathaChopai"]?.stringValue == ""{
          cell.lblCounter.isHidden = true
        }
        else if arrMenu["KathaChopai"]?.intValue ?? 0 < 99{
            cell.lblCounter.text = arrMenu["KathaChopai"]?.stringValue
            cell.lblCounter.isHidden = false
        }else{
            cell.lblCounter.text = " 99+ "
          cell.lblCounter.isHidden = false
        }
        
      }else if indexPath.row == 2{
        
        //Quotes
        
        cell.lblTitle.text = "Quotes"
        
        
        if arrMenu["Quotes"]?.stringValue == ""{
          cell.lblCounter.isHidden = true
        }
        else if arrMenu["Quotes"]?.intValue ?? 0 < 99{
          cell.lblCounter.text = arrMenu["Quotes"]?.stringValue
          cell.lblCounter.isHidden = false
        }else{
          cell.lblCounter.text = " 99+ "
          cell.lblCounter.isHidden = false
        }
        
        
        
      }else if indexPath.row == 3{
        //Upcoing Katha
        
          cell.lblTitle.text = "UpComing Katha"
        
        
        if arrMenu["UpcomingKatha"]?.stringValue == ""{
          cell.lblCounter.isHidden = true
        }
        else if arrMenu["UpcomingKatha"]?.intValue ?? 0 < 99{
          cell.lblCounter.text = arrMenu["UpcomingKatha"]?.stringValue
          cell.lblCounter.isHidden = false
        }else{
          cell.lblCounter.text = " 99+ "
          cell.lblCounter.isHidden = false
        }
        
        
      }else if indexPath.row == 4{
       
        //Ram Charitra Manas
        
        cell.lblTitle.text = "Ram Charitra Manas"
        cell.lblCounter.isHidden = false
        
        if arrMenu["Ramcharit"]?.stringValue == ""{
          cell.lblCounter.isHidden = true
        }
        else if arrMenu["Ramcharit"]?.intValue ?? 0 < 99{
          cell.lblCounter.text = arrMenu["Ramcharit"]?.stringValue
          cell.lblCounter.isHidden = false
        }else{
          cell.lblCounter.text = " 99+ "
          cell.lblCounter.isHidden = false
        }
        
      }else if indexPath.row == 5{
        //Daily Katha Clip
        
        cell.lblTitle.text = "Daily Katha Clip"
        
        if arrMenu["DailyKathaVideo"]?.stringValue == ""{
          cell.lblCounter.isHidden = true
        }
        else if arrMenu["DailyKathaVideo"]?.intValue ?? 0 < 99{
          cell.lblCounter.text = arrMenu["DailyKathaVideo"]?.stringValue
          cell.lblCounter.isHidden = false
        }else{
          cell.lblCounter.text = " 99+ "
          cell.lblCounter.isHidden = false
        }
      }
      else if indexPath.row == 6{
        //Media
        
        cell.lblTitle.text = "Media"
        
        if arrMenu["Media"]?.stringValue == ""{
          cell.lblCounter.isHidden = true
        }
        else if arrMenu["Media"]?.intValue ?? 0 < 99{
          cell.lblCounter.text = arrMenu["Media"]?.stringValue
          cell.lblCounter.isHidden = false
        }else{
          cell.lblCounter.text = " 99+ "
          cell.lblCounter.isHidden = false
        }
        
      }else if indexPath.row == 7{
        //What's New
        
          cell.lblTitle.text = "What's New"
        
        
        if arrMenu["WhatsNew"]?.stringValue == ""{
          cell.lblCounter.isHidden = true
        }
        else if arrMenu["WhatsNew"]?.intValue ?? 0 < 99{
          cell.lblCounter.text = arrMenu["WhatsNew"]?.stringValue
          cell.lblCounter.isHidden = false
        }else{
          cell.lblCounter.text = " 99+ "
          cell.lblCounter.isHidden = false
        }
        
      }
      else if indexPath.row == 8{
        //Events
        cell.lblTitle.text = "Events"
        
        if arrMenu["Event"]?.stringValue == ""{
          cell.lblCounter.isHidden = true
        }
        else if arrMenu["Event"]?.intValue ?? 0 < 99{
          cell.lblCounter.text = arrMenu["Event"]?.stringValue
          cell.lblCounter.isHidden = false
        }else{
          cell.lblCounter.text = " 99+ "
          cell.lblCounter.isHidden = false
        }
        
      }
      else if indexPath.row == 9{
        cell.lblTitle.text = "Sangeet Ni Duniya"
        cell.lblCounter.isHidden = true
      }
      else if indexPath.row == 10{
        cell.lblTitle.text = "YouTube Channel"
        cell.lblCounter.isHidden = true
      }
      else if indexPath.row == 11{
        cell.lblTitle.text = "Live Katha Video"
        cell.lblCounter.isHidden = true
      }
      else if indexPath.row == 12{
        cell.lblTitle.text = "Setting"
        cell.lblCounter.isHidden = true
      }
      else if indexPath.row == 13{
        cell.lblTitle.text = "Search"
        cell.lblCounter.isHidden = true
      }
      else if indexPath.row == 14{
        cell.lblTitle.text = "Favourites"
        cell.lblCounter.isHidden = true
      }
      else if indexPath.row == 15{
        //Katha Ebook
        
        cell.lblTitle.text = "Katha E-Book"
        
        
        if arrMenu["KathaEBook"]?.stringValue == ""{
          cell.lblCounter.isHidden = true
        }
        else if arrMenu["KathaEBook"]?.intValue ?? 0 < 99{
          cell.lblCounter.text = arrMenu["KathaEBook"]?.stringValue
          cell.lblCounter.isHidden = false
        }else{
          cell.lblCounter.text = " 99+ "
          cell.lblCounter.isHidden = false
        }
        
      }
      else if indexPath.row == 16{
        cell.lblTitle.text = "Privacy Notice"
        cell.lblCounter.isHidden = true
      }
      else{
        cell.lblCounter.isHidden = true
      }
      
        return cell
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            if UIDevice.current.userInterfaceIdiom == .pad{
                let yourWidth = (collectionView.bounds.width - 40) / 3.0
                let yourHeight = yourWidth
                
                return CGSize(width: yourWidth, height: yourHeight - 15)
            }
            else{
                let yourWidth = (collectionView.bounds.width - 40) / 3.0
                let yourHeight = yourWidth
                
                return CGSize(width: yourWidth, height: yourHeight - 15)
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      

        if indexPath.row == 0{
          //Katha Chopai
          delegate?.SelectedMenu(ScreenName: "Home")
          
        }
        else if indexPath.row == 1{
          //Katha Chopai
          delegate?.SelectedMenu(ScreenName: "Katha Chopai")

        }else if indexPath.row == 2{
          //Quotes
          delegate?.SelectedMenu(ScreenName: "Quotes")

        }else if indexPath.row == 3{
          //Upcoing Katha
          delegate?.SelectedMenu(ScreenName: "Upcoing Katha")

        }else if indexPath.row == 4{
          //Ram Charitra Manas
          delegate?.SelectedMenu(ScreenName: "Ram Charitra Manas")
          
        }else if indexPath.row == 5{
          //Daily Katha Clip
          delegate?.SelectedMenu(ScreenName: "Daily Katha Clip")

        }else if indexPath.row == 6{
          //Media
          delegate?.SelectedMenu(ScreenName: "Media")

        } else if indexPath.row == 7{
          //What's New
          delegate?.SelectedMenu(ScreenName: "What's New")
          
        }else if indexPath.row == 8{
          //Events
          delegate?.SelectedMenu(ScreenName: "Events")
          
        }else if indexPath.row == 9{
          //Sangeet Ni Duniya
          delegate?.SelectedMenu(ScreenName: "Sangeet Ni Duniya")
          
        }else if indexPath.row == 10{
          //You Tube Channel
          delegate?.SelectedMenu(ScreenName: "You Tube Channel")

        }else if indexPath.row == 11{
          //Live Katha Video
          delegate?.SelectedMenu(ScreenName: "Live Katha Video")

        }
       else if indexPath.row == 12{
          //Setting
          delegate?.SelectedMenu(ScreenName: "Setting")

        }else if indexPath.row == 13{
          //Search
          delegate?.SelectedMenu(ScreenName: "Search")

        }else if indexPath.row == 14{
          //Favourites
          delegate?.SelectedMenu(ScreenName: "Favourites")

        }
        else if indexPath.row == 15{
          //Katha Ebook
          delegate?.SelectedMenu(ScreenName: "Katha Ebook")
          
      }
        else if indexPath.row == 16{
          //Privacy Notice
          delegate?.SelectedMenu(ScreenName: "Privacy Notice")
          
      }
      
      Utility.menu_Hide(onViewController: self)

    }
}

