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
import Kingfisher
import iCarousel

class DashboardVC: UIViewController {


    var arrSlider  = [JSON]()
    var arrHome  = [JSON]()
    var currentPageNo = Int()
    var totalPageNo = Int()
  
  @IBOutlet weak var lblSliderTitle: UILabel!
  @IBOutlet weak var vwCarousel: iCarousel!
  @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var btnDown: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var constraintHeightTableView: NSLayoutConstraint!
  @IBOutlet weak var carouselHeight: NSLayoutConstraint!
  
  @IBOutlet weak var tblHome: UITableView!
  
  let screenSize: CGRect = UIScreen.main.bounds

    override func viewDidLoad() {
        super.viewDidLoad()

      currentPageNo = 1
      
      let screenHeight = screenSize.height

      carouselHeight.constant = screenHeight - 160
      self.view.layoutIfNeeded()
      
        tblHome.tableFooterView =  UIView.init(frame: .zero)
        tblHome.layoutMargins = .zero
      
        tblHome.rowHeight = 500
        tblHome.estimatedRowHeight = UITableView.automaticDimension
      
        btnDown.imageColorChange(imageColor: UIColor.black)
        scrollView.isScrollEnabled = false
        pageControl.numberOfPages = 0
        
      
        pageControl.numberOfPages = 0
        pageControl.currentPage = 0
        
        DispatchQueue.main.async {
            self.getSliderList()
        }
    }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
      self.constraintHeightTableView.constant = self.tblHome.contentSize.height
      self.view.layoutIfNeeded()
  
    print("TableView Height: \(constraintHeightTableView.constant)")

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
                  self.getHome(pageNo: self.currentPageNo)
                    self.arrSlider = jsonResponce!["data"].arrayValue

