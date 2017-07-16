//
//  OrderVC.swift
//  MelbourneCafe
//
//  Created by SUN YU on 12/7/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class OrderVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameTextLabel: UILabel!
    @IBOutlet weak var quantityTextLabel: UILabel!
    @IBOutlet weak var totalPriceTextLabel: UILabel!
    @IBOutlet weak var coffeeSpecialView: UIView!
    @IBOutlet weak var gapBetweenQuantityAndSpecialNote: NSLayoutConstraint!
    @IBOutlet weak var sugarTextLabel: UILabel!

    //received Variable
    var selectedProduct:Product!
    
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
