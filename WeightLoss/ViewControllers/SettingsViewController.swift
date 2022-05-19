//
//  SettingsViewController.swift
//  WeightLoss
//
//  Created by Sheeyam Shellvacumar on 9/18/18.
//  Copyright © 2018 Sheeyam Shellvacumar. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var enableDisableTouchIDSwitch: UISwitch!
    @IBOutlet weak var setNameTextField: UITextField!
    @IBOutlet weak var setTargetTextField: UITextField!
    @IBOutlet weak var setWeightTextField: UITextField!
    
    let date = Date()
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(UserDefaults.standard.bool(forKey: "touchID")) {
            print("touchID Enabled")
            enableDisableTouchIDSwitch.setOn(true, animated: true)
        } else {
            print("touchID Disabled")
            enableDisableTouchIDSwitch.setOn(false, animated: false)
        }
        enableDisableTouchIDSwitch.addTarget(self, action: #selector(SettingsViewController.stateChanged(_:)), for: UIControl.Event.valueChanged)
        // Do any additional setup after loading the view.
        formatter.dateFormat = "MM.dd.yyyy"
        let currentDate = formatter.string(from: (self.date))
        
        showData()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        showData()
    }
    
    override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func stateChanged(_ sender: Any) {
        if enableDisableTouchIDSwitch.isOn {
            print("The TouchID Switch is On")
            UserDefaults.standard.set(true, forKey: "touchID") //Bool
            //UserDefaults.standard.set(1, forKey: "Key")  //Integer
            //UserDefaults.standard.set("TEST", forKey: "Key") //setObject
        } else {
            print("The TouchID Switch is Off")
            UserDefaults.standard.set(false, forKey: "touchID") //Bool
        }
    }
    
    func showData() {
        
        formatter.dateFormat = "MM.dd.yyyy"
        let currentDate = self.formatter.string(from: (self.date))
        
        if (UserDefaults.standard.string(forKey: "TargetCalCount_" + currentDate) ?? "").isEmpty {
            setTargetTextField.text = "";
        } else {
            setTargetTextField.text = UserDefaults.standard.string(forKey: "TargetCalCount_" + currentDate)
        }
        
        if (UserDefaults.standard.string(forKey: "Name") ?? "").isEmpty {
            setNameTextField.text = "";
        } else {
            setNameTextField.text = UserDefaults.standard.string(forKey: "Name")
        }
        
        if (UserDefaults.standard.string(forKey: "Weight") ?? "").isEmpty {
            setWeightTextField.text = "";
        } else {
            setWeightTextField.text = UserDefaults.standard.string(forKey: "Weight")
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        
    }
    
    @IBAction func saveSettingsData(_ sender: Any) {
        formatter.dateFormat = "MM.dd.yyyy"
        let currentDate = self.formatter.string(from: (self.date))
        
        UserDefaults.standard.set(setNameTextField?.text, forKey: "Name")
        UserDefaults.standard.set(setWeightTextField?.text, forKey: "Weight")
        UserDefaults.standard.set(setTargetTextField?.text, forKey: "TargetCalCount_" + currentDate)
    }
    
    @IBAction func logout(_ sender: Any) {
        //logout
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
