//
//  Utility.swift
//  Doggie
//
//  Created by Bhavin Chauhan on 19/07/18.
//  Copyright © 2018 Bhavin Chauhan. All rights reserved.
//
import Foundation
import SwiftyUserDefaults
import SwiftyJSON
import SwiftyUserDefaults
import Kingfisher
import SwiftyJSON
import Alamofire

//MARK:- Table Header Message

public enum DisplayMessageAlignment : Int {
    case Top
    case Center
    case Bottom
}

class Utility: NSObject
{

//    //MARK:- Button
//    static func logoutUI() -> Void {
//
//        DispatchQueue.main.async {
//
//            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let loginVC = storyboard.instantiateViewController(withIdentifier: "StartupScreenVC") as! StartupScreenVC
//            let navigation = storyboard.instantiateViewController(withIdentifier: "mainNavigation") as? UINavigationController
//            navigation?.setViewControllers([loginVC], animated: true)
//            UIApplication.shared.keyWindow?.rootViewController = navigation
//
//        }
//    }
    
    
 
    
    static func tableNoDataMessage(tableView:UITableView, message:String, messageColor:UIColor, displayMessage:DisplayMessageAlignment){
        

        if displayMessage == .Top{
            
            let frame = CGRect(x: 0, y: 0,  width: tableView.bounds.size.width, height: tableView.bounds.size.height)
            let lblMessage : UILabel = UILabel.init(frame: frame)
            lblMessage.text = message
            
            if UIDevice.current.userInterfaceIdiom == .pad{
                lblMessage.font = UIFont(name:MontserratSemiBold, size:25)
            }else{
                lblMessage.font = UIFont(name:MontserratSemiBold, size:20)
            }
            
            lblMessage.textAlignment = .center
            lblMessage.sizeToFit()
            lblMessage.textColor = messageColor
            tableView.tableHeaderView = lblMessage
            tableView.sectionHeaderHeight = 60
            tableView.separatorStyle = .none
            
        }else if displayMessage == .Center{
            
            let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            let messageLabel = UILabel(frame: rect)
            messageLabel.text = message
            messageLabel.textColor = messageColor
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center
            
            if UIDevice.current.userInterfaceIdiom == .pad{
                messageLabel.font = UIFont(name:MontserratSemiBold, size:25)
            }else{
                messageLabel.font = UIFont(name:MontserratSemiBold, size:20)
            }
            
            messageLabel.sizeToFit()
            
            tableView.backgroundView = messageLabel;
            tableView.separatorStyle = .none;
            
        }else if displayMessage == .Bottom{
            
        }
        
        
    }
    
    //MARK:- Table Header Message
    static func collectionViewNoDataMessage(collectionView:UICollectionView, message:String, textColor:UIColor){
        
        let frame = CGRect(x: 0, y: 0,  width: collectionView.bounds.size.width, height: 200)
        let lblMessage : UILabel = UILabel.init(frame: frame)
        lblMessage.text = message
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            lblMessage.font = UIFont(name:MontserratSemiBold, size:25)
        }else{
            lblMessage.font = UIFont(name:MontserratSemiBold, size:20)
        }
        
