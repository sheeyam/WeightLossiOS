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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
