//
//  SettingsVC.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 07/10/18.
//  Copyright © 2018 Bhavin Chauhan. All rights reserved.
//

import UIKit
import Toast_Swift


enum SettingScreenIdentify {
  case Settings
  case About_Us
  case Media
  case Other_Videos
  case Whats_New
}


class SettingsVC: UIViewController {

  @IBOutlet weak var tblSettings: UITableView!
  var screenDirection = SettingScreenIdentify.Settings
  @IBOutlet weak var lblTitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

      tblSettings.tableFooterView =  UIView.init(frame: .zero)
      tblSettings.layoutMargins = .zero
      
      tblSettings.rowHeight = 60
      tblSettings.estimatedRowHeight = UITableView.automaticDimension
      
      if screenDirection == .Settings{
        lblTitle.text = "Settings"
      }else if screenDirection == .About_Us{
        lblTitle.text = "About Us"
      }else if screenDirection == .Media{
        lblTitle.text = "Media"
      }else if screenDirection == .Other_Videos{
        lblTitle.text = "Other Videos"
      }else{
        //What's New
        lblTitle.text = "What's New"
      }
      
    }
  
  //MARK: Button Event
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
extension SettingsVC : UITableViewDelegate, UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if screenDirection == .Settings{
      return 6
    }else  if screenDirection == .About_Us{
      return 1
    }else if screenDirection == .Media{
      return 7
    }else if screenDirection == .Other_Videos{
      return 3
    }else{
      //What's New
      return 4
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
    let cellIdentifier = "SettingsTableViewCell"
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SettingsTableViewCell  else {
      fatalError("The dequeued cell is not an instance of MealTableViewCell.")
    }
    
    if screenDirection == .Settings{
      if indexPath.row == 0{
        cell.lblTitle.text = "About Us"
        
      }else if indexPath.row == 1{
        cell.lblTitle.text = "About The App"
        
      }else if indexPath.row == 2{
        cell.lblTitle.text = "Feedback"
        
      }else if indexPath.row == 3{
        cell.lblTitle.text = "Share The App"
        
      }else if indexPath.row == 4{
        cell.lblTitle.text = "SND Internet Radio"
        
      }
      else if indexPath.row == 5{
        cell.lblTitle.text = "FAQ"
        
      }

    }else if screenDirection == .About_Us{
      if indexPath.row == 0{
        cell.lblTitle.text = "About Bapu"
      }
    }else if screenDirection == .Media{
      if indexPath.row == 0{
        cell.lblTitle.text = "Photos"
        
      }else if indexPath.row == 1{
        cell.lblTitle.text = "Sher O Shayari"
        
      }else if indexPath.row == 2{
        cell.lblTitle.text = "Bapu's Thought"
        
      }else if indexPath.row == 3{
        cell.lblTitle.text = "Other Videos"
        
      }else if indexPath.row == 4{
        cell.lblTitle.text = "Audios"
        
      }else if indexPath.row == 5{
        cell.lblTitle.text = "Press Articles"
      }
      else {
        cell.lblTitle.text = "SND Internet Radio"

      }

    }else if screenDirection == .Other_Videos{
      if indexPath.row == 0{
        cell.lblTitle.text = "Interview"
        
      }else if indexPath.row == 1{
        cell.lblTitle.text = "Prasang"
        
      }
      else {
        cell.lblTitle.text = "Speech"
      }
    }else{
      //What's New
      if indexPath.row == 0{
        cell.lblTitle.text = "Text"
        
      }else if indexPath.row == 1{
        cell.lblTitle.text = "Photo"
        
      }
      else if indexPath.row == 2{
        cell.lblTitle.text = "Video"
        
      }
      else {
        cell.lblTitle.text = "Audio"
      }
    }
    
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if screenDirection == .Settings{
      if indexPath.row == 0{
        //About Us
        
        let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        vc.screenDirection = .About_Us
        navigationController?.pushViewController(vc, animated:  true)
        
      }else if indexPath.row == 1{
        //About The App
        
        let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AboutTheAppVC") as! AboutTheAppVC
        vc.strTitle = "About The App"
        navigationController?.pushViewController(vc, animated:  true)
        
      }else if indexPath.row == 2{
        //Feedback
        
        let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FeedbackVC") as! FeedbackVC
        navigationController?.pushViewController(vc, animated:  true)
        
      }else if indexPath.row == 3{
       
        DispatchQueue.main.async {
          // text to share
          let text = "This message has been sent via the Morari Bapu App.\nYou can download it too from this link: https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
          
          // set up activity view controller
          let textToShare = [ text ]
          let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
          activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
          
          // exclude some activity types from the list (optional)
          activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
          
            self.present(activityViewController, animated: true, completion: nil)
          
        }
       
      }else if indexPath.row == 4{
        self.view.makeToast("Coming Soon", duration: 3.0, position: .bottom)
      }
      else if indexPath.row == 5{
        let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FaqVC") as! FaqVC
        navigationController?.pushViewController(vc, animated:  true)
      }
      
    }else if screenDirection == .About_Us{
      //About Us
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "AboutTheAppVC") as! AboutTheAppVC
      vc.strTitle = "About Bapu"
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if screenDirection == .Media{
    }else if screenDirection == .Other_Videos{
    }else{
      //What's New
    }
  
  }
}


//MARK: Menu Navigation Delegate
extension SettingsVC: MenuNavigationDelegate{
  
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
