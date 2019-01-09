//
//  ActivityViewController.swift
//  WeightLoss
//
//  Created by Sheeyam Shellvacumar on 9/22/18.
//  Copyright © 2018 Sheeyam Shellvacumar. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var activityTableView: UITableView!
    var activityDate: [String] = []
    var activityConsumed: [String] = []
    var activityTarget: [String] = []
    var activityBurnt: [String] = []
    
    var spentCalCount: Double = 0
    var targetCalCount: Double = 0
    var consumedCalCount: Double = 0
    var netCalCount: Double = 0
    
    let now = Date() // Current Date/Time
    let formatter = DateFormatter()
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        activityTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(handleRefresh), for:.valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // Do any additional setup after loading the view.
        formatter.dateFormat = "MM.dd.yyyy"
        
        activityDate.removeAll()
        activityBurnt.removeAll()
        activityConsumed.removeAll()
        activityTarget.removeAll()
        
        for i in -30...0 {
            fillArray(index: i) //i will increment up one with each iteration of the for loop
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleRefresh() {
        
        activityDate.removeAll()
        activityBurnt.removeAll()
        activityConsumed.removeAll()
        activityTarget.removeAll()
        
        for i in -30...0 {
            fillArray(index: i) //i will increment up one with each iteration of the for loop
        }
        self.refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityDate.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if activityDate.count > 0 {
            return 1
        } else {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HistoryViewCell = activityTableView.dequeueReusableCell(withIdentifier: "historycell", for: indexPath) as! HistoryViewCell
        //cell.textLabel?.text = activity[indexPath.row]
        cell.historyDateLbl.text = activityDate[indexPath.row]
        cell.historyConsumedLbl.text = "Consumed = " + activityConsumed[indexPath.row] + " Cal"
        cell.historyBurntLbl.text = "Burnt = " + activityBurnt[indexPath.row] + " Cal"
        cell.historyTargetLbl.text = "Target = " + activityTarget[indexPath.row] + " Cal"
        
        
        targetCalCount = Double(activityTarget[indexPath.row])!
        spentCalCount = Double(activityBurnt[indexPath.row])!
        consumedCalCount = Double(activityConsumed[indexPath.row])!
        
        print(targetCalCount)
        print(spentCalCount)
        print(consumedCalCount)
        
        if(consumedCalCount > spentCalCount) {
            netCalCount = (consumedCalCount - spentCalCount) / targetCalCount
        } else {
            netCalCount =  (spentCalCount - consumedCalCount) / targetCalCount
        }
        
        if !(netCalCount.isNaN || netCalCount.isInfinite) {
            if netCalCount > 0 {
                cell.historyProgressLbl.text = String(Int(netCalCount * 100)) + "%"
            } else {
                cell.historyProgressLbl.text = "0%"
            }
        } else {
            cell.historyProgressLbl.text = "0%"
        }
        
        let newburntAngleValue = newAngle()
        cell.historyProgressView.animate(toAngle: newburntAngleValue, duration: 1.0, completion: nil)
        
        cell.contentView.backgroundColor = UIColor.white
        if Int(activityConsumed[indexPath.row])! >= Int(activityBurnt[indexPath.row])! {
            if Int(activityConsumed[indexPath.row])! - Int(activityBurnt[indexPath.row])! >= Int(activityTarget[indexPath.row])! {
                if(Int(activityTarget[indexPath.row])! == 0) {
                    cell.contentView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                } else {
                    cell.contentView.backgroundColor = UIColor(red: 236.0/255, green: 73.0/255, blue: 34.0/255, alpha: 0.4)
                }
            } else {
                if(Int(activityTarget[indexPath.row])! == 0) {
                    cell.contentView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                } else {
                    cell.contentView.backgroundColor = UIColor(red: 79.0/255, green: 178.0/255, blue: 52.0/255, alpha: 0.4)
                }
            }
        } else {
            cell.contentView.backgroundColor = UIColor(red: 255.0/255, green: 209.0/255, blue: 26.0/255, alpha: 0.4)
        }
        return cell
    }
    
    func newAngle() -> Double {
        if consumedCalCount > spentCalCount {
            if consumedCalCount > 0 {
                if 360 * ((consumedCalCount - spentCalCount) / targetCalCount) <= 360 {
                    print(360 * ((consumedCalCount - spentCalCount) / targetCalCount))
                    return 360 * ((consumedCalCount - spentCalCount) / targetCalCount)
                    
                } else {
                    return 360
                }
            } else {
                return 0
            }
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 155.0;
    }
    
    func fillArray(index:Int?){
        formatter.dateFormat = "MM.dd.yyyy"
        
        let now = Date() // Current date
        var dateComponents = DateComponents()
        dateComponents.setValue(abs(index!) - 30, for: .day) // -1 day
        
        let day = Calendar.current.date(byAdding: dateComponents, to: now)
        print(formatter.string(from: day!))
        print(Int(UserDefaults.standard.integer(forKey: "ConsumedCal_" + formatter.string(from: day!))))
        let ConsumedCal = Int(UserDefaults.standard.integer(forKey: "ConsumedCal_" + formatter.string(from: day!)))
        
        print(Int(UserDefaults.standard.integer(forKey: "SpentCalCount_" + formatter.string(from: day!))))
        let SpentCalCount = Int(UserDefaults.standard.integer(forKey: "SpentCalCount_" + formatter.string(from: day!)))
        
        print(Int(UserDefaults.standard.integer(forKey: "StepsCount_" + formatter.string(from: day!))))
        let StepsCount = Int(UserDefaults.standard.integer(forKey: "StepsCount_" + formatter.string(from: day!)))
        let targetCalCount = UserDefaults.standard.integer(forKey: "TargetCalCount_" + formatter.string(from: day!))
        
        activityDate.append(formatter.string(from: day!))
        activityBurnt.append(String(SpentCalCount))
        activityConsumed.append(String(ConsumedCal))
        activityTarget.append(String(targetCalCount))
        activityTableView.reloadData()
    }
    
    func yesterday() -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.setValue(-1, for: .day) // -1 day
        let now = Date() // Current date
        let yesterday = Calendar.current.date(byAdding: dateComponents, to: now) // Add the DateComponents
        
        return yesterday!
    }
    
    func tomorrow() -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.setValue(1, for: .day); // +1 day
        
        let now = Date() // Current date
        let tomorrow = Calendar.current.date(byAdding: dateComponents, to: now)  // Add the DateComponents
        
        return tomorrow!
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
