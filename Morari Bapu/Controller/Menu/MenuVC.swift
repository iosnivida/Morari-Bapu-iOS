//
//  DropdownVC.swift
//  Doggie
//
//  Created by Bhavin Chauhan on 07/08/18.
//  Copyright © 2018 Bhavin Chauhan. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import IQKeyboardManagerSwift
import Kingfisher
import SwiftyUserDefaults

protocol MenuNavigationDelegate: class {
  func SelectedMenu(ScreenName: String?)
}


class MenuVC: UIViewController {
    
    @IBOutlet var cvMenu: UICollectionView!
    
    var arrMenu = NSArray()
    weak var delegate: MenuNavigationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
 
   
}

// MARK: CollectionView Delegate
extension MenuVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
      return 17
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath) as! MenuCollectionViewCell
            
            cell.imgMenu.image = UIImage(named: "menu_\(indexPath.row+1)")
        
            return cell
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            if UIDevice.current.userInterfaceIdiom == .pad{
                let yourWidth = (collectionView.bounds.width - 40) / 3.0
                let yourHeight = yourWidth
                
                return CGSize(width: yourWidth, height: yourHeight - 15)
            }
            else{
                let yourWidth = (collectionView.bounds.width - 40) / 3.0
                let yourHeight = yourWidth
                
                return CGSize(width: yourWidth, height: yourHeight - 15)
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      

        if indexPath.row == 0{
            //Home
        }else if indexPath.row == 1{
            //Katha Chopai
        }else if indexPath.row == 2{
        //Ram Charitra Manas
        
        }else if indexPath.row == 3{
        //Upcoing Katha
        
        }else if indexPath.row == 4{
            //Quotes
        
        }else if indexPath.row == 5{
            //Daily Katha Clip
        
        }else if indexPath.row == 6{
            //Live Katha Audio
        
        }else if indexPath.row == 7{
            //You Tube Channel
//

          let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
          let vc = storyboard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
          vc.screenDirection = .Moraribapu_Youtube_Channel
          self.present(vc, animated: false, completion: nil)

        }else if indexPath.row == 8{
        //Live Katha Video
        
        }
        else if indexPath.row == 9{
            //Media
        
        }else if indexPath.row == 10{
            //What's New
        }else if indexPath.row == 11{
            //Sangeet Ni Duniya
        
        }else if indexPath.row == 12{
            //Setting
        }else if indexPath.row == 13{
            //Search
        }else if indexPath.row == 14{
            //Favourites
        }else if indexPath.row == 15{
            //Events
        
        }else if indexPath.row == 16{
        //Katha Ebook
        }


    }
}

