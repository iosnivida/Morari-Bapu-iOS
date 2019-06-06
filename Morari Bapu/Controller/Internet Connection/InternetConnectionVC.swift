
//
//  InternetConnectionVC.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 18/02/19.
//  Copyright © 2019 Bhavin Chauhan. All rights reserved.
//

import UIKit

protocol InternetConnectionDelegate: class {
  func reloadPage()
}

class InternetConnectionVC: UIViewController {

    weak var delegate: InternetConnectionDelegate?
  
    override func viewDidLoad() {
        super.viewDidLoad()

      // Add reachability observer
      if let reachability = AppDelegate.sharedAppDelegate()?.reachability
      {
        NotificationCenter.default.addObserver( self, selector: #selector( self.reachabilityChanged ),name: Notification.Name.reachabilityChanged, object: reachability )
      }
      
    }
  
  @objc private func reachabilityChanged( notification: NSNotification )
  {
    guard let reachability = notification.object as? Reachability else
    {
      return
    }
    
    if reachability.connection == .wifi || reachability.connection == .cellular {
      
      delegate?.reloadPage()
      Utility.internet_connection_hide(onViewController: self)
      
    }
    
  }

    

}
