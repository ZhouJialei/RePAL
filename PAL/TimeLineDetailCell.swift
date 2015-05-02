//
//  TimeLineDetailCell.swift
//  PAL
//
//  Created by 周佳磊 on 15/5/1.
//  Copyright (c) 2015年 &#21608;&#20339;&#30922;. All rights reserved.
//

import UIKit

class TimeLineDetailCell: UITableViewCell {

    @IBOutlet weak var timeLineImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var logTitleLabel: UILabel!
    @IBOutlet weak var homeworkLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
