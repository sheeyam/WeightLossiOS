//
//  CustomConsumeCell.swift
//  WeightLoss
//
//  Created by Sheeyam Shellvacumar on 12/9/18.
//  Copyright © 2018 Sheeyam Shellvacumar. All rights reserved.
//

import UIKit

class CustomConsumeCell: UITableViewCell {

    @IBOutlet weak var foodLbl: UILabel!
    @IBOutlet weak var calLbl: UILabel!
    
    static let identifier = Constants.customCells.customConsumeCellIdentifier
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // nib
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(foodData: FoodModel){
        foodLbl?.text = foodData.foodName
        calLbl?.text = String(foodData.foodCalorie) + " Cals"
    }

}
