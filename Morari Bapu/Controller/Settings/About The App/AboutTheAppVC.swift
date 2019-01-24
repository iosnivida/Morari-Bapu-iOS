//
//  KathaEBookVC.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 07/10/18.
//  Copyright © 2018 Bhavin Chauhan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class AboutTheAppVC: UIViewController {
  
  @IBOutlet weak var lblTitle: UILabel!
  @IBOutlet weak var lblDetails: UILabel!
  
  var strTitle = String()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.lblTitle.text = strTitle
    
    DispatchQueue.main.async {
      
      if self.strTitle == "About The App"{
        self.lblDetails.text = "Jai Siya Ram\n\nQuotes\nQuotes (SuVaakya) recited by Bapu during Kathas and several other occasions\n\nDaily Katha Clip\nDaily short videos of on going Katha or previous Katha\n\nRam Charit Manas\nChopai of Ram Charit Manas. The chopais come with their literal translations in English.\n\nKatha Chopais\nChopai of Ram Charit Manas which formed the base of Bapu's Kathas. The chopais come with their literal translations in English.\n\nKatha E-Books\nE-Books of the katha booklets which have been made and printed. For iOS users, E-Books will open in ibooks by default. Android users will have to download “Kindle” from the play store to open the eBooks. Android users will also have to open your amazon account to use Kindle.\n\nLive Katha Video\nLive video feed of on going Ram Katha from across the world. You can watch it on your phones and tablets with an access to data services and/or wi-fi zones. This link will directly take you to live feed channel on YouTube.\n\nLive Katha Audio\nLive audio feed of on going Ram Katha from across the world. You can listen to it on your phones and tablets with an access to data services and/or wi-fi zones. This link will directly take you to live feed channel on YouTube.\n\nMorari Bapu - YouTube Channel\nDirect access to Morari Bapu - YouTube Channel which contains previous Katha Videos\n\nEvents\nDetails of yearly events and upcoming events being organised by the Trust and Pujya Bapu.\n\nMedia\n\n- Images\nPhoto's of Bapu\n\n- Other Videos\nVideos of other events and interviews.\n\n- Daily Katha Clip\nDaily short videos of on going katha or previous katha\n\n- Audios\nAudio tracks of Sankirtan, Stutis and Bapu’s favourite melodies.\n\n- Articles\nArticles related to Bapu published in media\n\nWhats's New\nUpdates from Pujya Bapu and Shree Chitrakut Dham Trust.\n\nUpcoming Kathas\nInformation of the upcoming kathas as provided by the katha organisers\n\nFavourites\nYou can add any content into this section and view the same in offline mode.\n\nShare\nYou can share all the contents of this app with you friends and family through any other social media app available on your phone.\n\nOther features and tools\n- Clicking on the Ram logo on the top of the app, navigates you back onto the home screen\n- Clicking on Katha location shall show you the location of the Katha on google maps\n- The Katha dates shall automatically get saved and linked onto your phone calendar and reminder for the katha as per the timing shall pop up on your phone\n- Only 1 month old data shall be available on the app at any given time, unless added to favourites which gets saved onto the memory of your phone / SD card\n- Access to Sangeet ni Duniya Online website and very soon to their online shop.\n\nWidget\nThe app now also includes a widget for the app. Users will be able to see today's Quote and latest Katha Chopai on this.\n\n\nSadguru Kripa Hi Kevalam\n\n\nShree Chitrakut Dham Trust"
      }else if self.strTitle == "About Bapu"{
        self.lblDetails.text = "Morari Bapu is a renowned exponent of the Ram Charit Manas and has been reciting Ram Kathas for over fifty years throughout the world. The overall ethos of his Katha is universal peace and spreading the message of truth, love and compassion. While the focal point is the scripture itself, Bapu draws upon examples from other religions and invites people from all faiths to attend the discourses.\n\nBapu was born on the day of Shivratri in 1947 in the village of Talgajarda, close to Mahuva in Bhavnagar district of Gujarat and he still lives there with his family. He belongs to the Vaishnav Bava Sadhu Nimbarka lineage and spent much of his childhood under the care of his grandfather and guru, Tribhovandas Dada, and grandmother, Amrit Ma. While his grandmother would lovingly relay folktales to him for hours, his grandfather shared with him his knowledge of the Ram Charit Manas. By the age of twelve, Bapu had memorised the entire Ram Charit Manas and had begun reciting and singing the Ram Katha at fourteen.\n\nThe remarkable journey of reciting the Ramayana, which began in the presence of three village folk, has now taken Bapu to all corners of the world. For the over 700 Kathas held to date, Bapu has traversed every major city and pilgrimage in India and travelled to many countries from Sri Lanka, Indonesia, South Africa and Kenya to the United Kingdom, United States, Brazil, Australia, Israel and Japan, drawing millions in audiences. In 2011, Bapu held one of the most significant and historical Ram Kathas to date at the foothills of Mount Kailas, in Tibet. In addition to Ram Katha, Bapu has also orated 19 kathas on Gopi Geet, dedicating one katha for each verse, usually during the nine days of Navratri.\n\nAs well as doing Ram Kathas, Bapu has devoted much of his energy in bringing together communities, religions, sects and castes, in advocating peace and harmony both in India and globally. For two decades now, Bapu is the chief guest at the annual Yaad-e-Hussain programme held by the Muslim community in Mahuva. He also organises marriage ceremonies for Hindu and Muslim girls who are not able to pay for their wedding and participates in Kathas and other functions that are held by Dalits and Devi Pujaks.\n\nAt times of calamity in India and abroad, be it the Gujarat earthquake or Bihar floods or nuclear leak in Fukushima, Japan, Bapu has contributed generously to provide aid wherever possible. In his hometown of Talgajarda, Bapu has organised several literary and cultural programmes, honouring litterateurs, musicians, dancers, dramatists and actors among others. A conference on World Religions, Dialogue and Harmony, was held in 2009, inaugurated by the honourable Dalai Lama. Religious leaders of Buddhism, Jainism, Sikhism, Islam, Christianity as well as Hinduism spoke about the fundamental principles of their orders and advocated continuous dialogue for establishing inter-faith harmony.\n\nFor 16 years now, eminent writers and poets meet to discuss literary and scholastic issues and developments during the three-day Asmita Parva. The evening classical music programmes bring together renowned vocalists and instrumentalists of India.\n\nEvery year for the last 14 years, scholars of Sanskrit from all over India have also been meeting to analyse and examine the literary and scriptural texts written in this most ancient language.\n\nIn 2006, a seminar was organised in Talgajarda on the regional versions of Ramayana in modern Indian languages. Experts from various regions of India from Tamil Nadu and Punjab to Gujarat and Assam convened to participate in this seminar.\n\nIn July 2012, a national conference on Valmiki Ramayana was graced by Dr Satyavrata Shashtri, Dr Radhavallabh Tripathi, Dr Rajendra Nanavati and several other scholars of the Ramayana.\n\nAn International Conference on the Ramayana is now being proposed in 2014."
      }
      
    }
    
  }
  
  //MARK:- Button Event
  @IBAction func btnMenu(_ sender: Any) {
    Utility.menu_Show(onViewController: self)
  }
  
  @IBAction func btnHanumanChalisha(_ sender: Any) {
    Utility.hanuman_chalisha_Show(onViewController: self)
  }
  
  @IBAction func btnBack(_ sender: Any) {
    self.navigationController?.popViewController(animated:true)
  }
  
  @IBAction func backToHome(_ sender: Any) {
    self.navigationController?.popToRootViewController(animated: true)
  }
  
}