        lblMessage.textAlignment = .center
        lblMessage.sizeToFit()
        lblMessage.textColor = textColor
        collectionView.backgroundView = lblMessage
        
    }

    func showAlertMessage(vc: UIViewController, titleStr:String, messageStr:String) -> Void {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert);
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            vc.present(alert, animated: true, completion: nil)
            //UIApplication.shared.delegate?.window!?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }

    //MARK:- Loader (Custom)
    static func loader_Show(onViewController: UIViewController) {
        DispatchQueue.main.async {
            //let objVC = self.storyboard?.instantiateViewController(withIdentifier: "LoaderVC") as! LoaderVC
            let storyboard : UIStoryboard = UIStoryboard(name: Custome_Storyboard, bundle: nil)
            let objVC = storyboard.instantiateViewController(withIdentifier: "LoaderVC")
            objVC.modalPresentationStyle = .overCurrentContext
            objVC.modalTransitionStyle = .crossDissolve
            
            onViewController.present(objVC, animated: false, completion: nil)
            //UIApplication.shared.delegate?.window!?.rootViewController?.present(objVC, animated: true, completion: nil)
        }
    }
    static func loader_Hide(onViewController: UIViewController) {
        DispatchQueue.main.async {
            onViewController.dismiss(animated: false, completion: nil)
            //UIApplication.shared.delegate?.window!?.rootViewController?.dismiss(animated: false, completion: nil)
            /*
             let deadlineTime = DispatchTime.now() + 5
             DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
             onViewController.dismiss(animated: false, completion: nil)
             UIApplication.shared.delegate?.window!?.rootViewController?.dismiss(animated: false, completion: nil)
             }
             */
        }
    }
    
    
    func get_AppVersion () -> NSString {
        let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        let version = nsObject as! String
        return version as NSString
    }
    
    func get_AppSubVersion () -> NSString {
        let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleVersion"] as AnyObject
        let version = nsObject as! String
        return version as NSString
    }
    

    //Date convert string to Date & Date to string in swift
    static func dateToString(dateStr:String, strDateFormat:String) -> String {
        
        var strConverted = String()
        
        if dateStr != "" && dateStr != "0000-00-00"{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone.current
            
            let date = dateFormatter.date(from:dateStr)!
            //dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:a"
            dateFormatter.dateFormat = strDateFormat
            dateFormatter.timeZone = TimeZone.current
            
            strConverted = dateFormatter.string(from:date)
        }else{
            strConverted = ""
        }
       
        return strConverted
    }
    
    static func monthCalculate(date: Date) -> Int {
        
        let now = Date()
        let birthday: Date = date
        let calendar = Calendar.current
        
        let monthDate = calendar.dateComponents([.month], from: birthday, to: now)
    
        return monthDate.month!
    }
    
    //Age calculate
    static func ageCalculate(date: Date) -> String {
        
        let birthday: Date = date
        let calendar = Calendar.current

        let months = calendar.dateComponents([.month], from: birthday, to: currentLocalDate())
        let year = calendar.dateComponents([.year], from: birthday, to: currentLocalDate())
        let day = calendar.dateComponents([.day], from: birthday, to: currentLocalDate())

        var age = String()
        
        let month = months.month! % 12
        
        if month > 0{
            if month == 1{
                age.append(String(format:"%d Month ",month))
            }else{
                age.append(String(format:"%d Months ",month))
            }
        }
        
        if year.year! != 0{
            if year.year! == 1{
                age.append(String(format:"%d Year ",year.year!))
                
            }else{
                age.append(String(format:"%d Years ",year.year!))
            }
        }
        
        if day.day! == 1{
            age.append(String(format:"%d Day ",day.day!))
        }else if day.day! <= 31 && month == 0 && year.year! == 0{
            age.append(String(format:"%d Days ",day.day!))
        }
        
        
        return age
    }
    
    static func calculateDateHours(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.hour], from: startDate, to: endDate)
        
        return components.hour!
    }
    
    static func currentDateToString() -> String {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current

        
        let result = formatter.string(from: date)
        
        return result
    }
    
    static func currentDateToStringDay() -> String {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.timeZone = TimeZone.current
        
        
        let result = formatter.string(from: date)
        
        return result
    }
    
    
    static func dateToString(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current

        let result = formatter.string(from: date)
        
        return result
    }
    
    static func dateToStringFormatter(date: Date, strDateFormater:String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = strDateFormater
        formatter.timeZone = TimeZone.current

        let result = formatter.string(from: date)
        
        return result
    }
    
    
    static func dateToMonth(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        formatter.timeZone = TimeZone.current

        let result = formatter.string(from: date)
        
        return result
    }
    
    static func dateToDay(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        formatter.timeZone = TimeZone.current

        let result = formatter.string(from: date)
        return result
    }
    
    static func dateToWeek(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        formatter.timeZone = TimeZone.current

        let result = formatter.string(from: date)
        return result
    }
    
    static func dateToTime(date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "hh:mm a"
        
        return dateFormatter.string(from: dt!)
    }
    
    static func currentLocalDate() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT())
        
        return Date(timeInterval: seconds, since: Date())
    }
    
    
    static func stringDateToDate(date: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateStr =  dateFormatter.string(from: dt!)
        
        return dateFormatter.date(from: dateStr)!
        
    }
   
    
    
    static func dateFormantterForAppintmentMessage(date: String) -> String {
        
        //Sunday, June 17th at 11:30 am
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // edited
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone.current

        let date = dateFormatter.date(from:date)!
        dateFormatter.dateFormat = "EEEE, MMMM dd'th' 'at' hh:mm a"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        let dateString = dateFormatter.string(from:date)
        return dateString
    }
    
    
    //Image resolution resize
    class func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        
        let size = image.size
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    static func uniqueIdentifyGenrator() -> String {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        formatter.timeZone = TimeZone.current
        
        let result = formatter.string(from: date)
        
        return result
    }
  
  static func canOpenURL(_ string: String?) -> Bool {
    guard let urlString = string,
      let url = URL(string: urlString)
      else { return false }
    
    if !UIApplication.shared.canOpenURL(url) { return false }
    
    let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
    let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
    return predicate.evaluate(with: string)
  }

   
    
    //MARK:- Validation
    static func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
  
  static func getDeviceID() -> String {
    
   return UIDevice.current.identifierForVendor!.uuidString

  }
  
    //MARK:- DropDown (Show Hide)
    static func menu_Show(onViewController: UIViewController) {
      DispatchQueue.main.async {
        //let objVC = self.storyboard?.instantiateViewController(withIdentifier: "LoaderVC") as! LoaderVC
        let storyboardCustom : UIStoryboard = UIStoryboard(name: Custome_Storyboard, bundle: nil)
        let objVC = storyboardCustom.instantiateViewController(withIdentifier: "MenuVC") as? MenuVC
        objVC?.modalPresentationStyle = .overCurrentContext
        objVC?.modalTransitionStyle = .crossDissolve
        objVC?.delegate = (onViewController as! MenuNavigationDelegate)
        onViewController.present(objVC!, animated: false, completion: nil)
        //UIApplication.shared.delegate?.window!?.rootViewController?.present(objVC, animated: true, completion: nil)
      }
    }
    
    static func menu_Hide(onViewController: UIViewController) {
        DispatchQueue.main.async {
            onViewController.dismiss(animated: false, completion: nil)
        }
    }
  
  //MARK:- Hanuman Chalisha (Show Hide)
  static func hanuman_chalisha_Show(onViewController: UIViewController) {
    DispatchQueue.main.async {
      
      let storyboardCustom : UIStoryboard = UIStoryboard(name: Custome_Storyboard, bundle: nil)
      let objVC = storyboardCustom.instantiateViewController(withIdentifier: "HanumanChalishaVC") as? HanumanChalishaVC
      objVC?.modalPresentationStyle = .overCurrentContext
      objVC?.modalTransitionStyle = .crossDissolve
      onViewController.present(objVC!, animated: false, completion: nil)
      
      
    }
  }
  
  static func hanuman_chalisha_Hide(onViewController: UIViewController) {
    DispatchQueue.main.async {
      onViewController.dismiss(animated: false, completion: nil)
    }
  }
  
  
  static func image_Viewer_Show(onViewController: UIViewController, indexPosition: IndexPath, images:[JSON]) {
    DispatchQueue.main.async {
      //let objVC = self.storyboard?.instantiateViewController(withIdentifier: "LoaderVC") as! LoaderVC
      let storyboardCustom : UIStoryboard = UIStoryboard(name: Custome_Storyboard, bundle: nil)
      let objVC = storyboardCustom.instantiateViewController(withIdentifier: "ImageViewerVC") as? ImageViewerVC
      objVC?.modalPresentationStyle = .overCurrentContext
      objVC?.modalTransitionStyle = .crossDissolve
      objVC?.indexPosition = indexPosition
      objVC?.arrImages = images
      onViewController.present(objVC!, animated: false, completion: nil)
      //UIApplication.shared.delegate?.window!?.rootViewController?.present(objVC, animated: true, completion: nil)
    }
  }
  
  static func image_Viewer_Hide(onViewController: UIViewController) {
    DispatchQueue.main.async {
      onViewController.dismiss(animated: false, completion: nil)
    }
  }
  
  static func music_Player_Show(onViewController: UIViewController, position:Int, listOfAudio:[JSON]) {
    DispatchQueue.main.async {
      //let objVC = self.storyboard?.instantiateViewController(withIdentifier: "LoaderVC") as! LoaderVC
      let storyboardCustom : UIStoryboard = UIStoryboard(name: Custome_Storyboard, bundle: nil)
      let objVC = storyboardCustom.instantiateViewController(withIdentifier: "MusicPlayerVC") as? MusicPlayerVC
      objVC?.modalPresentationStyle = .overCurrentContext
      objVC?.modalTransitionStyle = .crossDissolve
      objVC?.arrAudioList = listOfAudio
      objVC?.playPosition = position
      onViewController.present(objVC!, animated: false, completion: nil)
      //UIApplication.shared.delegate?.window!?.rootViewController?.present(objVC, animated: true, completion: nil)
    }
  }
  
  static func music_Player_Hide(onViewController: UIViewController) {
    DispatchQueue.main.async {
      onViewController.dismiss(animated: false, completion: nil)
    }
  }
  
  
  static func backToHome(){
    
    let storyBoardMain = UIStoryboard(name: Main_Storyboard, bundle: nil)
    
    let objVC = storyBoardMain.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
    let appNavigation: UINavigationController = UINavigationController(rootViewController: objVC)
    appNavigation.navigationBar.isHidden = true
    UIApplication.shared.delegate?.window??.rootViewController = appNavigation
  }
  
  static func readUnread(api_Url:String, parameters:NSDictionary){
    
    WebServices().CallGlobalAPI(url: api_Url,headers: [:], parameters: parameters, HttpMethod: "POST", ProgressView: false) { ( _ jsonResponce:JSON? , _ strErrorMessage:String) in
      
      if(jsonResponce?.error != nil) {
      }
      else {
        
        if jsonResponce!["status"].stringValue == "true"{
 
          
        }
        else {
        }
      }
    }
    
  }
  
 static func extractYouTubeId(from url: String) -> String? {
    let typePattern = "(?:(?:\\.be\\/|embed\\/|v\\/|\\?v=|\\&v=|\\/videos\\/)|(?:[\\w+]+#\\w\\/\\w(?:\\/[\\w]+)?\\/\\w\\/))([\\w-_]+)"
    let regex = try? NSRegularExpression(pattern: typePattern, options: .caseInsensitive)
    return regex
      .flatMap { $0.firstMatch(in: url, range: NSMakeRange(0, url.count)) }
      .flatMap { Range($0.range(at: 1), in: url) }
      .map { String(url[$0]) }
  }

}

