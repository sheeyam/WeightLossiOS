//
//  HomeViewController+Pedometer.swift
//  WeightLoss
//
//  Created by Sheeyam Shellvacumar on 5/19/22.
//  Copyright © 2022 Sheeyam Shellvacumar. All rights reserved.
//

import Foundation
import CoreMotion
import UIKit

extension HomeViewController {
    func onStart() {
        //startBtn.setTitle("Stop", for: .normal)
        startDate = Date()
        checkAuthorizationStatus()
        startUpdating()
    }
    
    func onStop() {
        // startBtn.setTitle("Start", for: .normal)
        startDate = nil
        stopUpdating()
    }
    
    private func startUpdating() {
        if CMMotionActivityManager.isActivityAvailable() {
            startTrackingActivityType()
        } else {
            //activityLbl.text = "Not available"
        }
        
        if CMPedometer.isStepCountingAvailable() {
            startCountingSteps()
        } else {
            //stepsLbl.text = "Not available"
        }
    }
    
    private func checkAuthorizationStatus() {
        switch CMMotionActivityManager.authorizationStatus() {
        case CMAuthorizationStatus.denied:
            onStop()
            //activityLbl.text = "Not available"
        //stepsLbl.text = "Not available"
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
        print("=== Update Counting Steps & Calories ===")
        pedometer.queryPedometerData(from: startDate, to: Date()) {
            [weak self] pedometerData, error in
            if let error = error {
                self?.on(error: error)
            } else if let pedometerData = pedometerData {
                DispatchQueue.main.async {
                    self?.stepsLbl.text = String(describing: pedometerData.numberOfSteps)
                    self?.spentLbl.text = String(describing: pedometerData.numberOfSteps.intValue * 10)
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
                    self?.activityImageView.image = UIImage(named: "walking")
                } else if activity.stationary {
                    self?.activityLbl.text = "Stationary"
                    self?.activityImageView.image = UIImage(named: "standing")
                } else if activity.running {
                    self?.activityLbl.text = "Running"
                    self?.activityImageView.image = UIImage(named: "running")
                } else if activity.automotive {
                    self?.activityLbl.text = "Automotive"
                    self?.activityImageView.image = UIImage(named: "driving")
                }
            }
        }
    }
    
    private func startCountingSteps() {
        print("=== Start Counting Steps & Calories ===")
        pedometer.startUpdates(from: Date()) {
            [weak self] pedometerData, error in
            guard let pedometerData = pedometerData, error == nil else { return }
            
            DispatchQueue.main.async {
                let currentDate = self?.formatter.string(from: (self?.date)!)
                
                self?.sc = UserDefaults.standard.integer(forKey: "StepsCount_" + currentDate!) + Int(truncating: pedometerData.numberOfSteps)
                self?.spc = UserDefaults.standard.integer(forKey: "SpentCalCount_" + currentDate!) + Int(pedometerData.numberOfSteps.intValue * (self?.caloriePerStep)!)
                
                UserDefaults.standard.set(self?.sc, forKey: "StepsCount_" + currentDate!)  //Integer
                print(self?.sc ?? 0)
                
                UserDefaults.standard.set(self?.spc, forKey: "SpentCalCount_" + currentDate!)  //Integer
                print(self?.spc ?? 0)
            }
        }
    }
}
