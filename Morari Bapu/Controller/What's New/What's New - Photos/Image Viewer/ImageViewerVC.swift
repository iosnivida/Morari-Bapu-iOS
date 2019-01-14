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


class ImageViewerVC: UIViewController, UIScrollViewDelegate {
  
  @IBOutlet weak var cvImageViewwer: UICollectionView!
  
  var arrImages : [JSON] = []
  
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
    
    cell.btnDownload.addTarget(self, action: #selector(btnDownload), for: UIControl.Event.touchUpInside)

    cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)

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

    
    if let url = URL(string: "\(BASE_URL_IMAGE)\(dict["image_file"].stringValue)"),
      let data = try? Data(contentsOf: url),
      let image = UIImage(data: data) {
      UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
      self.view.makeToast("Download Complete", duration: 1.5, position: .bottom)

    }
    

  }
  
  @IBAction func btnShare(_ sender: UIButton) {
    
   
  }
  
}
