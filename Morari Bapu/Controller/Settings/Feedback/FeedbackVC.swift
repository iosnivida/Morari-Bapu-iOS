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

class FeedbackVC: UIViewController {
  
  @IBOutlet weak var txtName: UITextField!
  @IBOutlet weak var txtContactNo: UITextField!
  @IBOutlet weak var txtEmail: UITextField!
  @IBOutlet weak var txtComments: UITextView!
  
  @IBOutlet weak var lblNotes: UILabel!
  
  var strTitle = String()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    
      self.txtName.layer.borderWidth = 0.5
      self.txtName.layer.borderColor = UIColor.darkGray.cgColor
      
      self.txtContactNo.layer.borderWidth = 0.5
      self.txtContactNo.layer.borderColor = UIColor.darkGray.cgColor
      
      self.txtEmail.layer.borderWidth = 0.5
      self.txtEmail.layer.borderColor = UIColor.darkGray.cgColor
      
      self.txtComments.layer.borderWidth = 0.5
      self.txtComments.layer.borderColor = UIColor.darkGray.cgColor
      
      self.txtName.setLeftPaddingPoints(8)
      self.txtContactNo.setLeftPaddingPoints(8)
      self.txtEmail.setLeftPaddingPoints(8)
    
    
    DispatchQueue.main.async {
      self.lblNotes.text = "Note: \nThis email address is not intended for messages and/or any communication for Bapu. The emails shall not be replied in that case. This email address is only for the purpose of getting feedback for this app \nSadguru Kripa Hi Kevalam \nShree Chitrakut Dham Trust"
      
      self.hideKeyboardWhenTappedAround()
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
  
  @IBAction func btnSubmit(_ sender: Any) {
    
    if txtName.text?.count == 0{
      Utility().showAlertMessage(vc: self, titleStr: "", messageStr: "Please Enter Fullname")
    }
    else if txtContactNo.text?.count == 0{
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: "Please Enter Contact No")
    }
    else if txtContactNo.text?.count != 10{
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: "Please Enter Valid Contact No")
    }
    else if txtEmail.text?.count == 0{
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: "Please Enter Email")
    }
    else if !Utility.isValidEmail(testStr: txtEmail.text!){
      Utility().showAlertMessage(vc: self, titleStr: "", messageStr: "Please Enter Valid Email")
    }
    else if txtComments.text?.count == 0{
      Utility().showAlertMessage(vc: self, titleStr: "", messageStr: "Please Enter Comment")
    }
    else {
      self.view.endEditing(true)

      
      let param = ["name":txtName.text!,
                   "mobile" :txtContactNo.text!,
                   "email" :txtEmail.text!,
                   "comment" :txtComments.text!] as [String : Any]
      
      WebServices().CallGlobalAPI(url: WebService_Feedback,headers: [:], parameters: param as NSDictionary, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in

        
        self.view.endEditing(true)
        
        if(jsonResponce?.error != nil) {
          
          var errorMess = jsonResponce?.error?.localizedDescription
          errorMess = MESSAGE_Err_Service
          Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
        }
        else {
          
          if jsonResponce!["status"].stringValue == "true"{
            
            self.txtName.text = ""
            self.txtComments.text = ""
            self.txtContactNo.text = ""
            self.txtEmail.text = ""
            
            self.view.makeToast(jsonResponce!["message"].stringValue)
            
          }
          else if jsonResponce!["status"].stringValue == "Error"{
            Utility().showAlertMessage(vc: self, titleStr: "", messageStr: jsonResponce!["message"].stringValue)
          }
        }
      }
    }
  }
  
  @IBAction func btnRateThisApp(_ sender: Any) {
    
    let reviewURL = "itms-apps://itunes.apple.com/us/app/apple-store/id1050576066?mt=8"

    
    if let url = URL(string: reviewURL), UIApplication.shared.canOpenURL(url) {
      if #available(iOS 10.0, *) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      } else {
        UIApplication.shared.openURL(url)
      }
    }
    
  }
}


//MARK:- Menu Navigation Delegate
extension FeedbackVC: MenuNavigationDelegate{
  
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

//MARK:-- TexrField Delegate
extension FeedbackVC: UITextFieldDelegate{
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == txtName{
      return txtContactNo.becomeFirstResponder()
    }
    else if textField == txtContactNo{
      return txtEmail.becomeFirstResponder()
    }
    else if textField == txtEmail{
      return txtComments.becomeFirstResponder()
    }
    else if textField == txtComments{
      return txtComments.resignFirstResponder()
    }
    else{
      return txtComments.resignFirstResponder()
    }
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField == txtContactNo {
      guard let text = textField.text else { return true }
      let newLength = text.count + string.count - range.length
      return newLength <= 10
    }
    return true;
  }
  
}

//MARK:-- Keyborad Hide
extension FeedbackVC {
  
  func hideKeyboardWhenTappedAround() {
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    view.addGestureRecognizer(tapGesture)
    
  }
  
  @objc func hideKeyboard() {
    view.endEditing(true)
  }
  
}


extension UITextField {
  func setLeftPaddingPoints(_ amount:CGFloat){
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
    self.leftView = paddingView
    self.leftViewMode = .always
  }
}
