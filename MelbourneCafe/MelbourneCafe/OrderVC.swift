//
//  OrderVC.swift
//  MelbourneCafe
//
//  Created by SUN YU on 12/7/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class OrderVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameTextLabel: UILabel!
    @IBOutlet weak var quantityTextLabel: UILabel!
    @IBOutlet weak var totalPriceTextLabel: UILabel!
    @IBOutlet weak var coffeeSpecialView: UIView!
    @IBOutlet weak var gapBetweenQuantityAndSpecialNote: NSLayoutConstraint!
    @IBOutlet weak var sugarTextLabel: UILabel!
    @IBOutlet weak var specialNoteTextView: UITextView!
    
    @IBOutlet weak var specialNoteButton: UIButton!
    var isSpecialNote = false
    
    //received Variable
    var selectedProduct:Product!
    var selectedCafeBriefInfo:String!
    
    private var quantity = 0
    {
        didSet
        {
            self.quantityTextLabel.text = String(self.quantity)
            self.totalPriceTextLabel.text = "$ " + String( Double(self.quantity ) * self.selectedProduct.price)
        }
    }
    
    private var sugar = 0.0
    {
        didSet
        {
            self.sugarTextLabel.text = String(self.sugar)
        }
    }
    
    private var selectedSize:String = ""
    {
        didSet
        {
            self.quantityTextLabel.text = String(self.quantity)
            self.totalPriceTextLabel.text = "$ " + String( Double(self.quantity ) * self.selectedProduct.price)

        }
    }
    
    
    //MARK:- Text View Delegate
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.specialNoteTextView.resignFirstResponder()
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.specialNoteTextView.text = ""
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return textView.text.characters.count + (text.characters.count - range.length) <= 140
    }
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        if selectedProduct is Coffee
        {
            coffeeSpecialView.isHidden = false
            
            
        }else
        {
            self.gapBetweenQuantityAndSpecialNote.constant = 25.0
            coffeeSpecialView.isHidden = true

        }
        
        
        //updateUI
        self.updateUIWhenLoad()
        
        
    }
    
    private func updateUIWhenLoad()
    {
        self.productImageView.image = selectedProduct.productImage
        self.productNameTextLabel.text = selectedProduct.name
        
        //hide the special note
        self.specialNoteTextView.isHidden = true
        
    }
    
    
    //MARK:- Data Picker View
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if let coffee = self.selectedProduct as? Coffee
        {
          
            return coffee.availableSize.count
        }
        
        return 0
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if let coffee = self.selectedProduct as? Coffee
        {
            return coffee.availableSize[row]
        }
        
        
        return ""
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if let coffee = self.selectedProduct as? Coffee
        {
            switch coffee.availableSize[row]
            {
                case "Large":
                    coffee.size = Coffee.Size.Large
                case "Small":
                    coffee.size = Coffee.Size.Small
                case "Medium":
                    coffee.size = Coffee.Size.Medium
                default:
                    break
            }
            
            self.selectedSize = coffee.availableSize[row]
        }
        
    }
    
    
    //MARK:- UIButton Functions
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem)
    {
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func adjustmentButtonsTapped(_ sender: UIButton)
    {
        switch sender.tag
        {
            case 1:
                if self.quantity > 0
                 {
                   self.quantity -= 1
                 }
            case 2:
                self.quantity += 1
            case 3:
                if self.sugar > 0
                {
                  self.sugar -= 0.5
                }
            case 4:
                self.sugar += 0.5
            default:
                break
        }
        
    }
    
    @IBAction func specialNoteButtonTapped(_ sender: UIButton)
    {
        if !isSpecialNote
        {
            self.specialNoteTextView.isHidden = false
            self.specialNoteButton.setBackgroundImage(UIImage(named:"CheckBox"), for: UIControlState.normal)
            self.isSpecialNote = true
            
        }else
        {
            self.specialNoteTextView.text = "Please put your special  note here."
            self.specialNoteTextView.isHidden = true
            self.specialNoteButton.setBackgroundImage(UIImage(named:"UnCheckBox"), for: UIControlState.normal)
            self.isSpecialNote = false
        }
        
    }

    
    @IBAction func addToCartButtonTapped(_ sender: UIButton)
    {
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        if isUserLoggedIn
        {
        
            if self.quantity == 0
            {
                self.createAlert(withTitle: "Notification", message: "Please make sure how many items you would like to order")
            
            }else
            {
                var customerSpecialNote = self.specialNoteTextView.text
            
                if !self.isSpecialNote
                {
                    customerSpecialNote = ""
                }
            
                var orderSugar = 0.0
                var orderSize = ""
            
            
            
                if let coffee = self.selectedProduct as? Coffee
                {
                    orderSugar = self.sugar
                
                    let size = coffee.size!
                
                    switch size
                    {
                        case .Small:
                            orderSize = "Small"
                        case .Medium:
                            orderSize = "Medium"
                        case .Large:
                            orderSize = "Large"
                
                    }
                
        
              
                }
            
                //create the orderItem
                let orderItem = OrderItem(product: self.selectedProduct, quantity: self.quantity, specialNote: customerSpecialNote!, sugar: orderSugar, size: orderSize)
            
                let orderMessage = "You want to order\n" + orderItem.orderItemDescription + " * " + String(orderItem.quantity)
            
                self.createAlertWithFunctions(withTitle: "Notification", message: orderMessage, function: {self.dismiss(animated: true, completion: nil)})
                

                
                //check if the cart exist
                if let userID = UserDefaults.standard.object(forKey: "UserID") as! String?
                {
                    let referenceNumber = userID + "-" + String(self.selectedProduct.shopID)
                    
                    if let cartDictionaryData = UserDefaults.standard.data(forKey: referenceNumber)
                    {
                        
                        let cart = self.loadCartData(cartDictionaryData: cartDictionaryData)
                        
                        cart.orderNewItem(newItem: orderItem)
                        
                        //save data
                        self.saveCartData(cart: cart)
                        
                        
                    }else
                    {
                        //create a new cart
                        let cart = Cart(shopID: self.selectedProduct.shopID, userID: userID, shopDescription:self.selectedCafeBriefInfo)
                        cart.orderNewItem(newItem: orderItem)
                        
                        
                        //save data
                        self.saveCartData(cart: cart)
                        
                        
                    }
                    
                }
                
                
            }
        }else
        {
            self.goToLoginPageAlert()
        }
        
        
    }


}