extension String {
    
    func isNumber() -> Bool {
        let numberCharacters = NSCharacterSet.decimalDigits.inverted
        return !self.isEmpty && self.rangeOfCharacter(from: numberCharacters) == nil
    }
    
}

extension UIDatePicker {
    func set13YearValidation() {
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = -13
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.year = -150
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        self.minimumDate = minDate
        self.maximumDate = maxDate
    }
}


extension UITextField {
    
        func placeholderColor(_ color: UIColor){
            var placeholderText = ""
            if self.placeholder != nil{
                placeholderText = self.placeholder!
            }
            self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor : color])
        }
   
    func useUnderline(line_Color:UIColor) {
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = line_Color.cgColor
        border.frame = CGRect(origin: CGPoint(x: 0,y :self.frame.size.height - borderWidth), size: CGSize(width: UIScreen.main.bounds.width, height: self.frame.size.height))
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func useUnderlineRemoveTexiField() {
        self.layer.sublayers?.removeAll()
    }
    
    func serBorderTextField(borderColor:UIColor, borderWidth:Float, cornerRadius:Float) {
            
        self.layer.masksToBounds = true
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = CGFloat(cornerRadius)
    }
    
    enum UIUserInterfaceIdiom : Int {
        case unspecified
        
        case phone // iPhone and iPod touch style UI
        case pad // iPad style UI
    }
}
extension UITextView {
 