                    if self.arrSlider.count != 0{
                      
                      
                        DispatchQueue.main.async {
                            self.pageControl.numberOfPages = self.arrSlider.count
                        
                          let title = self.arrSlider[0]
                          
                          if title["link"].stringValue.count != 0 {
                            self.lblSliderTitle.text = "Video"
                          }else{
                            self.lblSliderTitle.text = "Image"
                          }
                          
                          
                          self.vwCarousel.type = iCarouselType.coverFlow2
                          self.vwCarousel.centerItemWhenSelected = false
                          self.vwCarousel.autoscroll=0.3;
                            self.vwCarousel .reloadData()
                        }
                    }
                    else
                    {
                        
                        DispatchQueue.main.async {
                          
                        }
                    }
                    
                }
                else {
                        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: jsonResponce!["message"].stringValue)
                    }
                }
            }
    }
    
  func getHome(pageNo:Int){
      
      let param = ["page":"\(pageNo)"]
      
      WebServices().CallGlobalAPI(url: WebService_Dashboard_List,headers: [:], parameters: param as NSDictionary, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
            
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
                      
                      self.totalPageNo = jsonResponce!["total_page"].intValue
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
      
        tblHome.reloadData()
        scrollView.isScrollEnabled = true

        
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
    
  
      
      let data = arrHome[indexPath.row]
    
      if data["youtube_link"].stringValue.count != 0{

        let cellIdentifier = "YoutubeTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? YoutubeTableViewCell  else {
          fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
      cell.lblTitle.text = data["title"].stringValue
        cell.lblDuration.text = "Duration: \(data["video_duration"].stringValue)"
      cell.lblDate.text = Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd-MM-yyyy")
      
      let placeHolder = UIImage(named: "youtube_placeholder")
      
      cell.imgVideo.kf.indicatorType = .activity
      cell.imgVideo.kf.setImage(with: data["video_image"].url, placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
      
      cell.btnMoveToCatrgoryLink.setTitle(data["list_heading"].stringValue, for: .normal)
        
        if data["is_favourite"].boolValue == true{
          cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
        }else{
          cell.btnFavourite.setImage(UIImage(named: "unfavorite"), for: .normal)
        }
        
        cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)
        cell.btnYoutube.addTarget(self, action: #selector(btnYoutube), for: UIControl.Event.touchUpInside)
        cell.btnFavourite.addTarget(self, action: #selector(btnFavourite), for: UIControl.Event.touchUpInside)


        return cell

    }
    else if data["quotes_english"].stringValue.count != 0{
      
        let cellIdentifier = "QuotesTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? QuotesTableViewCell  else {
          fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        cell.lblQuotes.text = data["quotes_english"].stringValue
        cell.lblDate.text = Utility.dateToString(dateStr: data["date"].stringValue, strDateFormat: "dd-MM-yyyy")
        cell.btnCategories.setTitle(data["list_heading"].stringValue, for: .normal)
        
        if data["is_favourite"].boolValue == true{
          cell.btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
        }else{
          cell.btnFavourite.setImage(UIImage(named: "unfavorite"), for: .normal)
        }
        
        cell.btnFavourite.addTarget(self, action: #selector(btnFavourite), for: UIControl.Event.touchUpInside)

        cell.btnShare.addTarget(self, action: #selector(btnShare), for: UIControl.Event.touchUpInside)

        
        return cell
        
      } else{
        
        let cellIdentifier = "UpcomingKathaTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UpcomingKathaTableViewCell  else {
          fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        
        cell.lblDay.text = Utility.dateToString(dateStr: data["from_date"].stringValue, strDateFormat: "d")
        cell.lblTitle.text = data["title"].stringValue
        cell.lblDate.text = Utility.dateToString(dateStr: data["from_date"].stringValue, strDateFormat: "MM,yyyy")
        cell.lblScheduleDate.text = "\(Utility.dateToString(dateStr: data["from_date"].stringValue, strDateFormat: "dd-MM-yyyy")) to \(Utility.dateToString(dateStr: data["to_date"].stringValue, strDateFormat: "dd-MM-yyyy"))"
        cell.btnCategoryName.setTitle(data["list_heading"].stringValue, for: .normal)
        
        return cell

    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let data = arrHome[indexPath.row]
    
    if data["youtube_link"].stringValue.count != 0{
      
      
    }
    else if data["quotes_english"].stringValue.count != 0{
      
  
      
    } else{
      
 
    }
   
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    if indexPath.row == arrHome.count - 1 {
   
      if totalPageNo < currentPageNo{
       
        print("Page Load....")
        
        self.getHome(pageNo: currentPageNo + 1)
      }
    }
  }
  

  @IBAction func btnShare(_ sender: UIButton) {
    
    let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblHome)
    let indexPath = self.tblHome.indexPathForRow(at: buttonPosition)
    
    // text to share
    let text = "https://itunes.apple.com/tr/app/morari-bapu/id1050576066?mt=8"
    
    // set up activity view controller
    let textToShare = [ text ]
    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
    
    // exclude some activity types from the list (optional)
    activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
    
    // present the view controller
    
    DispatchQueue.main.async {
      self.present(activityViewController, animated: true, completion: nil)
    }
  }
  
  @IBAction func btnYoutube(_ sender: UIButton) {
    
    let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblHome)
    let indexPath = self.tblHome.indexPathForRow(at: buttonPosition)
    
    let link = arrHome[indexPath!.row]
    let youtubeLink = link["youtube_link"].url
 
    DispatchQueue.main.async {
      UIApplication.shared.open(youtubeLink!, options: [:])
      }
    
  }
  
  @IBAction func btnFavourite(_ sender: UIButton) {
    
    let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblHome)
    let indexPath = self.tblHome.indexPathForRow(at: buttonPosition)
    
    let data = arrHome[indexPath!.row]
    var favourite_for = String()
    let favourite_id = data["is_favourite"].stringValue

    
    if data["youtube_link"].stringValue.count != 0{
      //Youtube
      favourite_for = "4"
    }
    else if data["quotes_english"].stringValue.count != 0{
      //Quotes
      favourite_for = "1"
    } else{
      // Upcoming
      favourite_for = "6"
    }
    
    
    let paramater = ["app_id":Utility.getDeviceID(),
                    "favourite_for":favourite_for,
                    "favourite_id":favourite_id]
    
    WebServices().CallGlobalAPI(url: WebService_Favourite,headers: [:], parameters: paramater as NSDictionary, HttpMethod: "POST", ProgressView: true) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
      
      if(jsonResponce?.error != nil) {
        
        var errorMess = jsonResponce?.error?.localizedDescription
        errorMess = MESSAGE_Err_Service
        Utility().showAlertMessage(vc: self, titleStr: "", messageStr: errorMess!)
      }
      else {
        
        if jsonResponce!["status"].stringValue == "true"{
         self.getHome(pageNo: 1)
        }
        else {
          Utility().showAlertMessage(vc: self, titleStr: "", messageStr: jsonResponce!["message"].stringValue)
        }
      }
    }
    
  }
  
}

extension DashboardVC : iCarouselDataSource, iCarouselDelegate{
 
  func numberOfItems(in carousel: iCarousel) -> Int {
     return arrSlider.count
  }
  
  func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
    var itemView: UIImageView
    if (view == nil)
    {
      let screenWidth = screenSize.width * 0.70

      let screenHeight = screenSize.height

      itemView = UIImageView(frame:CGRect(x:0, y:0, width:screenWidth, height:screenHeight - 160))
      itemView.contentMode = .scaleAspectFit
    }
    else
    {
      itemView = view as! UIImageView;
    }
    
    let image = arrSlider[index]
    let placeHolder = UIImage(named: "placeholder_doc")
    itemView.kf.setImage(with: URL(string: "\(BASE_URL_IMAGE)\(image["image"].stringValue)"), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
    
    return itemView
  }
  
  func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
 
    if arrSlider.count != 0{
      let title = arrSlider[carousel.currentItemIndex]
      
      if title["link"].stringValue.count != 0 {
        lblSliderTitle.text = "Video"
      }else{
        lblSliderTitle.text = "Image"
      }
      
      self.pageControl.currentPage = carousel.currentItemIndex
    }
    
    
  }
  
  private func carousel(carousel: iCarousel, didSelectItemAtIndex index: Int)
  {
    print(index)
  }
  
  
}

