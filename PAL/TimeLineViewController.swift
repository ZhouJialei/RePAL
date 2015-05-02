//
//  TimeLineViewController.swift
//  PAL
//
//  Created by 周佳磊 on 15/5/1.
//  Copyright (c) 2015年 &#21608;&#20339;&#30922;. All rights reserved.
//

import UIKit

class TimeLine {
    var teacherName = ""
    var courseTime = ""
    var totalCourse = ""
    var finishedCourse = ""
    var courseName = ""
    // MARK:TODO:change the imageName to the url
    var imageName = ""
}


class TimeLineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    // MARK:TODO:hard code to fill the tableView,need to be requested
    var timeLineArray: [TimeLine] = [TimeLine]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for (var i = 0;i < 5;++i){
            var timeLine = TimeLine()
            timeLine.teacherName = "赵小龙"
            timeLine.courseTime = "2014.10.04-2015.10.04"
            timeLine.totalCourse = "20"
            timeLine.finishedCourse = "10"
            timeLine.courseName = "赵小龙老师的钢琴课"
            timeLine.imageName = "1.jpg"
            timeLineArray.append(timeLine)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimeLineCell") as TimeLineCell
        let index = indexPath.row
        
        cell.teacherImage.image = UIImage(named: timeLineArray[index].imageName)
        cell.teacherNameLabel.text = timeLineArray[index].teacherName
        cell.courseTimeLabel.text = timeLineArray[index].courseTime
        cell.totalCourseLabel.text = timeLineArray[index].totalCourse + "(已完成:" + timeLineArray[index].finishedCourse + ")"
        cell.courseNameLabel.text = timeLineArray[index].courseName
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
