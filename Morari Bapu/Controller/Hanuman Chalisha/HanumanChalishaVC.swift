//
//  HanumanChalishaVC.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 09/10/18.
//  Copyright © 2018 Bhavin Chauhan. All rights reserved.
//

import UIKit

class HanumanChalishaVC: UIViewController {

  @IBOutlet weak var lblDescription: UILabel!
  
  override func viewDidLoad() {
        super.viewDidLoad()

    
    let strHanumanchalisha = "<h2>हनुमान   चालीसा</h2><h2>Hanuman Chalisa</h2><p> શ્રી ગુરુ ચરણ સરોજ રજ નિજમન મુકુર સુધારિ |\n" +
    "વરણૌ રઘુવર વિમલયશ જો દાયક ફલચારિ ||</p><p>श्रीगुरु चरण् सरोजरज, निजमनमुकुर सुधार ।\n" +
      "बरणौ रघुबर बिमल यश, जो दायक फलचार ॥</p><p>Shrii-Guru Carann Saroja-Raja, Nija-Mana-Mukura Sudhaara |\n" +
      "Barannau Raghu-Bara Bimala Yasha, Jo Daayaka Phala-Caara ||</p><h5>\n" +
      "Meaning:</h5><p>With the Dust of the Lotus Feet of Sri Gurudeva, I Clean the Mirror of my Mind.\n" +
      "I Narrate the Sacred Glory of Sri Raghubar (Sri Rama Chandra), who Bestowsthe Four Fruits of Life (Dharma, Artha, Kama and \n" +
      "Moksha).</p>" +
      "<p>બુદ્ધિહીન તનુજાનિકૈ સુમિરૌ પવન કુમાર |\n" +
      "બલ બુદ્ધિ વિદ્યા દેહુ મોહિ હરહુ કલેશ વિકાર ||</p><p>बुद्धिहीन तनु जानिके, सुमिरौं पवन कुमार ।\n" +
      "बल बुद्धिविद्या देहु मोहिं, हरहु कलेश विकार ॥</p><p>Buddhi-Hiina Tanu Jaanike, Sumirau Pavan Kumaar |\n" +
      "Bala Buddhi-Vidyaa Dehu Mohi, Harahu Kalesha Vikaar ||</p><h5>" +
      "Meaning:</h5><p>Considering Myself as Ignorant, I Meditate on You, O Pavan Kumar(Hanuman).\n" +
      "Bestow on me Strength, Wisdom and Knowledge, and Remove my Afflictionsand Blemishes.\n</p>" + "<p>જય હનુમાન જ્ઞાન ગુણ સાગર |\n" +
      "જય કપીશ તિહુ લોક ઉજાગર ||</p><p>जय हनुमान ज्ञान गुण सागर ।\n" +
      "जै कपीस तिहुँलोक उजागर ॥</p><p>Jay Hanumaan Jnaan Gunn Saagar |\n" +
      "Jai Kapiis Tihu-Lok Ujaagar ||</p><h5>" +
      "Meaning:</h5><p>Victory to You, O Hanuman, Who is the Ocean of Wisdom and Virtue,\n" +
    "Victory to the Lord of the Monkeys, Who is the Enlightener of the Three Worlds.</p>" + "<p>રામદૂત અતુલિત બલધામા |\u{2028} અંજનિ પુત્ર પવનસુત નામા ||</p><p>रामदूत अतुलित बलधामा ।\n" +
    "अंजनि-पुत्र पवन-सुत नामा ॥</p><p>Raama-Duut Atulit Bala-Dhaamaa |\n" +
    "Anjani-Putra Pavan-Sut Naamaa ||</p><h5>" +
    "Meaning:</h5><p>You are the Messenger of Sri Rama possessing Immeasurable Strength,\n" +
    "You are Known as Anjani-Putra (son of Anjani) and Pavana-Suta (son of Pavana, the wind-god).\n</p>" + "<p>મહાવીર વિક્રમ બજરઙ્ગી |\n" +
    "કુમતિ નિવાર સુમતિ કે સઙ્ગી ||</p><p>महाबीर बिक्रम बजरंगी ।\n" +
    "कुमति निवार सुमति के संगी ॥</p><p>Mahaa-biir Bikrama Bajarangii |\n" +
    "Kumati Nivaar Sumati Ke Sangii ||</p><h5>" +
    "Meaning:</h5><p>You are a Great Hero, extremely Valiant, and body as strong as Thunderbolt,\n" +
    "You are the Dispeller of Evil Thoughts and Companion of Good Sense and Wisdom.\n" +
    "\n</p>" + "<p>કંચન વરણ વિરાજ સુવેશા |\u{2028}કાનન કુંડલ કુંચિત કેશા ||</p><p> कंचन बरण बिराज सुबेशा ।\n" +
    "कानन कुंडल कुंचित केशा ॥</p><p>Kancan Barann Biraaj Subeshaa |\n" +
    "Kaanan Kunddala Kuncita Keshaa ||</p><h5>" +
    "Meaning:</h5><p>You possess a Golden Hue, and you are Neatly Dressed,\n" +
    "You wear Ear-Rings and have beautiful Curly Hair.</p>" + "<p>હાથવજ્ર ઔ ધ્વજા વિરાજૈ |\u{2028}કાંથે મૂંજ જનેવૂ સાજૈ ||</p><p>हाथ बज्र औ ध्वजा बिराजै ।\n" +
    "काँधे मूँज जनेऊ साजै ॥</p><p>Haath Bajra Au Dhvajaa Biraajai |\n" +
    "Kaandhe Muuj Janeuu Saajai ||</p><h5>" +
    "Meaning:</h5><p>You hold the Thunderbolt and the Flag in your Hands.\n" +
    "You wear the Sacred Thread across your Shoulder.</p>" + "<p>શંકર સુવન કેસરી નન્દન |\u{2028}તેજ પ્રતાપ મહાજગ વન્દન ||</p><p>शंकर-सुवन केशरी-नन्दन ।\n" +
    "तेज प्रताप महा जग-वंदन ॥</p><p>Shankar-Suvan Kesharii-Nandan |\n" +
    "Teja Prataap Mahaa Jag-Vandan ||</p><h5>" +
    "Meaning:</h5><p>You are the Incarnation of Lord Shiva and Son of Kesari,\n" +
    "You are Adored by the whole World on account of your Great Strength and Courage.\n</p>" + "<p>વિદ્યાવાન ગુણી અતિ ચાતુર |\u{2028}રામ કાજ કરિવે કો આતુર ||</p><p>विद्यावान गुणी अति चातुर ।\n" +
    "राम काज करिबे को आतुर ॥</p><p>Vidyaavaan Gunnii Ati Caatur |\n" +
    "Raam Kaaj Karibe Ko Aatur ||</p><h5>" +
    "Meaning:</h5><p>You are Learned, Virtuous and Extremely Intelligent,\n" +
    "You are always Eager to do the Works of Sri Rama.</p>" + "<p>પ્રભુ ચરિત્ર સુનિવે કો રસિયા |\u{2028}રામલખન સીતા મન બસિયા ||</p><p>प्रभु चरित्र सुनिबे को रसिया ।\n" +
    "रामलषण सीता मन बसिया ॥</p><p>Prabhu Caritra Sunibe Ko Rasiyaa |\n" +
    "Raamalassann Siitaa Man Basiyaa ||</p><h5>" +
    "Meaning:</h5><p>You Delight in Listening to the Glories of Sri Rama,\n" +
    "You have Sri Rama, Sri Lakshmana and Devi Sita Dwelling in your Heart.</p>" + "<p>પ્રભુ ચરિત્ર સુનિવે કો રસિયા |\u{2028}રામલખન સીતા મન બસિયા ||</p><p>सूक्ष्म रूपधरि सियहिं दिखावा ।\n" +
    "विकट रूप धरि लंक जरावा ॥</p><p>Suukssma Ruupadhari Siyahi Dikhaavaa |\n" +
    "Vikatt Ruup Dhari Lamka Jaraavaa ||\n</p><h5>" +
    "Meaning:</h5><p>You Appeared before Devi Sita Assuming a Diminutive Form (in Lanka),\n" +
    "You Assumed an Awesome Form and Burnt Lanka.</p>" + "<p>ભીમ રૂપધરિ અસુર સંહારે |\u{2028}રામચંદ્ર કે કાજ સંવારે ||</p><p>भीम रूप धरि असुर सँहारे ।\n" +
    "रामचन्द्र के काज सँवारे ॥</p><p>Bhiim Ruup Dhari Asur Samhaare |\n" +
    "Raamacandra Ke Kaaj Samvaare ||\n</p><h5>" +
    "Meaning:</h5><p>You Assumed a Gigantic Form and Destroyed the Demons,\n" +
    "Thereby Accomplishing the Task of Sri Rama.</p>" + "<p>લાય સંજીવન લખન જિયાયે |\u{2028}શ્રી રઘુવીર હરષિ ઉરલાયે ||</p><p>लाय सजीवन लखन जियाये ।\n" +
    "श्री रघुबीर हरषि उर लाये ॥</p><p>Laay Sajiivan Lakhan Jiyaaye |\n" +
    "Shrii Raghubiir Harassi Ur Laaye ||\n</p><h5>" +
    "Meaning:</h5><p>You Brought the Sanjivana herb and Revived Sri Lakshmana.\n" +
    "Because of this Sri Rama Embraced You overflowing with Joy.</p>" + "<p>રઘુપતિ કીન્હી બહુત બડાયી |\u{2028}તુમ મમ પ્રિય ભરતહિ સમ ભાયી ||</p><p>रघुपति कीन्ही बहुत बडाई ।\n" +
    "तुम मम प्रिय भरतहिसम भाई ॥</p><p>Raghupati Kiinhii Bahut Baddaaii |\n" +
    "Tum Mam Priya Bharatahisam Bhaaii ||</p><h5>" +
    "Meaning:</h5><p>Sri Rama Praised You Greatly,\n" +
    "And said: \"You are as dear to me as my brother Bharata\".\n</p>" + "<p>સહસ વદન તુમ્હરો યશગાવૈ |\u{2028}અસ કહિ શ્રીપતિ કણ્ઠ લગાવૈ ||</p><p>सहस बदन तुम्हरो यश गावैं ।\n" +
    "अस कहि श्रीपति कण्ठ लगावैं ॥</p><p>Sahas Badan Tumharo Yash Gaavai |\n" +
    "As Kahi Shriipati Kanntth Lagaavai ||</p><h5>" +
    "Meaning:</h5><p>\"The Thousand Headed Seshnag Sings Your Glory\",\n" +
    "Said Sri Rama to You taking you in his Embrace.\n</p>" + "<p>સનકાદિક બ્રહ્માદિ મુનીશા |\u{2028}નારદ શારદ સહિત અહીશા ||</p><p>सनकादिक ब्रह्मादि मुनीशा ।\n" +
    "नारद शारद सहित अहीशा ॥</p><p>Sanakaadik Brahmaadi Muniishaa |\n" +
    "Naarad Shaarad Sahit Ahiishaa ||</p><h5>" +
    "Meaning:</h5><p>Sanaka and other Sages, Lord Brahma and other Gods,\n" +
    "Narada, Devi Saraswati and Seshnag.</p>" + "<p>યમ કુબેર દિગપાલ જહાં તે |\u{2028}કવિ કોવિદ કહિ સકે કહાં તે ||</p><p>यम कुबेर दिगपाल जहाँते ।\n" +
    "कवि कोविद कहि सकैं कहाँते ॥</p><p>Yam Kuber Digapaal Jahaate |\n" +
    "Kavi Kovid Kahi Sakai Kahaate ||</p><h5>" +
    "Meaning:</h5><p>Yama (god of death), Kubera (god of wealth), Digpalas (the guardian deities),\n" +
    "Poets and Scholars have not been able to Describe Your Glories in full.\n" +
    "\n</p>" + "<p>તુમ ઉપકાર સુગ્રીવહિ કીન્હા |\u{2028}રામ મિલાય રાજપદ દીન્હા ||</p><p>तुम उपकार सुग्रीवहिं कीन्हा ।\n" +
    "राम मिलाय राजपद दीन्हा ॥</p><p>Tum Upakaar Sugriivahi Kiinhaa |\n" +
    "Raam Milaay Raajapad Diinhaa ||</p><h5>" +
    "Meaning:</h5><p>You Rendered a great Help to Sugriva.\n" +
    "You Introduced him to Sri Rama and thereby Gave back his Kingdom.</p>" + "<p>તુમ્હરો મન્ત્ર વિભીષણ માના |\u{2028}લંકેશ્વર ભયે સબ જગ જાના ||</p><p>तुम्हरो मंत्र विभीषण माना ।\n" +
    "लंकेश्वर भये सब जग जाना ॥</p><p>Tumharo Mamtra Vibhiissann Maanaa |\n" +
    "Lamkeshvar Bhaye Sab Jag Jaanaa ||</p><h5>" +
    "Meaning:</h5><p>Vibhisana Followed your Advice,\n" +
    "And the Whole World Knows that he became the King of Lanka.</p>" + "<p>યુગ સહસ્ર યોજન પર ભાનૂ |\u{2028}લીલ્યો તાહિ મધુર ફલ જાનૂ ||</p><p>युग सहस्र योजन पर भानू ।\n" +
    "लील्यो ताहि मधुर फल जानू ॥</p><p>Yuga Sahasra Yojana Para Bhaanuu |\n" +
    "Liilyo Taahi Madhura Phala Jaanuu ||\n</p><h5>" +
    "Meaning:</h5><p>The Sun which was at a distance of Sixteen Thousand Miles,\n" +
    "You Swallowed It (the Sun) thinking it to be a Sweet Fruit.</p>" + "<p>પ્રભુ મુદ્રિકા મેલિ મુખ માહી |\u{2028}જલધિ લાંઘિ ગયે અચરજ નાહી ||</p><p>प्रभु मुद्रिका मेलि मुख माहीं ।\n" +
    "जलधि लाँधि गये अचरजनाहीं ॥</p><p>Prabhu Mudrikaa Meli Mukh Maahii |\n" +
    "Jaladhi Laadhi Gaye Acarajanaahii ||</p><h5>" +
    "Meaning:</h5><p>Carrying Lord Sri Rama's Ring in your Mouth,\n" +
    "You Crossed the Ocean, no Wonder in that.</p>" + "<p>દુર્ગમ કાજ જગત કે જેતે |\u{2028}સુગમ અનુગ્રહ તુમ્હરે તેતે ||</p><p>दुर्गम काज जगत के जेते ।\n" +
    "सुगम अनुग्रह तुम्हरे तेते ॥</p><p>Durgam Kaaja Jagat Ke Jete |\n" +
    "Sugam Anugrah Tumhare Tete ||</p><h5>" +
    "Meaning:</h5><p>All the Difficult Tasks in this World,\n" +
    "Are Rendered Easy by your Grace.</p>" + "<p>રામ દુઆરે તુમ રખવારે |\u{2028}હોત ન આજ્ઞા બિનુ પૈસારે ||</p><p>राम दुआरे तुम रखवारे ।\n" +
    "होत न आज्ञा बिन पैसारे ॥</p><p>Raam Duaare Tum Rakhavaare |\n" +
    "Hot Na Aajnyaa Bin Paisaare ||</p><h5>" +
    "Meaning:</h5><p>You are the Gate-Keeper of Sri Rama's Kingdom.\n" +
    "No one can Enter without Your Permission.\n</p>" + "<p>સબ સુખ લહૈ તુમ્હારી શરણા |\u{2028}તુમ રક્ષક કાહૂ કો ડર ના ||</p><p>सब सुख लहै तुम्हारी सरना ।\n" +
    "तुम रक्षक काहू को डरना ॥</p><p>Sab Sukha Lahai Tumhaarii Saranaa |\n" +
    "Tum Rakssak Kaahuu Ko Ddaranaa ||</p><h5>" +
    "Meaning:</h5><p>Those who take Refuge in You enjoy all Happiness.\n" +
    "If You are the Protector, what is there to Fear?</p>" + "<p>આપન તેજ તુમ્હારો આપૈ |\u{2028}તીનોં લોક હાંક તે કાંપૈ ||</p><p>आपन तेज सम्हारो आपै ।\n" +
    "तीनों लोक हाँकते काँपै ॥</p><p>Aapan Tej Samhaaro Aapai |\n" +
    "Tiino Lok Haakate Kaapai ||</p><h5>" +
    "Meaning:</h5><p>You alone can Control Your Great Energy.\n" +
    "When you Roar, the Three Worlds Tremble.</p>" + "<p>ભૂત પિશાચ નિકટ નહિ આવૈ |\u{2028}મહવીર જબ નામ સુનાવૈ ||</p><p>भूत पिशाच निकट नहिं आवै ।\n" +
    "महाबीर जब नाम सुनावै ॥</p><p>Bhuut Pishaaca Nikatt Nahi Aavai |\n" +
    "Mahaabiir Jab Naam Sunaavai ||</p><h5>" +
    "Meaning:</h5><p>Ghosts and Evil Spirits will Not Come Near,\n" +
    "When one Utters the Name of Mahavir (Hanuman).</p>" + "<p>ભૂત પિશાચ નિકટ નહિ આવૈ |\u{2028}મહવીર જબ નામ સુનાવૈ ||</p><p>भूत पिशाच निकट नहिं आवै ।\n" +
    "महाबीर जब नाम सुनावै ॥</p><p>Bhuut Pishaaca Nikatt Nahi Aavai |\n" +
    "Mahaabiir Jab Naam Sunaavai ||</p><h5>" +
    "Meaning:</h5><p>Ghosts and Evil Spirits will Not Come Near,\n" +
    "When one Utters the Name of Mahavir (Hanuman).</p>" + "<p>નાસૈ રોગ હરૈ સબ પીરા |\u{2028}જપત નિરંતર હનુમત વીરા ||</p><p>नाशौ रोग हरै सब पीरा ।\n" +
    "जपत निरन्तर हनुमत बीरा ॥</p><p>Naashau Rog Harai Sab Piiraa |\n" +
    "Japat Nirantar Hanumat Biiraa ||</p><h5>" +
    "Meaning:</h5><p>You Destroy Diseases and Remove all Pains,\n" +
    "When one Utters your Name Continuously.</p>" + "<p>સંકટ સેં હનુમાન છુડાવૈ |\u{2028}મન ક્રમ વચન ધ્યાન જો લાવૈ ||</p><p>संकट से हनुमान छुडावै ।\n" +
    "मन क्रम बचन ध्यान जो लावै ॥</p><p>Samkatt Se Hanumaan Chuddaavai |\n" +
    "Man Kram Bacan Dhyaan Jo Laavai ||</p><h5>" +
    "Meaning:</h5><p>Hanuman Frees one from Difficulties,\n" +
    "When one Meditates on Him with Mind, Deed and Words.</p>" + "<p>સબ પર રામ તપસ્વી રાજા |\u{2028}તિનકે કાજ સકલ તુમ સાજા ||</p><p>सब पर राम तपस्वी राजा ।\n" +
    "तिनके काज सकल तुम साजा ॥</p><p>Sab Par Raam Tapasvii Raajaa |\n" +
    "Tinake Kaaj Sakal Tum Saajaa ||</p><h5>" +
    "Meaning:</h5><p>Sri Rama is the King of the Tapaswis (devotees engaged in penances).\n" +
    "And You (Hanuman) Fulfill all Works of Sri Rama (as a caretaker).</p>" + "<p>ઔર મનોરધ જો કોયિ લાવૈ |\u{2028}તાસુ અમિત જીવન ફલ પાવૈ ||</p><p>और मनोरथ जो कोइ लावै ।\n" +
    "सोइ अमित जीवन फल पावै ॥</p><p>Aur Manorath Jo Koi Laavai |\n" +
    "Soi Amit Jiivan Phal Paavai ||</p><h5>" +
    "Meaning:</h5><p>Devotees who have any Other Desires,\n" +
    "Will ultimately get the Highest Fruit of Life.</p>" + "<p>ચારો યુગ પરિતાપ તુમ્હારા |\u{2028}હૈ પરસિદ્ધ જગત ઉજિયારા ||</p><p>चारों युग परताप तुम्हारा ।\n" +
    "है परसिद्ध जगत उजियारा ॥</p><p>Caaro Yug Parataap Tumhaaraa |\n" +
    "Hai Parasiddh Jagat Ujiyaaraa ||</p><h5>" +
    "Meaning:</h5><p>Your Glory prevails in all the Four Ages.\n" +
    "And your Fame Radiates throughout the World.</p>" + "<p>સાધુ સન્ત કે તુમ રખવારે |\u{2028}અસુર નિકન્દન રામ દુલારે ||</p><p>साधु संत के तुम रखवारे ।\n" +
    "असुर निकंदन राम दुलारे ॥</p><p>Saadhu Sant Ke Tum Rakhavaare |\n" +
    "Asur Nikandan Raam Dulaare ||</p><h5>" +
    "Meaning:</h5><p>You are the Saviour of the Saints and Sages.\n" +
    "You Destroy the Demons, O Beloved of Sri Rama.</p>" + "<p>અષ્ઠસિદ્ધિ નવ નિધિ કે દાતા |\u{2028}અસ વર દીન્હ જાનકી માતા ||</p><p>अष्टसिद्धि नव निधि के दाता ।\n" +
    "अस बर दीन जानकी माता ॥</p><p>Assttasiddhi Nava Nidhi Ke Daataa |\n" +
    "As Bar Diin Jaanakii Maataa ||</p><h5>" +
    "Meaning:</h5><p>You can Give the Eight Siddhis (supernatural powers) and Nine Nidhis (types of devotions).\n" +
    "Mother Janaki (Devi Sita) gave this Boon to you.</p>" + "<p>રામ રસાયન તુમ્હારે પાસા |\u{2028}સાદ રહો રઘુપતિ કે દાસા ||</p><p>राम रसायन तुम्हरे पासा ।\n" +
    "सदा रहो रघुपति के दासा ॥</p><p>Raam Rasaayan Tumhare Paasaa |\n" +
    "Sadaa Raho Raghupati Ke Daasaa ||</p><h5>" +
    "Meaning:</h5><p>You hold the Essence of Devotion to Sri Rama.\n" +
    "You Always Remain as the Servant of Raghupati (Sri Rama).</p>" + "<p>તુમ્હરે ભજન રામકો પાવૈ |\u{2028}જન્મ જન્મ કે દુખ બિસરાવૈ ||</p><p>तुम्हरे भजन रामको पावै ।\n" +
    "जन्म जन्म के दुख बिसरावै ॥</p><p>Tumhare Bhajan Raamako Paavai |\n" +
    "Janma Janma Ke Dukh Bisaraavai ||</p><h5>" +
    "Meaning:</h5><p>Through Devotion to You, one gets Sri Rama,\n" +
    "Thereby getting Free of the Sorrows of Life after Life.</p>" + "<p>અંત કાલ રઘુવર પુરજાયી |\u{2028}જહાં જન્મ હરિભક્ત કહાયી ||</p><p>अन्त काल रघुपति पुर जाई ।\n" +
    "जहाँ जन्म हरिभक्त कहाई ॥</p><p>Anta Kaal Raghupati Pur Jaaii |\n" +
    "Jahaa Janma Hari-Bhakta Kahaaii ||</p><h5>" +
    "Meaning:</h5><p>At the End one Goes to the Abode of Raghupati (Sri Rama).\n" +
    "Where one is Known as the Devotee of Hari.</p>" + "<p>ઔર દેવતા ચિત્ત ન ધરયી |\u{2028}હનુમત સેયિ સર્વ સુખ કરયી ||</p><p>और देवता चित्त न धरई ।\n" +
    "हनुमत सेइ सर्व सुख करई ॥</p><p>Aur Devataa Citta Na Dharaii |\n" +
    "Hanumat Sei Sarva Sukh Karaii ||</p><h5>" +
    "Meaning:</h5><p>Even without Worshipping any Other Deities,\n" +
    "One Gets All Happiness who Worships Sri Hanuman.</p>" + "<p>સંકટ કટૈ મિટૈ સબ પીરા |\u{2028}જો સુમિરૈ હનુમત બલ વીરા ||</p><p>संकट हरै मिटै सब पीरा ।\n" +
    "जो सुमिरै हनुमत बल बीरा ॥</p><p>Sankatta Harai Mittai Sab Piiraa |\n" +
    "Jo Sumirai Hanumat Bala Biiraa ||</p><h5>" +
    "Meaning:</h5><p>Difficulties Disappear and Sorrows are Removed,\n" +
    "For Those who Contemplate on the Powerful Sri Hanuman.</p>" + "<p>જૈ જૈ જૈ હનુમાન ગોસાયી |\u{2028}કૃપા કરો ગુરુદેવ કી નાયી ||</p><p>जै जै जै हनुमान गोसाई ।\n" +
    "कृपा करहु गुरुदेव की नाई ॥</p><p>Jai Jai Jai Hanumaan Gosaaii |\n" +
    "Krpaa Karahu Gurudev Kii Naaii ||</p><h5>" +
    "Meaning:</h5><p>Victory, Victory, Victory to You, O Hanuman,\n" +
    "Please Bestow your Grace as our Supreme Guru.</p>" + "<p>જો શત વાર પાઠ કર કોયી |\u{2028}છૂટહિ બન્દિ મહા સુખ હોયી ||</p><p>जोह शत बार पाठ कर जोई ।\n" +
    "छुटहि बन्दि महासुख होई ॥</p><p>Joh Shat Baar Paattha Kar Joii |\n" +
    "Chuttahi Bandi Mahaasukh Hoii ||</p><h5>" +
    "Meaning:</h5><p>Those who Recite this Hanuman Chalisa one hundred times (with devotion),\n" +
    "Will get Freed from Worldly Bondage and get Great Happiness.</p>" + "<p>જો યહ પડૈ હનુમાન ચાલીસા |\u{2028}હોય સિદ્ધિ સાખી ગૌરીશા ||</p><p>जो यह पढै हनुमान चालीसा ।\n" +
    "होय सिद्धि साखी गौरीसा ॥</p><p>Jo Yah Paddhai Hanumaan Caaliisaa |\n" +
    "Hoy Siddhi Saakhii Gauriisaa ||</p><h5>" +
    "Meaning:</h5><p>Those who Read the Hanuman Chalisa (with devotion),\n" +
    "Will become Perfect, Lord Shiva is the Witness.</p>" + "<p>તુલસીદાસ સદા હરિ ચેરા |\u{2028}કીજૈ નાથ હૃદય મહ ડેરા ||</p><p>तुलसीदास सदा हरि चेरा ।\n" +
    "कीजै नाथ हृदय महँ डेरा ॥</p><p>Tulasiidaas Sadaa Hari Ceraa |\n" +
    "Kiijai Naatha Hrday Mah Dderaa ||</p><h5>" +
    "Meaning:</h5><p>Tulsidas who is Always the Servant of Hari.\n" +
    "Prays the Lord to Reside in his Heart.</p>" + "<p>પવન તનય સઙ્કટ હરણ, મઙ્ગળ મૂરતિ રૂપ |\u{2028}રામ લખન સીતા સહિત, હૃદય બસહુ સુરભૂપ ||</p><p>पवनतनय संकट हरन, मंगल मूरति रूप ।\n" +
    "रामलषन सीता सहित, हृदय बसहु सुरभूप ॥</p><p>Pavanatanaya Samkatt Harana, Mamgal Muurati Ruup |\n" +
    "Raamalassan Siitaa Sahit, Hrday Basahu Surabhuup ||</p><h5>" +
    "Meaning:</h5><p>Sri Hanuman, who is the Son of Pavana, who Removes Difficulties,\n" +
    "Who has an Auspicious Form,\n" +
    "With Sri Rama, Sri Lakshmana and Devi Sita,\n" +
    "Please Dwell in my Heart.</p>" + "<p>સિયાવર રામચન્દ્રકી જય | પવનસુત હનુમાનકી જય | બોલો ભાયી સબ સન્તનકી જય |</p>"
    
    DispatchQueue.main.async {
      self.lblDescription.attributedText = NSAttributedString(html: strHanumanchalisha)
    }
    
    }
    
  //MARK : Button Event
  @IBAction func btnBack(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func backToHome(_ sender: Any) {
    
    self.dismiss(animated: true, completion: nil)
    Utility.backToHome()
    
    
  }
  
  
}

extension String {
  var htmlToAttributedString: NSAttributedString? {
    guard let data = data(using: .utf8) else { return NSAttributedString() }
    do {
      return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
    } catch {
      return NSAttributedString()
    }
  }
  var htmlToString: String {
    return htmlToAttributedString?.string ?? ""
  }
}


extension NSAttributedString {
  internal convenience init?(html: String) {
    guard let data = html.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
      // not sure which is more reliable: String.Encoding.utf16 or String.Encoding.unicode
      return nil
    }
    guard let attributedString = try? NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else {
      return nil
    }
    self.init(attributedString: attributedString)
  }
}
