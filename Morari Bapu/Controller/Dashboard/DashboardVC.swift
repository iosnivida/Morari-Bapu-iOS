//
//  ViewController.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 01/10/18.
//  Copyright © 2018 Bhavin Chauhan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DashboardVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.getSliderList()
        }
    }

    
    //MARK: Api Call
    func getSliderList(){
        
    
        WebServices().CallGlobalAPI(url: WebService_Slider_Dashboard,headers: [:], parameters: [:], HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
            
            if(jsonResponce?.error != nil) {
                
                var errorMess = jsonResponce?.error?.localizedDescription
                errorMess = MESSAGE_Err_Service
                Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
            }
            else {
                
//                if jsonResponce!["status"].stringValue == "Success"{
//                    self.upcomingAppointments()
//                }
//                else if jsonResponce!["status"].stringValue == "Error"{
//                    if jsonResponce!["errorCode"].stringValue == "401"{
//                        Utility.logoutUI()
//                    }else{
//                        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: jsonResponce!["message"].stringValue)
//                    }
//                }
            }
        }
    }
    //MARK: Button Event
    @IBAction func btnMenu(_ sender: Any) {
        
        Utility.menu_Show(onViewController: self)
        
    }

}

