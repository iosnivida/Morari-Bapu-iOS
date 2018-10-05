
import Foundation
import UIKit

let APP_NAME                                = "Morari Bapu"

//MARK: Fonts Name
let MontserratLight                       = "MontserratAlternates-Light"
let MontserratRegular                     = "MontserratAlternates-Regular"
let MontserratSemiBold                    = "MontserratAlternates-SemiBold"

//MARK: storyboards
let Custome_Storyboard                     = "Custom"
let Main_Storyboard                        = "Main"

//var BASE_URL                             = "http://vetolution.com:3004/api/v1/" //Live
var BASE_URL                               = "http://app.nivida.in/moraribapu/" //Development

var BASE_URL_IMAGE                                = "http://app.nivida.in/moraribapu/files/"



let WebService_Slider_Dashboard                      = "\(BASE_URL)Slider/App_Get_Slider"
let WebService_Dashboard_List                        = "\(BASE_URL)HomeApi/App_GetHome"

let WebService_Daily_Katha_Clip                      = "\(BASE_URL)Kathavideo/App_GetDailyKathavideo"
let WebService_Daily_Katha_Clip_Details              = "\(BASE_URL)Kathavideo/App_GetDailyKathavideoDetail"

let WebService_Quotes_List                           = "\(BASE_URL)Quote/App_GetQuote"
let WebService_Quotes_Details                        = "\(BASE_URL)Quote/App_QuoteDetail"

let WebService_Stuti_List                            = "\(BASE_URL)Stuti/App_GetStuti"
let WebService_Stuti_Details                         = "\(BASE_URL)Stuti/App_GetStutiDetail"

let WebService_Chopai_List                           = "\(BASE_URL)KathaChopai/App_GetKathaChopai"
let WebService_Chopai_Details                        = "\(BASE_URL)KathaChopai/App_GetKathaChopaiDetail"

let WebService_Ram_Charit_Manas_List                 = "\(BASE_URL)Ramcharit/App_GetRamcharit"
let WebService_Ram_Charit_Manas_Detail               = "\(BASE_URL)Ramcharit/App_GetRamcharitDetail"

let WebService_Event_List                           = "\(BASE_URL)Event/App_GetEvent"
let WebService_Event_Detail                         = "\(BASE_URL)Event/App_GetEventDetail"

let WebService_Upcoming_Katha_List                  = "\(BASE_URL)UpcomingKatha/App_GetUpcomingKatha"
let WebService_Upcoming_Katha_Detail                = "\(BASE_URL)UpcomingKatha/App_GetUpcomingKathaDetail"

let WebService_Live_Katha_Audio                     = "\(BASE_URL)LiveKathaAudio/App_GetLiveKathaAudio"
let WebService_Live_Katha_Video                     = "\(BASE_URL)LiveKathaVideo/App_GetLiveKathaVideo"

let WebService_Bapus_Photos_Media                   = "\(BASE_URL)BapuDarshan/App_GetBapuDarshan"
let WebService_Other_Video_Media                    = "\(BASE_URL)Kathavideo/App_GetOtherVideo"

let WebService_Sankirtan_Media_Audio                = "\(BASE_URL)Sankirtan/App_GetSankirtan"

//Favourite
let WebService_Favourite                            = "\(BASE_URL)MyFavourite/App_Favourite"


//MARK:- COLOR CONSTANT
let color_Green_Light: UIColor                     = UIColor(red: 105.0/255.0, green: 192.0/255.0, blue: 164.0/255.0, alpha: 1.0)

//MARK: -  Message
let MESSAGE_Err_Network                     = "Please check network connections. try again"
let MESSAGE_Err_Service                     = "Services are temporarily unavailable, please try again later"
