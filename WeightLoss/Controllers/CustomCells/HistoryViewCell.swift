//
//  HistoryViewCell.swift
//  WeightLoss
//
//  Created by Sheeyam Shellvacumar on 10/28/18.
//  Copyright © 2018 Sheeyam Shellvacumar. All rights reserved.
//

import UIKit

class HistoryViewCell: UITableViewCell {
    
    @IBOutlet weak var historyDateLbl: UILabel!
    @IBOutlet weak var historyConsumedLbl: UILabel!
    @IBOutlet weak var historyBurntLbl: UILabel!
    @IBOutlet weak var historyTargetLbl: UILabel!
    @IBOutlet weak var historyProgressLbl: UILabel!
    @IBOutlet weak var historyProgressView: KDCircularProgress!
    
    //Constants
    static let identifier = Constants.customCells.historyViewCellIdentifier
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(activityData: ActivityModel) {
        historyDateLbl.text = activityData.activityDate
        historyConsumedLbl.text = "Consumed = " + activityData.activityConsumed + " \(Constants.labelStrings.cals)"
        historyBurntLbl.text = "Burnt = " + activityData.activityBurnt + " \(Constants.labelStrings.cals)"
        historyTargetLbl.text = "Target = " + activityData.activityTarget + " \(Constants.labelStrings.cals)"
        
        let targetCalCount = Double(activityData.activityTarget)!
        let spentCalCount = Double(activityData.activityBurnt)!
        let consumedCalCount = Double(activityData.activityConsumed)!
        var netCalCount = 0.0
        
        if(consumedCalCount > spentCalCount) {
            netCalCount = (consumedCalCount - spentCalCount) / targetCalCount
        } else {
            netCalCount =  (spentCalCount - consumedCalCount) / targetCalCount
        }
        
        if !(netCalCount.isNaN || netCalCount.isInfinite) {
            if netCalCount > 0 {
                historyProgressLbl.text = String(Int(netCalCount * 100)) + "%"
            } else {
                historyProgressLbl.text = Constants.progressStrings.progressZero
            }
        } else {
            historyProgressLbl.text = Constants.progressStrings.progressZero
        }
        
        let newburntAngleValue = newAngle(consume: consumedCalCount, spent: spentCalCount, target: targetCalCount)
        historyProgressView.animate(toAngle: newburntAngleValue, duration: 1.0, completion: nil)
        
        contentView.backgroundColor = UIColor.white
        if Int(activityData.activityConsumed)! >= Int(activityData.activityBurnt)! {
            if Int(activityData.activityConsumed)! - Int(activityData.activityBurnt)! >= Int(activityData.activityTarget)! {
                if(Int(activityData.activityTarget)! == 0) {
                    contentView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                } else {
                    contentView.backgroundColor = UIColor(red: 236.0/255, green: 73.0/255, blue: 34.0/255, alpha: 0.4)
                }
            } else {
                if(Int(activityData.activityTarget)! == 0) {
                    contentView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                } else {
                    contentView.backgroundColor = UIColor(red: 79.0/255, green: 178.0/255, blue: 52.0/255, alpha: 0.4)
                }
            }
        } else {
            contentView.backgroundColor = UIColor(red: 255.0/255, green: 209.0/255, blue: 26.0/255, alpha: 0.4)
        }
    }
    
    func newAngle(consume: Double, spent: Double, target: Double) -> Double {
        if consume > spent {
            if consume > 0 {
                if 360 * ((consume - spent) / target) <= 360 {
                    print(360 * ((consume - spent) / target))
                    return 360 * ((consume - spent) / target)
                    
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
    
}
