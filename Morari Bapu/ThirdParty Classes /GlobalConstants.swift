
import Foundation
import UIKit

let APP_NAME                                = "Morari Bapu"

//MARK: Fonts Name
let MontserratRegular                       = "Montserrat-Regular"
let MontserratBlack                         = "Montserrat-Black"
let MontserratMedium                        = "Montserrat-Medium"
let MontserratBold                          = "Montserrat-Bold"

//MARK: storyboards
let Custome_Storyboard                     = "Main"

//var BASE_URL                             = "http://vetolution.com:3004/api/v1/" //Live
var BASE_URL                               = "http://app.nivida.in/moraribapu/" //Development

//Login Signup Apis

let WebService_Slider_Dashboard                      = "\(BASE_URL)Slider/App_Get_Slider"
let WebService_Dashboard_List                        = "\(BASE_URL)HomeApi/App_GetHome"

let WebService_Daily_Katha_Clip                      = "\(BASE_URL)Kathavideo/App_GetDailyKathavideo"
let WebService_Daily_Katha_Clip_Details              = "\(BASE_URL)Kathavideo/App_GetDailyKathavideoDetail"

let WebService_Quotes_List                           = "\(BASE_URL)Quote/App_GetQuote"
let WebService_Quotes_Details                        = "\(BASE_URL)Quote/App_QuoteDetail"

let WebService_Stuti_List                            = "\(BASE_URL)Stuti/App_GetStuti"
let WebService_Stuti_Details                         = "\(BASE_URL)Stuti/App_GetStutiDetail"

let WebService_Chopai_List                          = "\(BASE_URL)KathaChopai/App_GetKathaChopai"
let WebService_Chopai_Details                       = "\(BASE_URL)KathaChopai/App_GetKathaChopaiDetail"

//MARK:- COLOR CONSTANT
let color_Green_Light: UIColor                     = UIColor(red: 105.0/255.0, green: 192.0/255.0, blue: 164.0/255.0, alpha: 1.0)

//MARK: -  Message
let MESSAGE_Err_Network                     = "Please check network connections. try again"
let MESSAGE_Err_Service                     = "Services are temporarily unavailable, please try again later"
