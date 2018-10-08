//
//  KathaChopaiDetailsVC.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 08/10/18.
//  Copyright © 2018 Bhavin Chauhan. All rights reserved.
//

import UIKit
import SwiftyJSON

class KathaChopaiDetailsVC: UIViewController {

  @IBOutlet weak var lblTitle: UILabel!
  @IBOutlet weak var lblSubTitle: UILabel!
  @IBOutlet weak var btnShare: UIButton!
  @IBOutlet weak var btnFavourite: UIButton!
  @IBOutlet weak var lblDate: UILabel!
  @IBOutlet weak var lblDescription1: UILabel!
  @IBOutlet weak var lblDescription2: UILabel!
  @IBOutlet weak var lblDescription3: UILabel!

  var arrKathaDetails = [String:JSON]()
  var strTitle = String()
  
    override func viewDidLoad() {
        super.viewDidLoad()

      lblTitle.text = strTitle
      
      if lblTitle.text == "Katha Chopai"{
       
        lblSubTitle.text = arrKathaDetails["title"]!.stringValue
        lblDate.text = Utility.dateToString(dateStr: arrKathaDetails["from_date"]!.stringValue, strDateFormat: "dd MMM yyyy")
        lblDescription1.text = arrKathaDetails["katha_english"]!.stringValue
        lblDescription2.text = arrKathaDetails["katha_hindi"]!.stringValue
        lblDescription3.text = arrKathaDetails["description"]!.stringValue

      }else{
        
        lblSubTitle.text = arrKathaDetails["title"]!.stringValue
        lblDate.text = Utility.dateToString(dateStr: arrKathaDetails["date"]!.stringValue, strDateFormat: "dd MMM yyyy")
        lblDescription1.text = arrKathaDetails["katha_english"]!.stringValue
        lblDescription2.text = arrKathaDetails["katha_hindi"]!.stringValue
        lblDescription3.text = arrKathaDetails["description"]!.stringValue
   
      }
      
    }
  
  //MARK : Button Event
  @IBAction func btnBack(_ sender: Any) {
    self.navigationController?.popViewController(animated:true)
  }
  
  @IBAction func backToHome(_ sender: Any) {
    self.navigationController?.popToRootViewController(animated: true)
  }
}
