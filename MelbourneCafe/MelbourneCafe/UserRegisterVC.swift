//
//  UserRegisterVC.swift
//  MelbourneCafe
//
//  Created by SUN YU on 25/5/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class UserRegisterVC: UIViewController {

    //TextField for user type in
    @IBOutlet weak var phoneNumberLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var passwordConfirmLabel: UITextField!
    
    //TextField Checking Status
    var checkPhonenumber = false
    var checkEmail = false
    var checkFirstPassword = false
    var checkSecondPassword = false
    
    //test variable needs to be changed as required
    @IBOutlet weak var resultOfSession: UILabel!
    
    //uncheckBox
    @IBOutlet weak var uncheckBox: UIButton!
    var checkBoxStatus = false
    
    //check textField rear Image
    @IBOutlet weak var phoneNumberCheckImage: UIImageView!
    @IBOutlet weak var emailCheckImage: UIImageView!
    @IBOutlet weak var firstPasswordImage: UIImageView!
    @IBOutlet weak var secondPasswordImage: UIImageView!
    
    //Creat three kind of Rear Images
    private let correctFieldImage = UIImage(named:"CorrectField")
    private let emptyFieldImage = UIImage(named: "EmptyField")
    private let wrongFieldImage = UIImage(named:"WrongField")
    
    //Var to control sessoion completion
    private var sessionCompletion = false
    
    private var newUser = UserRegister()
    
    @IBAction func registerButton(_ sender: UIButton) {
        
        
        if checkPhonenumber && checkEmail  && checkSecondPassword && checkBoxStatus
        {
            newUser.userRegister(Ph_number: phoneNumberLabel.text!, Email: emailLabel.text!, Password: passwordLabel.text!,CompletionHandler: {self.updateUI()})
            
        }else
        {
            createAlertMessage()
        }
        
       
    }
    
    //check box function
    @IBAction func clickUncheckBox(_ sender: UIButton) {
        
        if checkBoxStatus {
            checkBoxStatus = false
            uncheckBox.setBackgroundImage(UIImage(named:"UnCheckBox"), for: UIControlState.normal)
            
        }else
        {
            checkBoxStatus = true
            uncheckBox.setBackgroundImage(UIImage(named:"CheckBox"), for: UIControlState.normal)
        }
        
        
    }
    
    func updateUI()
    {
        resultOfSession.text = newUser.registerResult
        
        print("lalalala: \(newUser.registerResult)")
        
    }
    
    
    private var fieldValidation = UserInfoValidation()
    
    //check all things before sending
    @IBAction func checkPassingParameters(_ sender: UITextField) {
        
        let textFieldTag = sender.tag
        let textFieldText = sender.text!
        
        //check empty or not first
        if sender.hasText
        {
            switch textFieldTag
            {
            case 1:
                fieldValidation.checkPhoneNumber(phoneNumber: textFieldText)
                if fieldValidation.result
                {
                    checkPhonenumber = true
                    phoneNumberCheckImage.image = correctFieldImage
                    
                }else
                {
                    checkPhonenumber = false
                    phoneNumberCheckImage.image = wrongFieldImage
                }
            case 2:
                fieldValidation.checkEmail(Email: textFieldText)
                if fieldValidation.result
                {
                    checkEmail = true
                    emailCheckImage.image = correctFieldImage
                    
                }else
                {
                    checkEmail = false
                    emailCheckImage.image = wrongFieldImage
                }
            case 3:
                //print("check First Password")
                checkFirstPassword = true
                firstPasswordImage.image = correctFieldImage
            case 4:
                //print("check Second Password")
                if ( checkFirstPassword && (passwordConfirmLabel.text == passwordLabel.text))
                {
                    checkSecondPassword = true
                    secondPasswordImage.image = correctFieldImage
                }else
                {
                    checkSecondPassword = false
                    secondPasswordImage.image = wrongFieldImage
                }
            default:
                break
            }
            
        }else
        {
            switch textFieldTag
            {
            case 1:
                checkPhonenumber = false
                phoneNumberCheckImage.image = emptyFieldImage
            case 2:
                checkEmail = false
                emailCheckImage.image = emptyFieldImage
            case 3:
                checkFirstPassword = false
                firstPasswordImage.image = emptyFieldImage
            case 4:
                checkSecondPassword = false
                secondPasswordImage.image = emptyFieldImage
            default:
                break
            }
        }

    }
    
    func createAlertMessage()
    {
        //collect error mesage
        var errorMessageForTextField = "Please check following messages: "
        
        if !checkPhonenumber
        {
            errorMessageForTextField = errorMessageForTextField + "Invalid Phone Number\n"
        }
        
        if !checkEmail
        {
            errorMessageForTextField = errorMessageForTextField + "Invalid Email Address\n"
        }
        
        if !checkFirstPassword || !checkSecondPassword
        {
            errorMessageForTextField = errorMessageForTextField + "Unmatched Password\n"
        }
        
        if !checkBoxStatus
        {
             errorMessageForTextField = errorMessageForTextField + "Terms && Condition\n"
        }
        
        
        
        //create alert
        let alert = UIAlertController(title:"Uncorrected TextField" , message: errorMessageForTextField, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
        
        
    }
    
    @IBAction func loginViewTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
