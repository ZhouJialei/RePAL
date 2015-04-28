//
//  RecommandCell.swift
//  PAL
//
//  Created by 周佳磊 on 15/4/20.
//  Copyright (c) 2015年 &#21608;&#20339;&#30922;. All rights reserved.
//

import UIKit

class RecommandCell: UITableViewCell {

    @IBOutlet weak var portraitImage: UIImageView!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var schoolLabel: UITextField!
    @IBOutlet weak var courseLabel: UITextField!
    @IBOutlet weak var experienceLabel: UITextField!
    @IBOutlet weak var integerGradeImage: UIImageView!
    @IBOutlet weak var decimalGradeImage: UIImageView!
    @IBOutlet weak var availableImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
