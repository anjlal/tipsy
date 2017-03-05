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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Load setting preferences
        let defaults = UserDefaults.standard
        if let tipPercentage = defaults.object(forKey: "defaultTipPct") as? Float {
            tipPercentageLabel.text = "\(Int(tipPercentage))%"
        } else {
            tipPercentageLabel.text = "\(Int(tipSlider.value))%"
        }
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

