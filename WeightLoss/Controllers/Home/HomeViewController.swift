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
    
    let angleCalc = AngleCalculator()
    let date = Date()
    let formatter = DateFormatter()
    
    var spentCalCount: Double = 0
    var targetCalCount: Double = 0
    var consumedCalCount: Double = 0
    var netCalCount: Double = 0
    var stepsCount: Int = 0
    var shouldStartUpdating: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        //scheduledTimerWithTimeInterval()
        shouldStartUpdating = !shouldStartUpdating
        shouldStartUpdating ? (onStart()) : (onStop())
        loadContent()
        activityImageView.image = UIImage(named: Constants.icons.standing)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        loadContent()
        activityImageView.image = UIImage(named: Constants.icons.standing)
    }
    
    func loadContent(){
        if (UserDefaults.standard.string(forKey: Constants.userDefaultKeys.name) ?? "").isEmpty {
            userLbl.text = "Hi, Guest"
        } else {
            userLbl.text = "Hi, " + UserDefaults.standard.string(forKey: Constants.userDefaultKeys.name)!
        }
        
        formatter.dateFormat = Constants.commonDF
        let currentDate = self.formatter.string(from: (self.date))
        
        //Set Consumed Calorie Count
        consumedCalCount = Double(UserDefaults.standard.integer(forKey: Constants.userDefaultKeys.consumed + currentDate))
        targetCalCount = Double(UserDefaults.standard.integer(forKey: Constants.userDefaultKeys.target + currentDate))
        consumedLbl.text = String(UserDefaults.standard.integer(forKey: Constants.userDefaultKeys.consumed + currentDate)) + " \(Constants.labelStrings.cals)"
        targetLbl.text = "\(Constants.labelStrings.target) " + String(UserDefaults.standard.integer(forKey: Constants.userDefaultKeys.target + currentDate)) + " \(Constants.labelStrings.cals)"
        spentCalCount = Double(UserDefaults.standard.integer(forKey: Constants.userDefaultKeys.spent + currentDate))
        stepsCount = Int(UserDefaults.standard.integer(forKey: Constants.userDefaultKeys.steps + currentDate))
        
        if (0 == UserDefaults.standard.integer(forKey: Constants.userDefaultKeys.target + currentDate)) {
            consumedProgressNumberLabel.text = Constants.progressStrings.progressZero
            burntProgressNumberLabel.text = Constants.progressStrings.progressZero
        } else {
            if (0 == UserDefaults.standard.integer(forKey: Constants.userDefaultKeys.spent + currentDate)) {
                burntProgressNumberLabel.text = Constants.progressStrings.progressZero
            } else {
                if Int(spentCalCount * 100 / (targetCalCount)) < 100 {
                    burntProgressNumberLabel.text = String(Int(spentCalCount * 100 / (targetCalCount))) + "%"
                    burntProgressView.trackColor = Constants.colors.color01
                } else if Int(spentCalCount * 100 / (targetCalCount)) == 100 {
                    burntProgressNumberLabel.text = String(Int(spentCalCount * 100 / (targetCalCount))) + "%"
                    burntProgressView.trackColor = Constants.colors.color02
                } else {
                    burntProgressNumberLabel.text = Constants.progressStrings.progressHundred
                    burntProgressView.trackColor = Constants.colors.color03
                }
            }
            
            if (0 == UserDefaults.standard.integer(forKey: Constants.userDefaultKeys.consumed + currentDate)) {
                consumedProgressNumberLabel.text = Constants.progressStrings.progressZero
            } else {
                if Int(consumedCalCount * 100 / (targetCalCount)) < 100 {
                    consumedProgressNumberLabel.text = String(Int(consumedCalCount * 100 / (targetCalCount))) + "%"
                    consumedProgressView.trackColor = Constants.colors.color02
                } else if Int(consumedCalCount * 100 / (targetCalCount)) == 100 {
                    consumedProgressNumberLabel.text = String(Int(consumedCalCount * 100 / (targetCalCount))) + "%"
                    consumedProgressView.trackColor = Constants.colors.color03
                } else {
                    consumedProgressNumberLabel.text = Constants.progressStrings.progressHundred
                    consumedProgressView.trackColor = Constants.colors.color01
                }
            }
            
            stepsLbl.text = String(stepsCount)
            spentLbl.text = String(Int(spentCalCount))
            
            if (consumedCalCount > spentCalCount) {
                netCalCount = consumedCalCount - spentCalCount
            } else {
                netCalCount =  spentCalCount - consumedCalCount
            }
            netLbl.text = "\(Constants.labelStrings.netCals) " + String(Int(netCalCount))
            
            consumedCalCount += 1
            let newConsumedAngleValue = angleCalc.newAngleConsumed(consumed: consumedCalCount, target: targetCalCount)
            consumedProgressView.animate(toAngle: newConsumedAngleValue, duration: 1.0, completion: nil)
            
            spentCalCount += 1
            let newburntAngleValue = angleCalc.newAngleSpent(spent: spentCalCount, target: targetCalCount)
            burntProgressView.animate(toAngle: newburntAngleValue, duration: 1.0, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
