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

//Constants and Variables
let activityManager = CMMotionActivityManager()
let pedometer = CMPedometer()
var sc:Int = 0
var spc:Int = 0
var startDate: Date? = nil

//Extension - Pedometer Logics
extension HomeViewController {
    
    func onStart() {
        startDate = Date()
        checkAuthorizationStatus()
        startUpdating()
    }
    
    func onStop() {
        startDate = nil
        stopUpdating()
    }
    
    private func checkAuthorizationStatus() {
        switch CMMotionActivityManager.authorizationStatus() {
        case CMAuthorizationStatus.denied:
            onStop()
        default:
            break
        }
    }
    
    private func startUpdating() {
        if CMMotionActivityManager.isActivityAvailable() {
            startTrackingActivityType()
        }
        
        if CMPedometer.isStepCountingAvailable() {
            startCountingSteps()
        }
    }
    
    private func stopUpdating() {
        activityManager.stopActivityUpdates()
        pedometer.stopUpdates()
        pedometer.stopEventUpdates()
    }
    
    private func updateStepsCountLabelUsing(startDate: Date) {
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
                    self?.activityLbl.text = Constants.activityStrings.walking
                    self?.activityImageView.image = UIImage(named: Constants.icons.walking)
                } else if activity.stationary {
                    self?.activityLbl.text = Constants.activityStrings.stationary
                    self?.activityImageView.image = UIImage(named: Constants.icons.standing)
                } else if activity.running {
                    self?.activityLbl.text = Constants.activityStrings.running
                    self?.activityImageView.image = UIImage(named: Constants.icons.running)
                } else if activity.automotive {
                    self?.activityLbl.text = Constants.activityStrings.automotive
                    self?.activityImageView.image = UIImage(named: Constants.icons.driving)
                }
            }
        }
    }
    
    private func startCountingSteps() {
        pedometer.startUpdates(from: Date()) {
            [weak self] pedometerData, error in
            guard let pedometerData = pedometerData, error == nil else { return }
            
            DispatchQueue.main.async {
                if let currentDate = self?.formatter.string(from: Date()) {
                    sc = UserDefaults.standard.integer(forKey: Constants.userDefaultKeys.steps + currentDate) + Int(truncating: pedometerData.numberOfSteps)
                    spc = UserDefaults.standard.integer(forKey: Constants.userDefaultKeys.spent + currentDate) + Int(pedometerData.numberOfSteps.intValue * Constants.caloriePerStep)
                    UserDefaults.standard.set(sc, forKey: Constants.userDefaultKeys.steps + currentDate)
                    UserDefaults.standard.set(spc, forKey: Constants.userDefaultKeys.spent + currentDate)
                }
            }
        }
    }
    
    private func on(error: Error) {
        //TODO: Show an Alert
        print(error.localizedDescription)
    }
}
