//
//  ActivityViewController.swift
//  WeightLoss
//
//  Created by Sheeyam Shellvacumar on 9/22/18.
//  Copyright © 2018 Sheeyam Shellvacumar. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var activityTableView: UITableView!
    
    //Constants & Variables
    let formatter = DateFormatter()
    var refreshControl: UIRefreshControl!
    var activityData: [ActivityModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setupInitialData()
    }
    
    func setupInitialData() {
        formatter.dateFormat = Constants.commonDF
        removeAllData()
        fillLast30DayData()
    }
    
    func setupRefreshControl(){
        refreshControl = UIRefreshControl()
        activityTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(handleRefresh), for:.valueChanged)
    }
    
    func removeAllData(){
        activityData.removeAll()
    }
    
    @objc func handleRefresh() {
        removeAllData()
        fillLast30DayData()
        self.refreshControl.endRefreshing()
    }
    
    func fillLast30DayData(){
        for idx in -30...0 {
            let activity = generateActivity(index: idx)
            activityData.append(activity)
        }
        reloadTable()
    }
    
    func generateActivity(index: Int) -> ActivityModel {
        var dateComponents = DateComponents()
        dateComponents.setValue(abs(index) - 30, for: .day) // -1 day
        
        var activity = ActivityModel()
        if let day = Calendar.current.date(byAdding: dateComponents, to: Date()) {
            let ConsumedCal = Int(UserDefaults.standard.integer(forKey: Constants.userDefaultKeys.consumed + formatter.string(from: day)))
            let SpentCalCount = Int(UserDefaults.standard.integer(forKey: Constants.userDefaultKeys.spent + formatter.string(from: day)))
            let targetCalCount = UserDefaults.standard.integer(forKey: Constants.userDefaultKeys.target + formatter.string(from: day))
            activity = ActivityModel(activityDate: formatter.string(from: day), activityConsumed: String(ConsumedCal), activityTarget: String(targetCalCount), activityBurnt: String(SpentCalCount))
            return activity
        }
        return activity
    }
}
