//
//  HomeViewController.swift
//  WeightLoss
//
//  Created by Sheeyam Shellvacumar on 9/16/18.
//  Copyright © 2018 Sheeyam Shellvacumar. All rights reserved.
//

import UIKit
import CoreMotion
import Dispatch

class HomeViewController: UIViewController {
    
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    var shouldStartUpdating: Bool = false
    var startDate: Date? = nil
    
    @IBOutlet weak var consumedProgressView: KDCircularProgress!
    @IBOutlet weak var burntProgressView: KDCircularProgress!
    
    @IBOutlet weak var spentLbl: UILabel!
    @IBOutlet weak var stepsLbl: UILabel!
    @IBOutlet weak var activityLbl: UILabel!
    @IBOutlet weak var consumedProgressNumberLabel: UILabel!
    @IBOutlet weak var burntProgressNumberLabel: UILabel!
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var targetLbl: UILabel!
    @IBOutlet weak var netLbl: UILabel!
    @IBOutlet weak var consumedLbl: UILabel!
    
    @IBOutlet weak var activityImageView: UIImageView!
    
    let date = Date()
    let formatter = DateFormatter()
    
    var timer = Timer()
    var spentCalCount: Double = 0
    var targetCalCount: Double = 0
    var consumedCalCount: Double = 0
    var netCalCount: Double = 0
    var stepsCount: Int = 0
    var sc: Int = 0
    var spc: Int = 0
    
    let caloriePerStep = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //scheduledTimerWithTimeInterval()
        shouldStartUpdating = !shouldStartUpdating
        shouldStartUpdating ? (onStart()) : (onStop())
        loadContent();
        activityImageView.image = UIImage(named: "standing")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        loadContent();
        // Do any additional setup after loading the view.
        activityImageView.image = UIImage(named: "standing")
    }
    
    func loadContent(){
        if (UserDefaults.standard.string(forKey: "Name") ?? "").isEmpty {
            userLbl.text = "Hi, Guest"
        } else {
            userLbl.text = "Hi, " + UserDefaults.standard.string(forKey: "Name")!
        }
        
        formatter.dateFormat = "MM.dd.yyyy"
        let currentDate = self.formatter.string(from: (self.date))
        
        //Set Consumed Calorie Count
        consumedCalCount = Double(UserDefaults.standard.integer(forKey: "ConsumedCal_" + currentDate))
        targetCalCount = Double(UserDefaults.standard.integer(forKey: "TargetCalCount_" + currentDate))
        consumedLbl.text = String(UserDefaults.standard.integer(forKey: "ConsumedCal_" + currentDate))
        targetLbl.text = "Target: " + String(UserDefaults.standard.integer(forKey: "TargetCalCount_" + currentDate))
        spentCalCount = Double(UserDefaults.standard.integer(forKey: "SpentCalCount_" + currentDate))
        stepsCount = Int(UserDefaults.standard.integer(forKey: "StepsCount_" + currentDate))
        
        if (0 == UserDefaults.standard.integer(forKey: "TargetCalCount_" + currentDate)) {
            consumedProgressNumberLabel.text = "0%";
            burntProgressNumberLabel.text = "0%";
        } else {
            
            if (0 == UserDefaults.standard.integer(forKey: "SpentCalCount_" + currentDate)) {
                burntProgressNumberLabel.text = "0%";
            } else {
                if Int(spentCalCount * 100 / (targetCalCount)) < 100 {
                    burntProgressNumberLabel.text = String(Int(spentCalCount * 100 / (targetCalCount))) + "%"
                    burntProgressView.trackColor = UIColor(red: 236.0/255, green: 73.0/255, blue: 34.0/255, alpha: 1)
                } else if Int(spentCalCount * 100 / (targetCalCount)) == 100 {
                    burntProgressNumberLabel.text = String(Int(spentCalCount * 100 / (targetCalCount))) + "%"
                    burntProgressView.trackColor = UIColor(red: 236.0/255, green: 199.0/255, blue: 52.0/255, alpha: 1)
                } else {
                    burntProgressNumberLabel.text = "100%"
                    burntProgressView.trackColor = UIColor(red: 79.0/255, green: 178.0/255, blue: 52.0/255, alpha: 1)
                }
            }
            
            if (0 == UserDefaults.standard.integer(forKey: "ConsumedCal_" + currentDate)) {
                consumedProgressNumberLabel.text = "0%";
            } else {
                if Int(consumedCalCount * 100 / (targetCalCount)) < 100 {
                    consumedProgressNumberLabel.text = String(Int(consumedCalCount * 100 / (targetCalCount))) + "%"
                    consumedProgressView.trackColor = UIColor(red: 236.0/255, green: 199.0/255, blue: 52.0/255, alpha: 1)
                } else if Int(consumedCalCount * 100 / (targetCalCount)) == 100 {
                    consumedProgressNumberLabel.text = String(Int(consumedCalCount * 100 / (targetCalCount))) + "%"
                    consumedProgressView.trackColor = UIColor(red: 79.0/255, green: 178.0/255, blue: 52.0/255, alpha: 1)
                } else {
                    consumedProgressNumberLabel.text = "100%"
                    consumedProgressView.trackColor = UIColor(red: 236.0/255, green: 73.0/255, blue: 34.0/255, alpha: 1)
                }
            }
            
            stepsLbl.text = String(stepsCount)
            spentLbl.text = String(Int(spentCalCount))
            print(spentCalCount)
            print(targetCalCount)
            print(consumedCalCount)
            
            if (consumedCalCount > spentCalCount) {
                netCalCount = consumedCalCount - spentCalCount
            } else {
                netCalCount =  spentCalCount - consumedCalCount
            }
            netLbl.text = "Net Calories: " + String(Int(netCalCount))
            
            //if consumedCalCount != (targetCalCount) {
                consumedCalCount += 1
                let newConsumedAngleValue = newAngleConsumed()
                consumedProgressView.animate(toAngle: newConsumedAngleValue, duration: 1.0, completion: nil)
            //}
            
            //if spentCalCount != (targetCalCount) {
                spentCalCount += 1
                let newburntAngleValue = newAngleSpent()
                burntProgressView.animate(toAngle: newburntAngleValue, duration: 1.0, completion: nil)
            //}
        }
    }
    
    func newAngleSpent() -> Double {
        if 360 * (spentCalCount / targetCalCount) <= 360 {
            return 360 * (spentCalCount / targetCalCount)
        } else if 360 * (spentCalCount / targetCalCount) > 360 {
            return 360
        } else if 360 * (spentCalCount / targetCalCount) < 0 {
            return 0
        } else {
            return 360
        }
    }
    
    func newAngleConsumed() -> Double {
        if 360 * (consumedCalCount / targetCalCount) <= 360 {
            return 360 * (consumedCalCount / targetCalCount)
        } else if 360 * (consumedCalCount / targetCalCount) > 360 {
            return 360
        } else if 360 * (consumedCalCount / targetCalCount) < 0 {
            return 0
        } else {
            return 360
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
