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
    
    let angleCalc = AngleCalculator()
    let calcBL = Calculations()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func animateProgress(newburntAngleValue: Double){
        DispatchQueue.main.async {
            self.historyProgressView.animate(toAngle: newburntAngleValue, duration: 1.0, completion: nil)
        }
    }
    
    func configureCell(activityData: ActivityModel) {
        historyDateLbl.text = activityData.activityDate
        historyConsumedLbl.text = Constants.labelStrings.consumedStr + activityData.activityConsumed + " \(Constants.labelStrings.cals)"
        historyBurntLbl.text = Constants.labelStrings.burntStr + activityData.activityBurnt + " \(Constants.labelStrings.cals)"
        historyTargetLbl.text = Constants.labelStrings.targetStr + activityData.activityTarget + " \(Constants.labelStrings.cals)"
        
        let targetCalCount = Double(activityData.activityTarget)!
        let spentCalCount = Double(activityData.activityBurnt)!
        let consumedCalCount = Double(activityData.activityConsumed)!
        
        if let netCalCount = calcBL.getNetCaloriesCount(consumedCalCount: consumedCalCount, spentCalCount: spentCalCount, targetCalCount: targetCalCount) {
            
            if !(netCalCount.isNaN || netCalCount.isInfinite) {
                if netCalCount > 0 {
                    historyProgressLbl.text = String(Int(netCalCount * 100)) + "%"
                } else {
                    historyProgressLbl.text = Constants.progressStrings.progressZero
                }
            } else {
                historyProgressLbl.text = Constants.progressStrings.progressZero
            }
        }
        
        let newburntAngleValue = angleCalc.newAngle(consume: consumedCalCount, spent: spentCalCount, target: targetCalCount)
        animateProgress(newburntAngleValue: newburntAngleValue)
        
        configureBGColor(activityData: activityData)
    }
    
    func configureBGColor(activityData: ActivityModel){
        contentView.backgroundColor = UIColor.white
        if Int(activityData.activityConsumed)! >= Int(activityData.activityBurnt)! {
            if Int(activityData.activityConsumed)! - Int(activityData.activityBurnt)! >= Int(activityData.activityTarget)! {
                if(Int(activityData.activityTarget)! == 0) {
                    contentView.backgroundColor = Constants.colors.color04
                } else {
                    contentView.backgroundColor = Constants.colors.color05
                }
            } else {
                if(Int(activityData.activityTarget)! == 0) {
                    contentView.backgroundColor = Constants.colors.color04
                } else {
                    contentView.backgroundColor = Constants.colors.color06
                }
            }
        } else {
            contentView.backgroundColor = Constants.colors.color07
        }
    }
}
