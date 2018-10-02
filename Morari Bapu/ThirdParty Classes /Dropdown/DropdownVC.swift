//
//  DropdownVC.swift
//  Doggie
//
//  Created by Bhavin Chauhan on 07/08/18.
//  Copyright © 2018 Bhavin Chauhan. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import IQKeyboardManagerSwift
import Kingfisher
import SwiftyUserDefaults
import SwiftyUserDefaults

protocol DropDownDelegate: class {
    func dropDownResult(_ index: Int?, _ strTitle: String?)
}

class DropdownVC: UIViewController {

    @IBOutlet var tblDropDown: UITableView!
    
    @IBOutlet var constraintDropDownHeight: NSLayoutConstraint!
   
    weak var delegate: DropDownDelegate?
    
    var arrPetList = NSArray()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblDropDown.isHidden = true
        tblDropDown.tableFooterView = UIView.init(frame: .zero)
        tblDropDown.separatorInset = .zero
        tblDropDown.layoutMargins = .zero
        
        tblDropDown.rowHeight = 80
        tblDropDown.estimatedRowHeight = UITableViewAutomaticDimension

        tblDropDown.layer.shadowColor = UIColor.black.cgColor
        tblDropDown.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        tblDropDown.layer.shadowOpacity = 0.3
        tblDropDown.layer.shadowRadius = 2.0
        
    }

    // handle notification
    @objc func getPetList(_ notification: NSNotification) {
     
        getPetList()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPetList()
    }
    
    @IBAction func dismissDropDown(_ sender: Any) {
        Utility.dropDown_Hide(onViewController: self)
    }
    
    //MARK: API Call
    func getPetList() {
        
        arrPetList = Utility_CoreData().fetchData(entityName:Utility_CoreData.cd_Entity_Pet_List , prediction: "")
        tblDropDown.isHidden = false
        
        if arrPetList.count != 0{
            tblDropDown.reloadData()
        }else{
            tblDropDown.reloadData()

        }
            
    }
    
    
}
    //MARK: - TableView Delgate
    extension DropdownVC : UITableViewDelegate, UITableViewDataSource{
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrPetList.count + 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cellIdentifier = "DropDownTableViewCell"
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DropDownTableViewCell  else {
                fatalError("The dequeued cell is not an instance of VETolutionLeftRightTableViewCell")
            }
            
     
            
            if arrPetList.count == indexPath.row
            {
                cell.imgProfilePic.isHidden = true
                cell.lblTitle.isHidden = true
                cell.lblAddNewPet.isHidden = false
                
            }else{
                
                let dictPet = arrPetList[indexPath.row]
                let petId = (dictPet as AnyObject).value(forKey: Utility_CoreData.cdKey_Pet_Id) as! String
                let petName = (dictPet as AnyObject).value(forKey: Utility_CoreData.cdKey_Pet_Full_Name) as! String
                let petImage = (dictPet as AnyObject).value(forKey: Utility_CoreData.cdKey_Pet_Image) as! String
                
                cell.lblTitle.text = petName
                
                let placeHolder = UIImage(named: "placeholder")
                
                cell.imgProfilePic.kf.indicatorType = .activity
                cell.imgProfilePic.kf.setImage(with: URL(string: petImage), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
                
            
                
                let pet_id = Defaults[.PetId_User_Defaults]
                
                if pet_id != ""{
                    if pet_id == petId{
                        cell.imgProfilePic.layer.masksToBounds = true
                        cell.imgProfilePic.layer.borderColor = color_Green_Dark.cgColor
                        cell.imgProfilePic.layer.borderWidth = 3
                        cell.imgProfilePic.layer.cornerRadius = cell.imgProfilePic.frame.size.height / 2
                        cell.contentView.backgroundColor = color_Green_Dark.withAlphaComponent(0.3)
                        
                        if petImage == ""{
                            cell.imgProfilePic.imageColorChange(color: color_Green_Dark)
                        }
                    }
                    else
                    {
                        
                        if petImage == ""{
                            cell.imgProfilePic.imageColorChange(color: UIColor.black)
                        }
                        
                        cell.imgProfilePic.layer.masksToBounds = true
                        cell.imgProfilePic.layer.borderColor = UIColor.black.cgColor
                        cell.imgProfilePic.layer.borderWidth = 3
                        cell.imgProfilePic.layer.cornerRadius = cell.imgProfilePic.frame.size.height / 2
                        cell.contentView.backgroundColor = UIColor.white
                    }
                }
                else{
                    cell.imgProfilePic.layer.masksToBounds = true
                    cell.imgProfilePic.layer.borderColor = UIColor.black.cgColor
                    cell.imgProfilePic.layer.borderWidth = 3
                    cell.imgProfilePic.layer.cornerRadius = cell.imgProfilePic.frame.size.height / 2
                    cell.contentView.backgroundColor = UIColor.white
                    
                }
                cell.lblAddNewPet.isHidden = true
                cell.imgProfilePic.isHidden = false
                cell.lblTitle.isHidden = false
            }
            
            
            if tableView.contentSize.height < self.view.frame.size.height * 0.8{
                constraintDropDownHeight.constant = tableView.contentSize.height
                self.view.layoutIfNeeded()
            }
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            return 80
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
            if arrPetList.count == indexPath.row
            {
                delegate?.dropDownResult(indexPath.row, "addNewPet")
                Utility.dropDown_Hide(onViewController: self)
                
            }else{
                let dictPet = arrPetList[indexPath.row]
                let petId = (dictPet as AnyObject).value(forKey: Utility_CoreData.cdKey_Pet_Id) as! String
                let species = (dictPet as AnyObject).value(forKey: Utility_CoreData.cdKey_Pet_Species) as! String
                let petRole = (dictPet as AnyObject).value(forKey: Utility_CoreData.cdKey_Pet_Role) as! String

                
                if Defaults[.PetId_User_Defaults] == petId{
                    delegate?.dropDownResult(indexPath.row, "Hello")
                    Utility.dropDown_Hide(onViewController: self)
                }
                else{
                    
                    Defaults[.PetId_User_Defaults] = petId
                    Defaults[.Species_User_Defaults] = species
                    Defaults[.Pet_Role_Defaults] = petRole
                    
                    tblDropDown.reloadData()
                    
                   // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload_upcomming_appointment"), object: nil)
                    Utility.dropDown_Hide(onViewController: self)
                    delegate?.dropDownResult(indexPath.row, "petChange")
                   
                }
            }
        }
    }

extension DropdownVC : UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: tblDropDown))!{
            return false
        }
        return true
    }
}
