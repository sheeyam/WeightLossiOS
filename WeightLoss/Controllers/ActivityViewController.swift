//
//  ActivityViewController.swift
//  WeightLoss
//
//  Created by Sheeyam Shellvacumar on 9/22/18.
//  Copyright © 2018 Sheeyam Shellvacumar. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {
    
    @IBOutlet weak var activityTableView: UITableView!
    
    let formatter = DateFormatter()
    var refreshControl: UIRefreshControl!
    var activityData: [ActivityModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // Do any additional setup after loading the view.
        formatter.dateFormat = Constants.commonDF
        removeAllData()
        fillLast30DayData()
    }
    
    func setupRefreshControl(){
        refreshControl = UIRefreshControl()
        activityTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(handleRefresh), for:.valueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func removeAllData(){
        activityData.removeAll()
    }
    
    func fillLast30DayData(){
        for i in -30...0 {
            fillArray(index: i) //i will increment up one with each iteration of the for loop
        }
    }
    
    @objc func handleRefresh() {
        removeAllData()
        fillLast30DayData()
        self.refreshControl.endRefreshing()
    }
    
    func fillArray(index:Int?){
        formatter.dateFormat = Constants.commonDF
        var dateComponents = DateComponents()
        dateComponents.setValue(abs(index!) - 30, for: .day) // -1 day
        
        let day = Calendar.current.date(byAdding: dateComponents, to: Date())
        let ConsumedCal = Int(UserDefaults.standard.integer(forKey: Constants.userDefaultKeys.consumed + formatter.string(from: day!)))
        let SpentCalCount = Int(UserDefaults.standard.integer(forKey: Constants.userDefaultKeys.spent + formatter.string(from: day!)))
        let targetCalCount = UserDefaults.standard.integer(forKey: Constants.userDefaultKeys.target + formatter.string(from: day!))
        let activity = ActivityModel(activityDate: formatter.string(from: day!), activityConsumed: String(ConsumedCal), activityTarget: String(targetCalCount), activityBurnt: String(SpentCalCount))
        activityData.append(activity)
        activityTableView.reloadData()
    }
}

extension ActivityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if activityData.count > 0 {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HistoryViewCell = activityTableView.dequeueReusableCell(withIdentifier: HistoryViewCell.identifier, for: indexPath) as! HistoryViewCell
        cell.configureCell(activityData: activityData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
