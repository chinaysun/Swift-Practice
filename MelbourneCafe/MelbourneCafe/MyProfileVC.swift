//
//  MyProfileVC.swift
//  MelbourneCafe
//
//  Created by SUN YU on 30/5/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class MyProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    //textField
    @IBOutlet weak var phoneNumberTextLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    
    //Edit & Save Buttons
    @IBOutlet weak var emailEditButton: UIButton!
    @IBOutlet weak var firstNameEditButton: UIButton!
    @IBOutlet weak var lastNameEditButton: UIButton!
    
    
    //associate buttons and textfield
    private var editTextFieldDict = [UIButton:UITextField]()
    
    
    private var Ph_number:String?
    private var myProfile = UserProfile()
    
    
    //validation method
    private var validationMethod = UserInfoValidation()
    
    
    //User Profile Image
    @IBOutlet weak var myProfileImage: UIImageView!
    
    
    //upload Button
    @IBOutlet weak var uploadButton: UIButton!
    
    
   // loading information from database and change UI
    
    private func updateUIWhenLoad()
    {
        phoneNumberTextLabel.text = UserDefaults.standard.object(forKey: "UserID") as! String?
        
        if myProfile.getInfoError {
            //alert method to show the error
            let alert = UIAlertController(title: "Notice", message: myProfile.errorInfo, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else
        {
            //update three textfield
            if !myProfile.userEmail.isEmpty
            {
                  emailTextField.text = myProfile.userEmail
            }
            
            if !myProfile.userFirstName.isEmpty
            {
                firstNameTextField.text = myProfile.userFirstName
            }
            
            if !myProfile.userLastName.isEmpty
            {
                lastNameTextField.text = myProfile.userLastName
            }
            
            //load the profile image
            self.myProfileImage.image = myProfile.userProfileImage
            self.roundMeToBeBeauty(oldImage: self.myProfileImage)
            
            
        }
        
    }
    
    
    //Tapped Edit Buttons
    @IBAction func editButtonsTapped(_ sender: UIButton) {
        
        
        if sender.currentTitle == "Edit"
        {
          self.eidtButtonTappedUIChange(sender: sender)
            
        }else
        {

            //check if it is Email
            let textFieldTag = (editTextFieldDict[sender]?.tag)!
            let textFieldText = (editTextFieldDict[sender]?.text)!
            
            if textFieldTag == 1
            {
                
                validationMethod.checkEmail(Email: textFieldText)
                
                if validationMethod.result
                {
                    
                    self.updateNewUserInfo(InfoTypeIndicator: textFieldTag, newUserInfo: textFieldText, editButton: sender)
                    
                }else
                {
                    //alert the error
                    let alert = UIAlertController(title: "Notice", message: "Please input correct Email", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }else
            {
                
                //not allow empty value
                if textFieldText == ""
                {
                    //alert the error
                    let alert = UIAlertController(title: "Notice", message: "Not Allow Empty Value", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }else
                {
                    //call update method
                    self.updateNewUserInfo(InfoTypeIndicator: textFieldTag, newUserInfo: textFieldText, editButton: sender)
             
                }
 
                
            }

            
        }
        
        
    }
    
    //check Login Status and Update the Value into database
    private func updateNewUserInfo(InfoTypeIndicator:Int,newUserInfo:String,editButton:UIButton)
    {
        //only logged in could update
        let checkLogginStatus = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        if !checkLogginStatus
        {
            // Go to login first
            self.goToLoginPageAlert()
            
        }else
        {
            //update the Database
            switch InfoTypeIndicator {
            case 1:
                myProfile.updateProfileInfo(Ph_number:self.Ph_number!,InfoType: "Email", newInfo: newUserInfo, Complication: {self.saveButtonTappedUIChange(sender: editButton)})
            case 2:
                myProfile.updateProfileInfo(Ph_number:self.Ph_number!,InfoType: "FirstName", newInfo: newUserInfo, Complication: {self.saveButtonTappedUIChange(sender: editButton)})
            case 3:
                myProfile.updateProfileInfo(Ph_number:self.Ph_number!,InfoType: "LastName", newInfo: newUserInfo, Complication: {self.saveButtonTappedUIChange(sender: editButton)})
            default:
                break
            }
         
        }
    }
    
    //change UI Func when Save being Tapped
    private func saveButtonTappedUIChange(sender:UIButton)
    {
        
        //alert update info
        let alert = UIAlertController(title: "Notice", message: myProfile.updatingInfo, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    
        //Not Matter Success or not just change the button UI

        sender.setTitle("Edit", for: UIControlState.normal)
            
        for item in editTextFieldDict
        {
            //button could be tapped
            item.key.isEnabled = true
                
            //textfield could not be edited
            item.value.isEnabled = false
            item.value.isUserInteractionEnabled = false
        }
            
        

        
    }
    
    
    //change UI Func when Edit being Tapped
    private func eidtButtonTappedUIChange(sender:UIButton)
    {
        //change the UIButton text to save
        sender.setTitle("Save", for: UIControlState.normal)
    
        //disable or enable the textfield
        for item in editTextFieldDict
        {
            if item.key.currentTitle == "Save"
            {
                item.value.isEnabled = true
                item.value.isUserInteractionEnabled = true
            }else
            {
               item.value.isEnabled = false
               item.key.isEnabled = false
            }
            
        }
        
    }
    
    
    @IBAction func uploadProfileImage(_ sender: UIButton) {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        myPickerController.allowsEditing = true
        
        self.present(myPickerController, animated: true, completion: nil)
        
        
    }
    
    //deal with select picture or cancel function
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        myProfileImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func uploadImageButtonTapped(_ sender: UIButton)
    {
        
        //check the image
        if myProfileImage.image != nil && myProfileImage.image != #imageLiteral(resourceName: "defaultProfileImage") && myProfileImage.image != myProfile.userProfileImage {
            
            //disable upload button
            uploadButton.isUserInteractionEnabled = false
            
            //call upload method
            myProfile.uploadNewProfileImage(newUserImage: myProfileImage.image!, userID: self.Ph_number!, complication: {self.UIUpdateAfterImageUpload()})
            
            
        }
        
    }
    
    func UIUpdateAfterImageUpload()
    {
        uploadButton.isUserInteractionEnabled = true
        
        //create alert
        let alert = UIAlertController(title: "Notice", message: myProfile.updatingInfo, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    //logout function If we used Tab bar we do not need log out
    @IBAction func clickToLogout(_ sender: UIButton)
    {
        
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
//        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    //round Image function
    private func roundMeToBeBeauty(oldImage:UIImageView)
    {
        oldImage.layer.cornerRadius = oldImage.frame.width / 2
        oldImage.clipsToBounds = true
        
        oldImage.layer.borderColor = UIColor.brown.cgColor
        oldImage.layer.borderWidth = 1
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        
        if !isUserLoggedIn {
            
            //create alert
            let alert = UIAlertController(title: "Notice", message: "Please Login", preferredStyle: UIAlertControllerStyle.alert)
            
            
            let userLoginView = storyboard?.instantiateViewController(withIdentifier: "userLoginView")
            
            //back to login view after click button
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in self.present(userLoginView!, animated: true, completion: nil) }))
            self.present(alert, animated: true, completion: nil)
            
        }else
        {
            // If loggedIn set the UserID
            Ph_number = UserDefaults.standard.object(forKey: "UserID") as! String?
            
            //load the info from database
            myProfile.getInfoFromServer(Ph_number: self.Ph_number!,InfoDownloadComplication: {self.updateUIWhenLoad()})
            
            //associate edit and textfield
            editTextFieldDict[self.emailEditButton] = self.emailTextField
            editTextFieldDict[self.firstNameEditButton] = self.firstNameTextField
            editTextFieldDict[self.lastNameEditButton] = self.lastNameTextField
            
        }

    }
    

    
    

}
