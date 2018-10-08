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

class KathaEBookVC: UIViewController {

  var arrKathaEBook  = [JSON]()

  @IBOutlet weak var tblKathaEBook: UITableView!
  
  override func viewDidLoad() {
        super.viewDidLoad()

    tblKathaEBook.tableFooterView =  UIView.init(frame: .zero)
    tblKathaEBook.layoutMargins = .zero
    
    tblKathaEBook.rowHeight = 80
    tblKathaEBook.estimatedRowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    
    DispatchQueue.main.async {
      self.getKathaEBook()
    }
    
    }
    
  //MARK: Api Call
  func getKathaEBook(){
    
    let param = ["id" : "1",
      "app_id":Utility.getDeviceID(),
      "favourite_for":"1"] as NSDictionary
    
    WebServices().CallGlobalAPI(url: WebService_Katha_EBook,headers: [:], parameters: param, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
      
      if(jsonResponce?.error != nil) {
        
        var errorMess = jsonResponce?.error?.localizedDescription
        errorMess = MESSAGE_Err_Service
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
      }
      else {
        
        if jsonResponce!["status"].stringValue == "true"{
          self.arrKathaEBook = jsonResponce!["data"].arrayValue
          
          if self.arrKathaEBook.count != 0{
            
            DispatchQueue.main.async {
              self.tblKathaEBook .reloadData()
              Utility.tableNoDataMessage(tableView: self.tblKathaEBook, message: "", messageColor: UIColor.black, displayMessage: .Center)
            }
          }
          else
          {
            
            DispatchQueue.main.async {
              self.tblKathaEBook .reloadData()
              Utility.tableNoDataMessage(tableView: self.tblKathaEBook, message: "No E-Book", messageColor: UIColor.black, displayMessage: .Center)

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
  }
  
  @IBAction func btnHanumanChalisha(_ sender: Any) {
  }
  
}

//MARK TableView Delegate
extension KathaEBookVC : UITableViewDelegate, UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return arrKathaEBook.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
      let cellIdentifier = "KathaEBookTableViewCell"
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? KathaEBookTableViewCell  else {
        fatalError("The dequeued cell is not an instance of MealTableViewCell.")
      }

    let data = arrKathaEBook[indexPath.row]

    cell.lblTitle.text = data["title"].stringValue
    cell.lblDescription1.text = data["android_english"].stringValue
    cell.lblDescription2.text = data["android_hindi"].stringValue
    cell.lblDescription3.text = data["android_gujarati"].stringValue

      return cell
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let data = arrKathaEBook[indexPath.row]

    if let url = data["android_gujarati"].url {
      UIApplication.shared.open(url, options: [:])
    }
    
  }

}
