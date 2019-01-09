//
//  PedoViewController.swift
//  WeightLoss
//
//  Created by Sheeyam Shellvacumar on 9/16/18.
//  Copyright © 2018 Sheeyam Shellvacumar. All rights reserved.
//

import UIKit
import CoreMotion
import Dispatch

class PedoViewController: UIViewController {
    
    private let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()
    private var shouldStartUpdating: Bool = false
    private var startDate: Date? = nil
    
    @IBOutlet weak var stepsLbl: UILabel!
    @IBOutlet weak var todayLbl: UILabel!
    @IBOutlet weak var activityLbl: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var caloriesLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startBtn.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let startDate = startDate else { return }
        updateStepsCountLabelUsing(startDate: startDate)
    }
    
    @IBAction func goToHome(_ sender: Any) {
        //Show back to Home Screen Logics
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapStartButton() {
        shouldStartUpdating = !shouldStartUpdating
        shouldStartUpdating ? (onStart()) : (onStop())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PedoViewController {
    private func onStart() {
        startBtn.setTitle("Stop", for: .normal)
        startDate = Date()
        checkAuthorizationStatus()
        startUpdating()
    }
    
    private func onStop() {
        startBtn.setTitle("Start", for: .normal)
        startDate = nil
        stopUpdating()
    }
    
    private func startUpdating() {
        if CMMotionActivityManager.isActivityAvailable() {
            startTrackingActivityType()
        } else {
            activityLbl.text = "Not available"
        }
        
        if CMPedometer.isStepCountingAvailable() {
            startCountingSteps()
        } else {
            stepsLbl.text = "Not available"
        }
    }
    
    private func checkAuthorizationStatus() {
        switch CMMotionActivityManager.authorizationStatus() {
        case CMAuthorizationStatus.denied:
            onStop()
            activityLbl.text = "Not available"
            stepsLbl.text = "Not available"
        default:break
        }
    }
    
    private func stopUpdating() {
        activityManager.stopActivityUpdates()
        pedometer.stopUpdates()
        pedometer.stopEventUpdates()
    }
    
    private func on(error: Error) {
        //handle error
    }
    
    private func updateStepsCountLabelUsing(startDate: Date) {
        print("--- updateStepsCountLabelUsing --")
        pedometer.queryPedometerData(from: startDate, to: Date()) {
            [weak self] pedometerData, error in
            if let error = error {
                self?.on(error: error)
            } else if let pedometerData = pedometerData {
                DispatchQueue.main.async {
                    self?.stepsLbl.text = String(describing: pedometerData.numberOfSteps)
                    self?.caloriesLbl.text = String(describing: pedometerData.numberOfSteps.intValue * 10)
                    UserDefaults.standard.set(pedometerData.numberOfSteps.stringValue, forKey: "Steps") //setObject
                    UserDefaults.standard.set(String(pedometerData.numberOfSteps.intValue * 10), forKey: "StepCalories") //setObject
                }
            }
        }
    }
    
    private func startTrackingActivityType() {
        activityManager.startActivityUpdates(to: OperationQueue.main) {
            [weak self] (activity: CMMotionActivity?) in
            guard let activity = activity else { return }
            DispatchQueue.main.async {
                if activity.walking {
                    self?.activityLbl.text = "Walking"
                } else if activity.stationary {
                    self?.activityLbl.text = "Stationary"
                } else if activity.running {
                    self?.activityLbl.text = "Running"
                } else if activity.automotive {
                    self?.activityLbl.text = "Automotive"
                }
            }
        }
    }
    
    private func startCountingSteps() {
        print("--- startCountingSteps --")
        pedometer.startUpdates(from: Date()) {
            [weak self] pedometerData, error in
            guard let pedometerData = pedometerData, error == nil else { return }
            
            DispatchQueue.main.async {
                self?.stepsLbl.text = pedometerData.numberOfSteps.stringValue
                self?.caloriesLbl.text = String(pedometerData.numberOfSteps.intValue * 10)
                UserDefaults.standard.set(pedometerData.numberOfSteps.stringValue, forKey: "Steps") //setObject
                UserDefaults.standard.set(String(pedometerData.numberOfSteps.intValue * 10), forKey: "StepCalories") //setObject
            }
        }
    }
}
