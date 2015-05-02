//
//  TimeLineCell.swift
//  PAL
//
//  Created by 周佳磊 on 15/5/1.
//  Copyright (c) 2015年 &#21608;&#20339;&#30922;. All rights reserved.
//

import UIKit

class TimeLineCell: UITableViewCell {

    @IBOutlet weak var teacherNameLabel: UILabel!
    @IBOutlet weak var courseTimeLabel: UILabel!
    @IBOutlet weak var totalCourseLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var teacherImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
