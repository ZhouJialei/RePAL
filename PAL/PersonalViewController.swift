//
//  PersonalViewController.swift
//  PAL
//
//  Created by ZhouJialei on 15/2/3.
//  Copyright (c) 2015年 ZhouJialei. All rights reserved.
//

import UIKit

class PersonalViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // 用于存储由SearchResultsViewController传来的电话号码和名字
    var phone: String = ""
    var name: String = ""
    
    // MARK: vars to fill the VC
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var teacherInfoLabel: UILabel!
    
    
    // TeacherInfo to fill the tableView
    var teacherInfo = TeacherInfo()
    
    func delegate() -> YDAppDelegate {
        return UIApplication.sharedApplication().delegate as YDAppDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL(string: teacherInfo.avatarUrl)
        
        let data = NSData(contentsOfURL: url!)
        avatarImage.image = UIImage(data: data!)
        
        phoneNumberLabel.text = self.teacherInfo.phone
        teacherInfoLabel.text = self.teacherInfo.sex + " " + self.teacherInfo.area
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println(self.teacherInfo.phone)
        println(self.teacherInfo.name)
        assert(self.teacherInfo.phone != "" && self.teacherInfo.name != "", "名字不能为空,检查与之相连的segue")
        // 发送添加好友请求给服务器
        let jidString = "\(self.teacherInfo.phone)@\(kXMPPServer)"
        self.delegate().sendInvitationToJID(jidString, withNickName: self.teacherInfo.name)
        // 调用showConversation的代理函数
        let destinationVC = segue.destinationViewController as YDConversationViewController
        destinationVC.showConversationForJIDString(jidString)
        
    }
    
    // MARK; UITableView Delegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 4
        }else {
            return 5
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("courseInfo") as CourseInfoCell
            cell.descLabel.text = self.teacherInfo.course
            cell.informationLabel.text = self.teacherInfo.coursePrice
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("courseDetail") as UITableViewCell
            if indexPath.row == 0 {
                cell.textLabel?.text = "课程简介"
                return cell
            }else if indexPath.row == 1 {
                cell.textLabel?.text = "教学方法"
                return cell
            }else if indexPath.row == 2 {
                cell.textLabel?.text = "针对学生"
                return cell
            }else{
                cell.textLabel?.text = "取得成效"
                return cell
            }
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("courseInfo") as CourseInfoCell
            if indexPath.row == 0 {
                cell.descLabel.text = "家教经验"
                cell.informationLabel.text = "一年"
                return cell
            }else if indexPath.row == 1 {
                cell.descLabel.text = "就读院校"
                cell.informationLabel.text = "西电科大"
                return cell
            }else if indexPath.row == 2 {
                cell.descLabel.text = "最高学历"
                cell.informationLabel.text = "本科"
                return cell
            }else if indexPath.row == 3 {
                cell.descLabel.text = "最擅长"
                cell.informationLabel.text = "初中文科双语"
                return cell
            }else{
                cell.descLabel.text = "授课区域"
                cell.informationLabel.text = "长安区,雁塔区"
                return cell
            }
        }
        
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "授课信息"
        }else if section == 1 {
            return "课程详细"
        }else if section == 2 {
            return "个人信息"
        }else {
            return ""
        }
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
