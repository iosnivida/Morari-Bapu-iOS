//
//  ImageViewerVC.swift
//  Doggie
//
//  Created by Bhavin Chauhan on 06/09/18.
//  Copyright © 2018 Bhavin Chauhan. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import MobileCoreServices
import AVFoundation
import Photos

enum ImageViewerScreenIdentify {
  case Whats_New_Photos
  case Media_Photos
}

protocol ImageViewerDelegate: class {
  func result(_ favouritesList: NSMutableArray)
}


class ImageViewerVC: UIViewController, UIScrollViewDelegate {
  
  @IBOutlet weak var cvImageViewwer: UICollectionView!
  
  var screenDirection = ImageViewerScreenIdentify.Whats_New_Photos
  weak var delegate: ImageViewerDelegate?

  var arrImages : [JSON] = []
  var arrFavourites = NSMutableArray()

  var indexPosition = IndexPath()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    cvImageViewwer.maximumZoomScale = 5.0;
    cvImageViewwer.minimumZoomScale = 1.0;
    cvImageViewwer.clipsToBounds = false;
    cvImageViewwer.delegate = self;
    
    
      if arrImages.count != 0{
        DispatchQueue.main.async {
          self.cvImageViewwer.reloadData()
          self.cvImageViewwer.scrollToItem(at: self.indexPosition, at: .centeredHorizontally, animated: false)

          Utility.collectionViewNoDataMessage(collectionView: self.cvImageViewwer, message: "", textColor: UIColor.white)
        }
      }else{
        DispatchQueue.main.async {
          self.cvImageViewwer.reloadData()
          Utility.collectionViewNoDataMessage(collectionView: self.cvImageViewwer, message: "No Photos", textColor: UIColor.white)
        }
      }
    }

  //MARK:-- Button Event
  @IBAction func btnBack(_ sender: Any) {
    self.navigationController?.popViewController(animated:true)
  }
  
  @IBAction func btnClose(_ sender: Any) {
    Utility.image_Viewer_Hide(onViewController: self)
  }
}

