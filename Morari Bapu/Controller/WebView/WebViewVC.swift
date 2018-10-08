//
//  WebViewVC.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 04/10/18.
//  Copyright © 2018 Bhavin Chauhan. All rights reserved.
//

import UIKit
import SVProgressHUD

enum WebViewScreen {
  
  case Moraribapu_Youtube_Channel
  case Sangeet_Ni_Duniya_Online_Shop
  
}


class WebViewVC: UIViewController {

  var screenDirection = WebViewScreen.Moraribapu_Youtube_Channel
  @IBOutlet weak var webView: UIWebView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      webView.isOpaque = false;
      webView.backgroundColor = UIColor.clear
      
      if screenDirection == .Moraribapu_Youtube_Channel{
        
        DispatchQueue.main.async {
          let url = URL(string: "http://doggietheapp.com/doggieprivacy.html")
          self.webView.loadRequest(NSURLRequest(url: url!) as URLRequest)
        }
      }
      else if screenDirection == .Sangeet_Ni_Duniya_Online_Shop{
        DispatchQueue.main.async {
          let url = URL(string: "http://www.sangeetniduniya.net/")
          self.webView.loadRequest(NSURLRequest(url: url!) as URLRequest)
        }
      }
  }
  
  //MARK : Button Event
  @IBAction func btnBack(_ sender: Any) {
    //self.navigationController?.popViewController(animated:true)
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func backToHome(_ sender: Any) {
    self.navigationController?.popToRootViewController(animated: true)
  }

}

extension WebViewVC : UIWebViewDelegate{
  
  func webViewDidStartLoad(_ webView: UIWebView) {
    SVProgressHUD.show() // Simple Show Loader with Loading Message
    
  }
  
  func webViewDidFinishLoad(_ webView: UIWebView) {
    SVProgressHUD.dismiss()
    
  }
  
}
