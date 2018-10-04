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
  case Privacy
  case YouTubeChannel
}


class WebViewVC: UIViewController {

  var screenDirection = WebViewScreen.Privacy
  @IBOutlet weak var webView: UIWebView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      webView.isOpaque = false;
      webView.backgroundColor = UIColor.clear
      
      if screenDirection == .Privacy{
        
        DispatchQueue.main.async {
          let url = URL(string: "http://doggietheapp.com/doggieprivacy.html")
          self.webView.loadRequest(NSURLRequest(url: url!) as URLRequest)
        }
      }
      else if screenDirection == .YouTubeChannel{
        
        DispatchQueue.main.async {
          let url = URL(string: "http://doggietheapp.com/doggieprivacy.html")
          self.webView.loadRequest(NSURLRequest(url: url!) as URLRequest)
        }
      }
      
        // Do any additional setup after loading the view.
    }
  
  //MARK : Button Event
  @IBAction func btnBack(_ sender: Any) {
    self.navigationController?.popViewController(animated:true)
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
