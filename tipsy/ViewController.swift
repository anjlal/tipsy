//
//  ViewController.swift
//  tipsy
//
//  Created by Angie Lal on 3/5/17.
//  Copyright © 2017 Angie Lal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipPercentageLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var currencySymbol: UILabel!
    
    struct Constants {
        static let threeMinInSec = 3 * 60
        static let locale = Locale.current
        static let currencySymbol = locale.currencySymbol
        static let decimalSeparator = locale.decimalSeparator
    }
    
    // Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let defaults = UserDefaults.standard
        
        // Set currency symbol for label
        currencySymbol.text = Constants.currencySymbol
        
        // Load stored bill amount if < foo min ago
        if let billAmount = defaults.object(forKey: "billAmount") {
            let billTimestamp = defaults.object(forKey: "billTimestamp")
            let elapsed = Date().timeIntervalSince(billTimestamp as! Date)
            let amount = decimalSeparatorSwitcharooOnLoad(amount: billAmount as! String)
            if (Int(elapsed) < Constants.threeMinInSec) {
                billField.text = String(describing: amount)
            }
        }
        
        // Load tip preferences
        if let tipPercentage = defaults.object(forKey: "defaultTipPct") as? Float {
            tipPercentageLabel.text = "\(Int(tipPercentage))%"
        } else {
            tipPercentageLabel.text = "\(Int(tipSlider.value))%"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Animations
        billField.center.x  -= view.bounds.width
        tipLabel.center.x -= view.bounds.width
        totalLabel.center.x -= view.bounds.width
        tipPercentageLabel.center.x -= view.bounds.width
        
        // Load new tip percentage default
        let defaults = UserDefaults.standard
        if let tipPercentage = defaults.object(forKey: "defaultTipPct") as? Float {
            tipPercentageLabel.text = "\(Int(tipPercentage))%"
            tipSlider.value = tipPercentage
        } else {
            tipPercentageLabel.text = "\(Int(tipSlider.value))%"
        }
        calculateAmounts()
        print("view will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Animations
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 30.0, options: [], animations: {
            self.billField.center.x += self.view.bounds.width
            self.tipLabel.center.x += self.view.bounds.width
            self.totalLabel.center.x += self.view.bounds.width
            self.tipPercentageLabel.center.x += self.view.bounds.width
        }, completion: nil)
        
        // The keyboard will always be displayed when view appears
        billField.becomeFirstResponder()
        print("view did appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("view will disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("view did disappear")
    }
    
    // Stores bill amount when no longer editing
    @IBAction func saveBillAmountOnDoneEditing(_ sender: Any) {

        // Store setting preferences
        let defaults = UserDefaults.standard
        defaults.set(billField.text, forKey: "billAmount")
        defaults.set(Date(), forKey: "billTimestamp")
    }
    
    // Formats amount based on locale
    func localeFormatter(amount: Double) -> String {
        // Use the current locale of the user's device to format the currency
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        let locale = Locale.current
        _ = locale.currencySymbol
        currencyFormatter.locale = locale
        return currencyFormatter.string(from: amount as NSNumber)!
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
        
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        tipPercentageLabel.text = "\(Int(tipSlider.value))%"
        calculateAmounts()
    }
    
    @IBAction func billAmountChanged(_ sender: Any) {
        calculateAmounts()
    }
    
    // Ensures bill amount contains appropriate decimal separator when loaded (per locale)
    func decimalSeparatorSwitcharooOnLoad(amount: String) -> String {
        
        if (amount.contains(",") && Constants.decimalSeparator == ".") {
            return(amount.replacingOccurrences(of: ",", with:  "."))
        } else if (amount.contains(".") && Constants.decimalSeparator == ",") {
            return(amount.replacingOccurrences(of: ".", with:  ","))
        } else {
            return amount
        }
    }
    
    // Replaces comma decimal separator with dot for ease of calculation
    func replaceDecimalSeparator(amount: String) -> String {
        if (Constants.decimalSeparator == ",") {
            return(amount.replacingOccurrences(of: ",", with:  "."))
        }
        return amount
    }
    
    // Calculates new tip and total amounts
    func calculateAmounts() {
        let amount = replaceDecimalSeparator(amount: billField.text!)

        let bill = Double(amount) ?? 0
        let tipPct = Double(Int(tipSlider.value))/100
        let tip = bill * Double(tipPct)
        let total = bill + tip
        
        tipLabel.text = localeFormatter(amount: tip)
        totalLabel.text = localeFormatter(amount: total)
        
        //tipLabel.text = String(format: "$%.2f", tip)
        //totalLabel.text = String(format: "$%.2f", total)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

