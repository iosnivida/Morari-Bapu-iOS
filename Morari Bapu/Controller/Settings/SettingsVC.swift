//
//  SettingsVC.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 07/10/18.
//  Copyright © 2018 Bhavin Chauhan. All rights reserved.
//

import UIKit


enum SettingScreenIdentify {
  case Settings
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
  }
  
  @IBAction func btnHanumanChalisha(_ sender: Any) {
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
    }else if screenDirection == .Media{
    }else if screenDirection == .Other_Videos{
    }else{
      //What's New
    }
  
  }
}
