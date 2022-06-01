//
//  HistoryViewCell.swift
//  WeightLoss
//
//  Created by Sheeyam Shellvacumar on 10/28/18.
//  Copyright © 2018 Sheeyam Shellvacumar. All rights reserved.
//

import UIKit

class HistoryViewCell: UITableViewCell {
    
    //Outlets
    @IBOutlet weak var historyDateLbl: UILabel!
    @IBOutlet weak var historyConsumedLbl: UILabel!
    @IBOutlet weak var historyBurntLbl: UILabel!
    @IBOutlet weak var historyTargetLbl: UILabel!
    @IBOutlet weak var historyProgressLbl: UILabel!
    @IBOutlet weak var historyProgressView: KDCircularProgress!
    
    //Constants
    let angleCalc = AngleCalculator()
    let calcBL = Calculations()
    
    //Constants
    static let identifier = Constants.customCells.historyViewCellIdentifier
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        
        if let targetCalCount = Double(activityData.activityTarget),let spentCalCount = Double(activityData.activityBurnt), let consumedCalCount = Double(activityData.activityConsumed){
            if let netCalCount = calcBL.getNetCaloriesCount(consumedCalCount: consumedCalCount, spentCalCount: spentCalCount, targetCalCount: targetCalCount) {
                if !(netCalCount.isNaN || netCalCount.isInfinite) {
                    historyProgressLbl.text = netCalCount > 0 ? (String(Int(netCalCount * 100)) + "%") : Constants.progressStrings.progressZero
                } else {
                    historyProgressLbl.text = Constants.progressStrings.progressZero
                }
            }
            
            let newburntAngleValue = angleCalc.newAngle(consume: consumedCalCount, spent: spentCalCount, target: targetCalCount)
            animateProgress(newburntAngleValue: newburntAngleValue)
            configureBGColor(activityData: activityData)
        }
    }
    
    func configureBGColor(activityData: ActivityModel){
        contentView.backgroundColor = UIColor.white
        if let consumed = Int(activityData.activityConsumed), let burnt = Int(activityData.activityBurnt), let target = Int(activityData.activityTarget) {
            if consumed >= burnt {
                if consumed - burnt >= target {
                    contentView.backgroundColor = target == 0 ? Constants.colors.color04 : Constants.colors.color05
                } else {
                    contentView.backgroundColor = target == 0 ? Constants.colors.color04 : Constants.colors.color06
                }
            } else {
                contentView.backgroundColor = Constants.colors.color07
            }
        }
    }
}