// MARK: CollectionView Delegate
extension ImageViewerVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return arrImages.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewerCollectionViewCell", for: indexPath) as! ImageViewerCollectionViewCell
    
    var dict = arrImages[indexPath.row]
    
    let placeHolder = UIImage(named: "chat_placeholder")
    cell.imgView.kf.indicatorType = .activity
    cell.imgView.kf.setImage(with: URL(string: "\(BASE_URL_IMAGE)\(dict["image_file"].stringValue)"), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
    
    cell.btnDownload.tag = indexPath.row
    cell.btnShare.tag = indexPath.row
    cell.btnFavourites.tag = indexPath.row
    
    cell.btnFavourites.imageColorChange(imageColor: .white)
    
    cell.btnDownload.addTarget(self, action: #selector(btnDownload), for: UIControl.Event.touchUpInside)
    cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
    cell.btnFavourites.addTarget(self, action: #selector(btnFavourites), for: UIControl.Event.touchUpInside)
    
    let predicate: NSPredicate = NSPredicate(format: "SELF contains[cd] %@", dict["id"].stringValue)
    let result = self.arrFavourites.filtered(using: predicate)
    
    if result.count != 0{
      cell.btnFavourites.setImage(UIImage(named: "favorite"), for: .normal)
      cell.btnFavourites.imageColorChange(imageColor: .white)
    }else{
      cell.btnFavourites.setImage(UIImage(named: "unfavorite"), for: .normal)
      cell.btnFavourites.imageColorChange(imageColor: .white)
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    if Device.IS_IPHONE_X{
      return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    else{
      return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    
  }
  
  @IBAction func btnDownload(_ sender: UIButton) {

    var dict = arrImages[sender.tag]

    //Photos
    let photos = PHPhotoLibrary.authorizationStatus()
    if photos == .notDetermined {
      PHPhotoLibrary.requestAuthorization({status in
        if status == .authorized{
          if let url = URL(string: "\(BASE_URL_IMAGE)\(dict["image_file"].stringValue)"),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            self.view.makeToast("Download Complete", duration: 1.5, position: .bottom)
          }
        }else if status == .denied{
          
          DispatchQueue.main.async {
            let alert = UIAlertController(title: "", message: "You want to save this image. Please go to setting enable to photos permission in the app", preferredStyle: UIAlertController.Style.alert);
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive , handler: { (alert: UIAlertAction!) in
              //--> Dismiss Alert
            }))
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { (alert: UIAlertAction!) in
              
              let settingsUrl = NSURL(string:UIApplication.openSettingsURLString)
              if let url = settingsUrl {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
              }
              
            }))
            
            self.present(alert, animated: true, completion: nil)
          }
          
        }
      })
    }else if photos == .denied{
      
      DispatchQueue.main.async {
        let alert = UIAlertController(title: "", message: "You want to save this image. Please go to setting enable to permission read and write in the app", preferredStyle: UIAlertController.Style.alert);
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive , handler: { (alert: UIAlertAction!) in
          //--> Dismiss Alert
        }))
        alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { (alert: UIAlertAction!) in
          
          let settingsUrl = NSURL(string:UIApplication.openSettingsURLString)
          if let url = settingsUrl {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
          }
          
        }))
        
        self.present(alert, animated: true, completion: nil)
      }
      
    }else if photos == .authorized{
      if let url = URL(string: "\(BASE_URL_IMAGE)\(dict["image_file"].stringValue)"),
        let data = try? Data(contentsOf: url),
        let image = UIImage(data: data) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        self.view.makeToast("Download Complete", duration: 1.5, position: .bottom)
      }
    }
    

  }
  
  
  @IBAction func btnShare(_ sender: UIButton) {
    
      var dict = arrImages[sender.tag]
    
      let imageUrl = URL(string: "\(BASE_URL_IMAGE)\(dict["image_file"].stringValue)")
      let text = "\n\nThis message has been sent via the Morari Bapu App.  You can download it too from this link : https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
    
      let data = try? Data(contentsOf: imageUrl!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
      let image = UIImage(data: data!)
      let imageShare = [image as Any  ,text] as [Any]
    
    let activityViewController = UIActivityViewController(activityItems: imageShare as [Any] , applicationActivities: nil)
      activityViewController.popoverPresentationController?.sourceView = self.view
      
      DispatchQueue.main.async {
        self.present(activityViewController, animated: true, completion: nil)
      }
     
  }
  
  @IBAction func btnFavourites(_ sender: UIButton) {
 
    if arrImages.count != 0{
      
      let data = arrImages[sender.tag]
     
      var paramater = NSDictionary()
      
      if screenDirection == .Whats_New_Photos{
        //Whats_New_Photos
        
        paramater = ["app_id":Utility.getDeviceID(),
                     "favourite_for":"11",
                     "favourite_id":data["id"].stringValue]
        
      }else{
        //Media_Photos
        
        paramater = ["app_id":Utility.getDeviceID(),
                     "favourite_for":"12",
                     "favourite_id":data["id"].stringValue]
        
      }
      
      WebServices().CallGlobalAPI(url: WebService_Favourite,headers: [:], parameters: paramater as NSDictionary, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
        
        if(jsonResponce?.error != nil) {
          
          var errorMess = jsonResponce?.error?.localizedDescription
          errorMess = MESSAGE_Err_Service
          Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
        }
        else {
          
          if jsonResponce!["status"].stringValue == "true"{
            
            if jsonResponce!["message"].stringValue == "Added in your favourite list"{
              
              self.arrFavourites.add(data["id"].stringValue)
              self.cvImageViewwer.reloadData()
              self.delegate?.result(self.arrFavourites)
             
            }else{
              self.arrFavourites.removeObject(at: self.arrFavourites.index(of: data["id"].stringValue))
              self.cvImageViewwer.reloadData()
              self.delegate?.result(self.arrFavourites)
              
            }

            
          }
          else {
            Utility().showAlertMessage(vc: self, titleStr: "", messageStr: jsonResponce!["message"].stringValue)
          }
        }
      }
      
    }
    
  }
}
