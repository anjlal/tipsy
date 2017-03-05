//
//  SettingsViewController.swift
//  tipsy
//
//  Created by Angie Lal on 3/5/17.
//  Copyright © 2017 Angie Lal. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tipPercentageLabel: UILabel!
    @IBOutlet weak var tipSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
    
    @IBAction func onSliderValueChanged(_ sender: Any) {
        tipPercentageLabel.text = "\(Int(tipSlider.value))%"
        
        // Store setting preferences
        let defaults = UserDefaults.standard
        defaults.set(tipSlider.value, forKey: "defaultTipPct")
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
