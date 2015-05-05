//
//  SearchResultsViewController.swift
//  PAL
//
//  Created by 周佳磊 on 15/4/28.
//  Copyright (c) 2015年 &#21608;&#20339;&#30922;. All rights reserved.
//

import UIKit

class TeacherInfo {
    var name = ""
    var age = ""
    var ident = ""
    var prov = ""
    var city = ""
    var dist = ""
    var company = ""
    var description = ""
    var phone = ""
    var avatarUrl = ""
    var sex = ""
    var area = ""
    var coursePrice = ""
    var courseKind = ""
    var courseCategory = ""
    var course = ""
    var grade = ""
}




class SearchResultsViewController: UITableViewController {

    // Array to save the filter results
    var filterTeacherInfo: NSDictionary = NSDictionary()
    
    // Array to save the results for the cell
    var teacherArray: [Teacher] = []

    // Var to fetch the result
    var teacherInfo = TeacherInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return teacherArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultsCell") as ResultsCell
        
        cell.nameLabel.text = teacherArray[indexPath.row].name
        cell.gradeLabel.text = "评分:" + teacherArray[indexPath.row].grade
        cell.coursePriceLabel.text = teacherArray[indexPath.row].coursePrice + "元/课时"
        cell.minNumLabel.text = teacherArray[indexPath.row].courseMinNum + "课时起"
        cell.experienceLabel.text = teacherArray[indexPath.row].experience + "年"
        cell.courseLabel.text = teacherArray[indexPath.row].course 
        
        let url = NSURL(string: teacherArray[indexPath.row].avatarImageURL)
        let data = NSData(contentsOfURL: url!)
        
        cell.avatarImage.image = UIImage(data: data!)
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let destinationVC = segue.destinationViewController as PersonalViewController
//        // 获取当前所选cell的indexPath值
//        let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow()!
//        // 
//        let pid = teacherArray[indexPath.row].pid
//        
//        let parameters: [String: AnyObject] = ["pid": pid]
//        
//        destinationVC.name = teacherArray[indexPath.row].name
        
        let destinationVC = segue.destinationViewController as PersonalViewController
        destinationVC.teacherInfo = self.teacherInfo
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let parameters = [
            "pid": teacherArray[indexPath.row].pid
        ]
        println(parameters)
        
        request(.GET, teacherInfoAddress, parameters: parameters, encoding: .URL).responseJSON({
            (request, response, JSON, error) in
            
            if response != nil && JSON != nil {
                
                println(JSON)
                
                // Fetch the json result to the filterArray
                self.filterTeacherInfo = JSON as NSDictionary
                
                // fetch the results
                self.teacherInfo.phone = self.filterTeacherInfo.objectForKey("phone") as String
                self.teacherInfo.name = self.filterTeacherInfo.objectForKey("name") as String
                self.teacherInfo.sex = self.filterTeacherInfo.objectForKey("sex") as String
                var avatarUrl = self.filterTeacherInfo.objectForKey("head_thumb") as String
                self.teacherInfo.avatarUrl = avatarPreAddress + avatarUrl
                println(self.filterTeacherInfo.objectForKey("prov"))
                
                self.teacherInfo.area = self.filterTeacherInfo.objectForKey("prov") as String
                self.teacherInfo.course = self.teacherArray[indexPath.row].course
                self.teacherInfo.grade = self.teacherArray[indexPath.row].grade
                
                self.performSegueWithIdentifier("goConversation", sender: self)
            }else {
                let alertView = UIAlertView(title: "信息获取失败", message: "请检查网络状况，再试一次", delegate: nil, cancelButtonTitle: "确定")
                alertView.show()
            }
        })
    }
    @IBAction func returnTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
