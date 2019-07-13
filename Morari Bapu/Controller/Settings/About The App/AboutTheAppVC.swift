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
      }else if self.strTitle == "Privacy Notice"{
        self.lblDetails.text = "This is to clarify that there is NO official FACEBOOK, TWITTER, INSTAGRAM, WHATSAPP, VIBER page, account or group of Morari Bapu. /n/nBapu does not have any association with and does not belong to any such online social media accounts or groups. Be aware that any such social media accounts that are active using the name Morari Bapu are FAKES / UNAUTHORISED."
      }else if self.strTitle == "User Guide"{
        self.lblDetails.text = "This is to clarify that there is NO official FACEBOOK, TWITTER, INSTAGRAM, WHATSAPP, VIBER page, account or group of Morari Bapu. /n/nBapu does not have any association with and does not belong to any such online social media accounts or groups. Be aware that any such social media accounts that are active using the name Morari Bapu are FAKES / UNAUTHORISED."
      }else if self.strTitle == "About Talgajarda"{
        self.lblDetails.text = "Talgajrada is a small village, located at a distance of about 3 kms. from Mahuva bypass road, of Mahuva Taluka of Bhavnagar district in Gujarat. This is a hometown of Morari Bapu and at present, he lives here only. This village has many Temples like Chitrakutdham - Shree Hanumanji Maharaj Temple, Ramji Mandir, Shiv Mandir,Morari Bapu’s birth place known as Tribhuvan Tirth, Temple of Triling Mahadev, Temple of Vrajnath Mahadev and at a distance of @1.5km, there is a Temple of Pithoriya Hanuman. The village is surrounded by farming land where the local people grow onion and other seasonal grains. At the entrance road of Talgajarda village ,there is an English Medium School of International Standard, named as Hanumant School. This school is established with the Blessings of Morari Bapu and is run by RBK Group of Mumbai."
      }
      else if self.strTitle == "About Tribhuvandas Dada"{
        self.lblDetails.text = "Tribhuvandas Dada is a Grandfather and Guru of Morari Bapu. All the knowledge of “Ramcharitmanas” was passed on to Morari Bapu by his grandfather at his small house next to Ramji Mandir in Talgajrada Village of Mahuva Taluka, Dist. Bhavnagar in Gujarat. Morari Bapu often quotes the pious little corner of his small house where Dadaji imparted the teachings of “Ramcharitmanas” upon him. The “between the lines” interpretations of “Ramcharitmanas” shared by Dadaji are by far unique and peerless in nature. Dadaji also provided deeper understanding of various episodes, situations and characters described by Goswami Tulsidasji in “Ramcharitmanas”. Based on the knowledge received from Dadaji and with the Blessings &amp; Krupa of Dadaji, Morari Bapu began reciting Ramkatha at the age of 14 years. Morari Bapu often quotes golden memories of Dadaji during reciting of Ramkatha."
        }
      else if self.strTitle == "About Chitrakutdham"{
        self.lblDetails.text = "The Chitrakutdham – Shree Hanumanji Maharaj Temple is located in Talgajrada Village. Chitrakutdham has a life size idol (Murti) of Lord Shree Hanumanji Maharaj along with Samadhis of Morari Bapu’s family members. Initially, there was a life size picture (11 Feet Photo) of Shree Hanumanji Maharaj placed during Morari Bapu’s 1008 Ram Parayan (Ramkatha) in Mahuva in the year 1981. Later on, during 600th Ramkatha of Morari Bapu in the year 2003, this picture was replaced by a life size idol of Shree Hanumanji Maharaj. In Chitrakutdham, Morari Bapu meets all the visitors in morning and evening during the day whenever he is in his hometown. Every year, Evening Programmes and Award ceremony of festivals like Hanuman Jayanti and Santvani are performed in front of Shree Hanumanji Maharaj and Morari Bapu gives the Pravachan on these occasions."
        }
      else if self.strTitle == "About Chitrakutdham Trust"{
        self.lblDetails.text = "Shree Chitrakutdham Trust was established in 1986 with the blessings of Shree Hanumanji Maharaj andMorari Bapu. This is a non-governmental organization at village Talgajarda, Taluka Mahuva, in Bhavnagar district of Gujarat State. The Trust is engaged in various “Sarvjan Hitay, Sarvjan Sukhay” welfare activities, such as :\n\n1. Prabhu Prasad (Sadavrat) - free lunch and dinner every day for all the people, irrespective of cast and religion, visiting for Darshan, since last 30 years. GEDA design Biogas plant is run with cow dung for cooking purpose. \n2. Group Marriages for daughters of Talgjarada village irrespective of cast and religion, every year. \n3. Providing Free Medical Treatment facility for all the residents of Talgajrada village at Hanumant Hospital in Mahuva. \n4. Rural Development by constructing Internal RCC roads with electricity, Primary School with Computers, Primary Health Center, Overhead Water tank, New Building of Panchayat Office and Police Station.\n5. Kailas Gaushala is having 180 well maintained cows. Milk is distributed to families of Sadhu Samaj, Students at Kailas Gurukul and all staff members daily in the morning and evening free of cost. GEDA design Biogas plant is also run with cow dung. \n6. Kailas Gurukul was established in 1984 at the bank of Malan River in Mahuva. Around 100 children of Sadhu Samaj Families stay here with free lodging and boarding facilities. They complete their study in Schools &amp; Collages of Mahuva. In Kailas Gurukul, they are taught Sanskrit. Various Parv &amp; satra like Asmita Parv, Sanskrit satra, Tulsi Janmotsav, Shikshan Parv, etc. are organised in Kailas Gurukul. Trust has given land to build Hanumant School of an international standard in Mahuva. \n7. Hanuman Jayanti, Asmita Parv and various Awards - This festival is organized to encourage writers, poets, people attached to literature since last 20 years. Three days seminar is conducted in Kailas Gurukul and almost 350 delegates attend this Parv. During Hanuman Jayanti, well known personalities having lifetime achievement in Indian culture, Fine Arts like Music, Dance, Painting, Sculpture, Photography, Hindi Cinema, Hindi Television, Gujarati Drama, Bhavai, etc are facilitated with Kailas Lalit Kala Award, Hanumant Awards and Natraj Awards, every year. \n8. Sanskrit Satra - This festival is organised to serve basic Dev Bhasha-Sanskrit, for 3 days every year, at Kailas Gurukul since last 18 years. On the last day of Satra, “Vachaspati Purskar and Bhamti Puraskar” is given to well known persons for his/her lifetime service for Sanskrit language. \n9. Tulsi Ghat is established at Kailas Gurukul to help people for detailed study/research on literature of Shree Tulsidasji and Ramcharitmanas. \n10. Santwani Award is given to creators of Prachin Bhajans, Singers and players of Tabla, Manjira, Benjo, Violin, every year. \n11. Shree Avinas Vyas Award is given for Gujarati Sugam Sangeet. \n12. Tulsi Award is given on Tulsi Janmotsav every year to Manas Kathakar and well known persons for their lifetime service on Tulsi Sahitya. \n13. Valmiki Award is given to Kathakar of Valmiki Ramayan. \n14. Vyas Award is given to Kathakar of Maharshi Ved Vyas created literature like Shrimad Bhagavat Mahapuran and Mahabharat. \n15. Kag Award is given in the memory of famous poet Shree Dulabhaya Kag (Kagbapu). \n16. Financial Support by giving donation, every year, to various Organizations, engaged in carrying out noble work for Society."
        }
      else if self.strTitle == "About Tulsidasji"{
        self.lblDetails.text = "Shree Tulsidasji is one of the greatest poets and Saint of medieval India. His birth place is Village Rajapur in Uttar Pradesh. He is also known as Goswami Tulsidasji. He was a revolutionary and philosopher from Ramanandi Sampraday, in the lineage of Jagadguru Ramanandacharya, known for his devotion to Lord Ram. Tulsidasji has composed “Ramcharitmanas” in Avadhi Hindi, based on Lord Ram’s life and published it on the auspicious day of Ram Navmi in Vikram Samvat 1631 in Ayodhya. Over and above Ramcharitmanas, Goswami Tulsidasji has also published 11 additional well known Granths namely, Dohavali, Kavitavali, Gitavali, Krishna Gitavali, Vinay Patrika, Barvai Ramayan, Parvati Mangal, Janki Mangal, Ramagya Prashna, Vairagya Sandipani, Hanuman Bahuk."
        }
      else if self.strTitle == "About Ramkatha"{
        self.lblDetails.text = "With the Blessings and Krupa of Tribhuvandas Dada, the Grandfather and Guru of Morari Bapu, Morari Bapu started reciting Ramkatha, based on Ramcharitmanas of Goswami Tulsidasji, at the age of 14 years. He recited his First Ramkatha in Ramji Mandir of Talgajrada village in the year 1960. This Katha was of 30 Days (Mas Parayan). Initially, Morari Bapu was reciting Ramkatha in two sessions, morning &amp; afternoon, in a day. Later on, he started reciting Ramkatha only for one session in a day. At present, Morari Bapu recites Ramkatha for nine (9) days, 1 st day afternoon session &amp; for rest 8 days, morning session. Recently Morari Bapu recited his 824 th Ramkatha at Ahmedabad, Gujarat. During his Katha yatra, Morari Bapu has covered various characters, events, themes of Ramcharitmanas as main subject of Ramkatha. According to the subject of particular Ramkatha, Morari Bapu selects the main Chopai from Ramcharitmanas for that Ramkatha. Morari Bapu has recited Ramkatha in almost all major places in India and abroad."
        }
      else if self.strTitle == "About Ramji Mandir"{
        self.lblDetails.text = "The Ramji Mandir is located in Talgajrada Village. The old Ramji Mandir has been renovated twice since the ancient time. In the present temple, the Ram Panchayatan consisting of Lord Ram, Sitaji, Lakshmanji, Bharatji, Shatrughnji and Hanumanji are installed in center. On the left side of Ram Panchayatan, there is an idol of Goswami Tulsidasji Maharaj and on the right side; there is an idol of Shree Tribhuvandas Dada, the Grandfather and Guru of Morari Bapu. Normally in all Ram Temples, Lord Ram has Bow and Arrow but in this Ramji Mandir, the idol of Lord Ram is very unique in the nature, because this idol does not have Bow and Arrow in his arm. This may be the First Ram Temple where Lord Ram is without Bow &amp; Arrow. Next to Ramji Mandir, there is a small house which is the original birth place of Morari Bapu. In this House, Morari Bapu was born and brought up. This house has been renovated keeping its original shape as it is and now it is named as Tribhuvan Tirth. At a walking distance from Ramji Mandir, there is Shiv Mandir. In this temple, idols of Lord Shiva and Parvatiji are installed. This temple also has cremation ground. It is noteworthy that Ram Temple, Shiv Temple and Chitrakutdham – Shree Hanumanji Maharaj Temple do not have donation boxes as per the guidelines of Morari Bapu."
        }
        
    }
    
  }
    
    /*cell.lblTitle.text = "About Talgajarda"
    cell.lblTitle.text = "About Shenjal"
    cell.lblTitle.text = "About Gurukul"
    cell.lblTitle.text = "About Chitrakutdham"
    cell.lblTitle.text = "About Chitrakutdham Trust"
    cell.lblTitle.text = "About Tulsidas Ji"
    cell.lblTitle.text = "About Ramkatha"*/

  
  //MARK:- Button Event
  @IBAction func btnMenu(_ sender: Any) {
    Utility.menu_Show(onViewController: self)
  }
  
  @IBAction func btnHanumanChalisha(_ sender: Any) {
    let storyboardCustom : UIStoryboard = UIStoryboard(name: Custome_Storyboard, bundle: nil)
    let objVC = storyboardCustom.instantiateViewController(withIdentifier: "HanumanChalishaVC") as? HanumanChalishaVC
    self.navigationController?.pushViewController(objVC!, animated: true)
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
      
      let storyboard = UIStoryboard(name: Dashboard_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiVC") as! KathaChopaiVC
      vc.screenDirection = .Katha_Chopai
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Ram Charitra Manas"{
      //Ram Charitra Manas
      let storyboard = UIStoryboard(name: Dashboard_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiVC") as! KathaChopaiVC
      vc.screenDirection = .Ram_Charit_Manas
      navigationController?.pushViewController(vc, animated:  true)
      
     }else if ScreenName == "Upcoing Katha"{
      //Upcoing Katha
      
      let storyboard = UIStoryboard(name: Dashboard_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "UpComingKathasVC") as! UpComingKathasVC
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Quotes"{
      //Quotes
      let storyboard = UIStoryboard(name: Dashboard_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaChopaiVC") as! KathaChopaiVC
      vc.screenDirection = .Quotes
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Daily Katha Clip"{
      //Daily Katha Clip
      let storyboard = UIStoryboard(name: Media_Storyboard, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DailyKathaClipVC") as! DailyKathaClipVC
            navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Live Katha Audio"{
      //Live Katha Audio
      let storyboard = UIStoryboard(name: Menu_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
      vc.screenDirection = .Live_Katha_Streaming_Audio
      vc.strTitle = "Live Katha Audio"
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "You Tube Channel"{
      //You Tube Channel
      let storyboard = UIStoryboard(name: Menu_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
      vc.screenDirection = .Moraribapu_Youtube_Channel
      vc.strTitle = "Morari Bapu Youtube Channel"
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Live Katha Video"{
      //Live Katha Video
      let storyboard = UIStoryboard(name: Menu_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
      vc.screenDirection = .Live_Katha_Streaming_Video
      vc.strTitle = "Live Katha Video"
      navigationController?.pushViewController(vc, animated:  true)
      
    }
    else if ScreenName == "Media"{
      //Media
      
      let storyboard = UIStoryboard(name: Menu_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
      vc.screenDirection = .Media
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated:  true)
        }
      
      
    }else if ScreenName == "What's New"{
      //What's New
      let storyboard = UIStoryboard(name: Menu_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
      vc.screenDirection = .Whats_New
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Sangeet Ni Duniya"{
      //Sangeet Ni Duniya
      let storyboard = UIStoryboard(name: Menu_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
      vc.screenDirection = .Sangeet_Ni_Duniya_Online_Shop
      vc.strTitle = "Sangeet Ni Duniya Online Shop"
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Setting"{
      //Setting
      
      let storyboard = UIStoryboard(name: Menu_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
      vc.screenDirection = .Settings
      navigationController?.pushViewController(vc, animated:  true)
      
     }else if ScreenName == "Search"{
      //Search
      
   let storyboard = UIStoryboard(name: Menu_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated:  true)
        }
       }else if ScreenName == "Favourites"{
      //Favourites
      
      let storyboard = UIStoryboard(name: Media_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "FavouriteVC") as! FavouriteVC
      navigationController?.pushViewController(vc, animated:  true)
    }else if ScreenName == "Events"{
      //Events
      let storyboard = UIStoryboard(name: Dashboard_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "EventsVC") as! EventsVC
      navigationController?.pushViewController(vc, animated:  true)
      
    }else if ScreenName == "Katha Ebook"{
      //Katha Ebook
      
      let storyboard = UIStoryboard(name: Menu_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "KathaEBookVC") as! KathaEBookVC
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated:  true)
        }
      
    }else if ScreenName == "Privacy Notice"{
      //Privacy Notice

      let storyboard = UIStoryboard(name: Menu_Storyboard, bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "AboutTheAppVC") as! AboutTheAppVC
      vc.strTitle = "Privacy Notice"
      DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated:  true)
      }
      
    }
  }
}