    func useUnderlineTextView(line_Color:UIColor) {
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = line_Color.cgColor
        border.frame = CGRect(origin: CGPoint(x: 0,y :self.frame.size.height - borderWidth), size: CGSize(width: UIScreen.main.bounds.width, height: self.frame.size.height))
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }

}

extension UIButton {
    
    func useUnderlineButton(line_Color:UIColor) {
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = line_Color.cgColor
        border.frame = CGRect(origin: CGPoint(x: 0,y :self.frame.size.height - borderWidth), size: CGSize(width: UIScreen.main.bounds.width, height: self.frame.size.height))
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func useUnderlineRemoveButton() {
        self.layer.sublayers?.removeLast()
    }
    
    
}

extension UILabel {
    
    func useUnderlineLabel(line_Color:UIColor) {
      let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
      let underlineAttributedString = NSAttributedString(string: self.text!, attributes: underlineAttribute)
      self.attributedText = underlineAttributedString
    }
    
}

extension UIImageView {
    
    func imageColorChange(color:UIColor) {
        self.image = self.image!.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
    
}

extension UIButton{
    
    func imageColorChange(imageColor:UIColor){
        let tintedImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: .normal)
        self.tintColor = imageColor
    }
   
    
    func dropShadow(backgroundColor:UIColor){
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = 13.0
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 2.0
    }
    
        func underlineButton(text: String) {
            let titleString = NSMutableAttributedString(string: text)
            titleString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, text.count))
            self.setAttributedTitle(titleString, for: .normal)
        }
}


extension UIView{
    func dropShadowView(backgroundColor:UIColor, cornerRadius:Float){
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 2.0
    }
}

extension UITableView{
    func dropShadowTableView(){
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = 10.0
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 2.0
    }
}



struct Device {
    // iDevice detection code
    static let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA           = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH        = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT       = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH   = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    
    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
    static let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568
    static let IS_IPHONE_6         = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IS_IPHONE_6P        = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IS_IPHONE_X         = IS_IPHONE && SCREEN_MAX_LENGTH == 812
}
