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
import CenteredCollectionView
import Kingfisher


class DashboardVC: UIViewController {


    var arrSlider  = [JSON]()
    var arrHome  = [JSON]()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var cvSlider: UICollectionView!
    @IBOutlet var btnDown: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var constraintHeightTableView: NSLayoutConstraint!
  
  @IBOutlet weak var tblHome: UITableView!
  
    var cellPercentWidth: CGFloat = 0.8
    
    // A reference to the `CenteredCollectionViewFlowLayout`.
    // Must be aquired from the IBOutlet collectionView.
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        tblHome.tableFooterView = UIView.init(frame: .zero)
        tblHome.layoutMargins = .zero
      
        tblHome.rowHeight = 350
      tblHome.estimatedRowHeight = UITableView.automaticDimension
      
        if UIDevice.current.userInterfaceIdiom != .pad{
            cellPercentWidth = 0.6
            
        }else{
            cellPercentWidth = 0.9
            
        }
        
        btnDown.imageColorChange(imageColor: UIColor.black)
        scrollView.isScrollEnabled = false
        pageControl.numberOfPages = 0
        
        // Get the reference to the `CenteredCollectionViewFlowLayout` (REQURED STEP)
        centeredCollectionViewFlowLayout = (cvSlider.collectionViewLayout as! CenteredCollectionViewFlowLayout)
        
        // Modify the collectionView's decelerationRate (REQURED STEP)
        cvSlider.decelerationRate = UIScrollView.DecelerationRate.fast
        
        // Assign delegate and data source
        cvSlider.delegate = self
        cvSlider.dataSource = self
        
        // Configure the required item size (REQURED STEP)
        centeredCollectionViewFlowLayout.itemSize = CGSize(
            width: view.bounds.width * cellPercentWidth,
            height: cvSlider.frame.height
        )
        
        if UIDevice.current.userInterfaceIdiom != .pad{
            centeredCollectionViewFlowLayout.minimumLineSpacing = 10
            
        }else{
            centeredCollectionViewFlowLayout.minimumLineSpacing = 20
            
        }
        // Configure the optional inter item spacing (OPTIONAL STEP)
        
        // Get rid of scrolling indicators
        cvSlider.showsVerticalScrollIndicator = false
        cvSlider.showsHorizontalScrollIndicator = false
        
        pageControl.numberOfPages = 0
        pageControl.currentPage = 0
        
        DispatchQueue.main.async {
            self.getSliderList()
        }
    }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    DispatchQueue.main.async {
      self.constraintHeightTableView.constant = self.tblHome.contentSize.height
      self.view.layoutIfNeeded()
      
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
                
                if jsonResponce!["status"].stringValue == "true"{
                    self.getHome()
                    self.arrSlider = jsonResponce!["data"].arrayValue

                    if self.arrSlider.count != 0{
                        
                        DispatchQueue.main.async {
                            self.pageControl.numberOfPages = self.arrSlider.count
                            self.cvSlider.reloadData()
                        }
                    }
                    else
                    {
                        
                        DispatchQueue.main.async {
                            self.cvSlider.reloadData()
                            Utility.collectionViewNoDataMessage(collectionView: self.cvSlider, message: "No records", textColor: UIColor.black)
                            
                        }
                    }
                    
                }
                else {
                        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: jsonResponce!["message"].stringValue)
                    }
                }
            }
    }
    
    func getHome(){
        
        WebServices().CallGlobalAPI(url: WebService_Dashboard_List,headers: [:], parameters: [:], HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
            
            if(jsonResponce?.error != nil) {
                
                var errorMess = jsonResponce?.error?.localizedDescription
                errorMess = MESSAGE_Err_Service
                Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
            }
            else {
                
                if jsonResponce!["status"].stringValue == "true"{
                  
                  self.arrHome = jsonResponce!["data"].arrayValue

                  if self.arrHome.count != 0{
                    DispatchQueue.main.async {
                      self.tblHome.reloadData()
                      Utility.tableNoDataMessage(tableView: self.tblHome, message: "",messageColor:UIColor.white, displayMessage: .Center)
                      
                    }
                  }
                  else{
                    self.tblHome.reloadData()
                    Utility.tableNoDataMessage(tableView: self.tblHome, message: "No vaccination list",messageColor:UIColor.white, displayMessage: .Center)
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
        
        Utility.menu_Show(onViewController: self)
        
    }
    
    @IBAction func swipeUp(_ sender: Any) {
        
        scrollView.isScrollEnabled = true

        
    }
}


// MARK: CollectionView Delegate
extension DashboardVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
            return arrSlider.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCollectionViewCell", for: indexPath) as! SliderCollectionViewCell
            
            let data = arrSlider[indexPath.row]
      
      
      
      
      if data["link"].stringValue.count == 0{
            cell.lblTitle.text = "Image"
      }else{
            cell.lblTitle.text = "Video"
      }
      
            let imgUrl = data["image"].stringValue
        
            let placeHolder = UIImage(named: "splashscreen")
        
            cell.imgPhotos.kf.indicatorType = .activity
            cell.imgPhotos.kf.setImage(with: URL(string: imgUrl), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
      
      
            return cell
      
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
      
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("Current centered index: \(String(describing: centeredCollectionViewFlowLayout.currentCenteredPage ?? nil))")
        
          pageControl.currentPage = centeredCollectionViewFlowLayout.currentCenteredPage!
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("Current centered index: \(String(describing: centeredCollectionViewFlowLayout.currentCenteredPage ?? nil))")
        
      pageControl.currentPage = centeredCollectionViewFlowLayout.currentCenteredPage!
    }
    
}

//MARK TableView Delegate
extension DashboardVC : UITableViewDelegate, UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return arrHome.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
      let cellIdentifier = "YoutubeTableViewCell"
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? YoutubeTableViewCell  else {
        fatalError("The dequeued cell is not an instance of MealTableViewCell.")
      }
      
      let data = arrHome[indexPath.row]
    
//    if data["youtube_link"].stringValue.count != 0{
//
      cell.lblTitle.text = data["title"].stringValue
      cell.lblDuration.text = data["video_duration"].stringValue
      cell.lblDate.text = data["date"].stringValue
      
      let placeHolder = UIImage(named: "placeholder")
      
      cell.imgVideo.kf.indicatorType = .activity
      cell.imgVideo.kf.setImage(with: data["youtube_link"].url, placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
      
      cell.btnMoveToCatrgoryLink.setTitle(data["list_heading"].stringValue, for: .normal)
      
      return cell
 
    
   
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
   
    
  }
}



