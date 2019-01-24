
import Foundation
import UIKit

let APP_NAME                                = "Morari Bapu"

//MARK:- Fonts Name
let MontserratLight                       = "MontserratAlternates-Light"
let MontserratRegular                     = "MontserratAlternates-Regular"
let MontserratSemiBold                    = "MontserratAlternates-SemiBold"

//MARK:- storyboards
let Custome_Storyboard                     = "Custom"
let Main_Storyboard                        = "Main"

//var BASE_URL                                       = "http://vetolution.com:3004/api/v1/" //Live
var BASE_URL                                         = "http://app.nivida.in/moraribapu/" //Development

var BASE_URL_IMAGE                                   = "http://app.nivida.in/moraribapu/files/"

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


let WebService_Feedback                             = "\(BASE_URL)Feedback/App_Add_Feedback"

//Settings
let WebService_FAQ                                  = "\(BASE_URL)FAQ/App_GetFAQ"


//What's New
let WebService_Whats_New_Text                       = "\(BASE_URL)NewText/App_GetText"
let WebService_Whats_New_Video                      = "\(BASE_URL)NewVideo/App_GetVideo"
let WebService_Whats_New_Audio                      = "\(BASE_URL)NewAudio/App_GetAudio"
let WebService_Whats_New_Photos                     = "\(BASE_URL)NewImage/App_GetImage"

let WebService_Stuti_Audio                          = "\(BASE_URL)Stuti/App_GetStuti"
let WebService_Sankirtan_Audio                      = "\(BASE_URL)Sankirtan/App_GetSankirtan"
let WebService_Other_Audio                          = "\(BASE_URL)NewAudio/App_GetAudio"

//Media
let WebService_Media_Photos                         = "\(BASE_URL)BapuDarshan/App_GetBapuDarshan"
let WebService_Media_Video                          = "\(BASE_URL)Kathavideo/App_GetOtherVideo"
let WebService_Media_Sayri                          = "\(BASE_URL)Bapufavouriteshayari/App_GetBapufavouriteshayari"
let WebService_Media_Thought                        = "\(BASE_URL)BapuThought/App_GetBapuThought"
let WebService_Media_Articles                       = "\(BASE_URL)Article/App_GetArticle"
let WebService_Other_Videos_Categories              = "\(BASE_URL)OtherVideoCategory/App_GetOtherVideoCategory"
let WebService_Other_Categories_Videos_List         = "\(BASE_URL)Kathavideo/App_GetOtherVideo"

//Favourite
let WebService_Favourite                            = "\(BASE_URL)MyFavourite/App_Favourite"
let WebService_Katha_EBook                          = "\(BASE_URL)KathaEBook/App_GetKathaEBook"
let WebService_Favourite_List                       = "\(BASE_URL)MyFavourite/App_Get_Favourite"


//Read Unread Count
let WebService_Menu_Counts                          = "\(BASE_URL)HomeApi/App_GetMenuCount"
let WebService_Media_Counts                         = "\(BASE_URL)HomeApi/App_GetMediaCount"
let WebService_Whats_New_Counts                     = "\(BASE_URL)HomeApi/App_GetAudioCount"
let WebService_Katha_E_Book_Read_Unread             = "\(BASE_URL)KathaEBook/App_ReadKathaEBook"
let WebService_Katha_Chopai_Read_Unread             = "\(BASE_URL)KathaChopai/App_ReadKathaChopai"
let WebService_Ram_Charit_Manas_Read_Unread         = "\(BASE_URL)Ramcharit/App_ReadRamcharit"
let WebService_UpComming_Katha_Read_Unread          = "\(BASE_URL)UpcomingKatha/App_ReadUpcomingKatha"
let WebService_Quotes_Read_Unread                   = "\(BASE_URL)Quote/App_ReadQuote"
let WebService_Event_Read_Unread                    = "\(BASE_URL)Event/App_EventRead"
let WebService_Audio_Whats_New_Read_Unread          = "\(BASE_URL)NewAudio/App_ReadNewAudio"
let WebService_Image_Whats_New_Read_Unread          = "\(BASE_URL)NewImage/App_ReadNewImage"
let WebService_Text_Whats_New_Read_Unread           = "\(BASE_URL)NewText/App_ReadNewText"
let WebService_Video_Whats_New_Read_Unread          = "\(BASE_URL)NewVideo/App_ReadNewVideo"
let WebService_Bapu_Photos_Read_Unread              = "\(BASE_URL)BapuDarshan/App_ReadBapuDarshan"
let WebService_Bapu_Sayari_Read_Unread              = "\(BASE_URL)Bapufavouriteshayari/App_ReadBapufavouriteshayari"
let WebService_Article_Read_Unread                  = "\(BASE_URL)moraribapu/Article/App_ReadArticle"
let WebService_Katha_Other_Video_Read_Unread        = "\(BASE_URL)Kathavideo/App_KathavideoOtherRead"
let WebService_Struti_Media_Read_Unread             = "\(BASE_URL)Stuti/App_StutiRead"
let WebService_Sankirtan_Read_Unread                = "\(BASE_URL)Sankirtan/App_ReadSankirtan"
let WebService_Daily_Katha_Video_Read_Unread        = "\(BASE_URL)Kathavideo/App_KathavideoRead"
let WebService_Bapu_Thoughts_Read_Unread            = "\(BASE_URL)BapuThought/App_ReadBapuThought"

//MARK:-- COLOR CONSTANT
let color_Green_Light: UIColor                     = UIColor(red: 105.0/255.0, green: 192.0/255.0, blue: 164.0/255.0, alpha: 1.0)

//MARK:- -  Message
let MESSAGE_Err_Network                     = "Please check network connections. try again"
let MESSAGE_Err_Service                     = "Services are temporarily unavailable, please try again later"
