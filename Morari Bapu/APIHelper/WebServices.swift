//
//  WebServices.swift
//  GlobalAPICall
//
//  Created by Ravi on 06/07/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
import Alamofire
import SwiftyJSON
import SVProgressHUD


let reachability = Reachability()!

class WebServices: NSObject
{
    var operationQueue = OperationQueue()
    
    // Call with Raw/Json Parameter
    func CallGlobalAPI(url:String, headers:HTTPHeaders,parameters:NSDictionary, HttpMethod:String, ProgressView:Bool, responseDict:@escaping ( _ jsonResponce:JSON?, _ strErrorMessage:String) -> Void )  {
        
        //print("URL: \(url)")
        //print("Headers: \n\(headers)")
        //print("Parameters: \n\(parameters)")
        
        //Loader Required or Not
        if ProgressView == true {
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
            SVProgressHUD.setForegroundColor(UIColor.black)
            SVProgressHUD.show() // Simple Show Loader with Loading Message
        }
        
        let operation = BlockOperation.init {
            DispatchQueue.global(qos: .background).async {
                
                //Internet Checking
                if self.internetChecker(reachability: Reachability()!) {
                    if (HttpMethod == "POST" || HttpMethod == "PATCH" || HttpMethod == "DELETE") {
                        var req = URLRequest(url: try! url.asURL())
                        req.httpMethod = HttpMethod
                        req.allHTTPHeaderFields = headers
                        req.setValue("application/json", forHTTPHeaderField: "content-type")
                        req.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
                        req.timeoutInterval = 30 // 10 secs
                        
                        Alamofire.request(req).responseJSON { response in
                            
                            switch (response.result)
                            {
                            case .success:
                                
                                if((response.result.value) != nil) {
                                    let jsonResponce = JSON(response.result.value!)
                                    
                                     //print("Responce: \n\(jsonResponce)")
                                    
                                    DispatchQueue.main.async {
                                        responseDict(jsonResponce,"")
                                        SVProgressHUD.dismiss()
                                        
                                    }
                                }
                                
                                break
                                
                            case .failure(let error):
                                
                                let message : String
                                
                                if let httpStatusCode = response.response?.statusCode {
                                    switch(httpStatusCode) {
                                    case 400:
                                        message = "Username or password not provided"
                                    case 401:
                                        message = "The email/password is invalid"
                                        // print("!Error status code: %d",httpStatusCode)
                                        DispatchQueue.main.async {
                                            SVProgressHUD.dismiss()
                                            responseDict([:],message)
                                            
                                        }
                                    default: break
                                    }
                                } else {
                                    message = error.localizedDescription
                                    
                                    let jsonError = JSON(response.result.error!)
                                    DispatchQueue.main.async {
                                        SVProgressHUD.dismiss()
                                        responseDict(jsonError,"")
                                    }
                                }
                                break
                            }
                        }
                    }
                    else if (HttpMethod == "GET") {
                        var req = URLRequest(url: try! url.asURL())
                        req.httpMethod = HttpMethod
                        req.allHTTPHeaderFields = headers
                        req.setValue("application/json", forHTTPHeaderField: "content-type")
                        req.timeoutInterval = 30 // 10 secs
                        
                        Alamofire.request(req).responseJSON { response in
                            
                            switch (response.result)
                            {
                            case .success:
                                
                                if((response.result.value) != nil) {
                                    let jsonResponce = JSON(response.result.value!)
                                    
                                    //print("Responce: \n\(jsonResponce)")
                                    
                                    DispatchQueue.main.async {
                                        SVProgressHUD.dismiss()
                                        responseDict(jsonResponce,"")
                                    }
                                }
                                
                                break
                                
                            case .failure(let error):
                                
                                let message : String
                                
                                if let httpStatusCode = response.response?.statusCode {
                                    switch(httpStatusCode) {
                                    case 400:
                                        message = "Username or password not provided"
                                    case 401:
                                        message = "The email/password is invalid"
                                        // print("!Error status code: %d",httpStatusCode)
                                        DispatchQueue.main.async {
                                            SVProgressHUD.dismiss()
                                            responseDict([:],message)
                                            
                                        }
                                    default: break
                                    }
                                } else {
                                    message = error.localizedDescription
                                    
                                    let jsonError = JSON(response.result.error!)
                                    DispatchQueue.main.async {
                                        SVProgressHUD.dismiss()
                                        responseDict(jsonError,"")
                                    }
                                }
                                break
                            }
                        }
                    }
                }
                else {
                    SVProgressHUD.dismiss()
                    self.showAlertMessage(titleStr: "Error!", messageStr: MESSAGE_Err_Network)
                }
            }
        }
        operation.queuePriority = .normal
        operationQueue.addOperation(operation)
        
    }

    
    func CallImagesUploadAPI(imgData:Data, url:String,strBody:NSString, headers:HTTPHeaders, HttpMethod:String, ProgressView:Bool, responseImageUrl:@escaping ( _ servreImgUrl:String ) -> Void )  {
        
        //Loader Required or Not
        if ProgressView == true {
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
            SVProgressHUD.setForegroundColor(UIColor.black)
            SVProgressHUD.show() // Simple Show Loader with Loading Message
        }
        
        Alamofire.upload(imgData, to: url, method: .put, headers: headers)
            .responseData {
                response in
                
                SVProgressHUD.dismiss()

                guard response.response != nil else {
                    print("Something went wrong uploading")
                    return
                }
                
                let imgUrl = url.components(separatedBy: "?")[0]
            
                if imgUrl != ""{
                    responseImageUrl(imgUrl)
                }
        }
    }
    
    //MARK: Internet Avilability
    func internetChecker(reachability: Reachability) -> Bool {
        // print("\(reachability.description) - \(reachability.connection)")
        var check:Bool = false
        
        if reachability.connection == .wifi {
            check = true
        }
        else if reachability.connection == .cellular {
            check = true
        }
        else
        {
            check = false
        }
        return check
    }
    
    // MARK: ProgressView
    func ProgressViewShow() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name("loaderStart"), object: nil)
        }
    }
    
    func ProgressViewHide() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name("loaderStop"), object: nil)
        }
    }
    // MARK: Show Alert Message
    func showAlertMessage(titleStr:String, messageStr:String) -> Void {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert);
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            UIApplication.shared.delegate?.window!?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
}

