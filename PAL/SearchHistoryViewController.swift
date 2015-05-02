//
//  SearchHistoryViewController.swift
//  PAL
//
//  Created by 周佳磊 on 15/4/28.
//  Copyright (c) 2015年 &#21608;&#20339;&#30922;. All rights reserved.
//

import UIKit

class Teacher {
    var name: String = ""
    var course: String = ""
    var grade: String = ""
    var experience: String = ""
    var avatarImageURL: String = ""
    var phoneNumber: String = ""
    var pid: String = ""
    var coursePrice: String = ""
    var courseMinNum: String = ""
}

class SearchHistoryViewController: UITableViewController,UISearchBarDelegate {

    // Array to save the filter results
    var filterArray: [NSDictionary] = []
    
    // Array to save the results for the cell
    var teacherArray: [Teacher] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchBar.text = searchKey
        searchKey = ""
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
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        var searchString: String = searchBar.text
        let parameters = ["generalsearch": searchString]
        
        request(.GET, searchAddress, parameters: parameters, encoding: .URL).responseJSON({
            (request, response, JSON, error) in
            
            println(JSON)
            println(response)
            println(request)
            println(error)
            
            if response != nil && JSON != nil {
                
                // Fetch the json result to the filterArray
                self.filterArray = JSON as [NSDictionary]
                
                // Fill the teacherArray
                for item in self.filterArray {
                    
                    // Create the object for the temp save
                    var teacher: Teacher = Teacher()
                    
                    teacher.name = item.objectForKey("prod_name") as String
                    teacher.coursePrice = item.objectForKey("good_price") as String
                    teacher.courseMinNum = item.objectForKey("good_minnum") as String
                    teacher.grade = item.objectForKey("prod_grade") as String
                    
                    var kind = item.objectForKey("good_kind_name") as String
                    var category = item.objectForKey("good_cate_name") as String
                    teacher.course = kind + " " + category
                    
                    teacher.experience = item.objectForKey("prod_experience") as String
                    teacher.pid = item.objectForKey("prod_id") as String
                    

                    var preUrl = "http://192.168.1.11/pal_studio/Uploads/head_thumb/User/"
                    var avatarUrl = item.objectForKey("prod_head_thumb") as String
                    teacher.avatarImageURL = preUrl + avatarUrl
                    
                    self.teacherArray.append(teacher)
                }
            } else {
                let alertView = UIAlertView(title: "搜索失败", message: "请确保网络通畅,稍后再试", delegate: nil, cancelButtonTitle: "确定")
                alertView.show()
                return
            }
            self.performSegueWithIdentifier("goResults", sender: self)
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goResults" {
            let destinationVC = segue.destinationViewController as SearchResultsViewController
            
            println(self.teacherArray.count)
            assert(self.teacherArray.count != 0, "error")
            destinationVC.teacherArray = teacherArray
            
        } else {
            return
        }
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