//MARK:- Menu Navigation Delegate
extension AboutTheAppVC: MenuNavigationDelegate{
  
  func SelectedMenu(ScreenName: String?) {
    
    if ScreenName == "Home"{
      //Home
      self.navigationController?.popToRootViewController(animated: true)
      
    }else if ScreenName == "Katha Chopai"{
      //Katha Chopai
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiVC") as! KathaChopaiVC
      vc.screenDirection = .Katha_Chopai
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Ram Charitra Manas"{
      //Ram Charitra Manas
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiVC") as! KathaChopaiVC
      vc.screenDirection = .Ram_Charit_Manas
      navigationController?.pushViewController(vc, animated:  true)
      
     }else if ScreenName == "Upcoing Katha"{
      //Upcoing Katha
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "UpComingKathasVC") as! UpComingKathasVC
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Quotes"{
      //Quotes
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiVC") as! KathaChopaiVC
      vc.screenDirection = .Quotes
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Daily Katha Clip"{
      //Daily Katha Clip
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "WhatsNewVideoVC") as! WhatsNewVideoVC
      vc.screenDirection = .Daily_Katha_Clip
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Live Katha Audio"{
      //Live Katha Audio
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
      vc.screenDirection = .Live_Katha_Streaming_Audio
      vc.strTitle = "Live Katha Audio"
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "You Tube Channel"{
      //You Tube Channel
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
      vc.screenDirection = .Moraribapu_Youtube_Channel
      vc.strTitle = "Morari Bapu Youtube Channel"
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Live Katha Video"{
      //Live Katha Video
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
      vc.screenDirection = .Live_Katha_Streaming_Video
      vc.strTitle = "Live Katha Video"
      navigationController?.pushViewController(vc, animated:  true)
      
    }
    else if ScreenName == "Media"{
      //Media
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
      vc.screenDirection = .Media
      navigationController?.pushViewController(vc, animated:  true)
      
      
    }else if ScreenName == "What's New"{
      //What's New
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
      vc.screenDirection = .Whats_New
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Sangeet Ni Duniya"{
      //Sangeet Ni Duniya
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
      vc.screenDirection = .Sangeet_Ni_Duniya_Online_Shop
      vc.strTitle = "Sangeet Ni Duniya Online Shop"
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Setting"{
      //Setting
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
      vc.screenDirection = .Settings
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Search"{
      //Search
       }else if ScreenName == "Favourites"{
      //Favourites
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "FavouriteVC") as! FavouriteVC
      navigationController?.pushViewController(vc, animated:  true)
    }else if ScreenName == "Events"{
      //Events
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "EventsVC") as! EventsVC
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Katha Ebook"{
      //Katha Ebook
      
      let storyboard = UIStoryboard(name: Main_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaEBookVC") as! KathaEBookVC
      navigationController?.pushViewController(vc, animated:  true)
      
    }
  }
}
