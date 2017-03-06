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
    
    struct Constants {
        static let threeMinInSec = 3 * 60
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let defaults = UserDefaults.standard
        
        // Load bill amount from last restart if < foo min ago
        if let billAmount = defaults.object(forKey: "billAmount") {
            let billTimestamp = defaults.object(forKey: "billTimestamp")
            let elapsed = Date().timeIntervalSince(billTimestamp as! Date)
            print(elapsed)
            if (Int(elapsed) < Constants.threeMinInSec) {
                billField.text = String(describing: billAmount)
            }
        }
        
        // Load setting preferences
        if let tipPercentage = defaults.object(forKey: "defaultTipPct") as? Float {
            tipPercentageLabel.text = "\(Int(tipPercentage))%"
        } else {
            tipPercentageLabel.text = "\(Int(tipSlider.value))%"
        }
    }
    
    @IBAction func saveBillAmountOnDoneEditing(_ sender: Any) {

        // Store setting preferences
        let defaults = UserDefaults.standard
        defaults.set(billField.text, forKey: "billAmount")
        defaults.set(Date(), forKey: "billTimestamp")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calculateAmounts() {
        let bill = Double(billField.text!) ?? 0
        let tipPct = Double(Int(tipSlider.value))/100
        let tip = bill * Double(tipPct)
        let total = bill + tip
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
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
}

