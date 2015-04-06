//
//  MyTabBarViewController.swift
//  PAL
//
//  Created by ZhouJialei on 15/2/4.
//  Copyright (c) 2015年 ZhouJialei. All rights reserved.
//

import UIKit



class MyTabBarViewController: UITabBarController, UITabBarControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        //to use the delegate method, you must set self as the delegate 
        //because you can't change the delegate of the UITabBar directly.
        self.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // function used to identify whether the user has been login or not, if not, turn to the LoginViewController
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        //设置变量存储NSUserDefault中的参数
        //一旦用户登陆，则必定用户名，密码，服务器地址都已存储，否则参数必定都为空
        let userName = NSUserDefaults.standardUserDefaults().stringForKey("kXMPPmyJID")
        
        //用于assert判断的参数
        //MARK: 已取消将serverAddress存入NSUserDefault中
        //let serverAddress = NSUserDefaults.standardUserDefaults().stringForKey("wxserver")
        //若参数为空
        if userName == nil{
            //MARK: 含assert判断，在开发末期将其删除
            //assert(serverAddress == nil ,"serverAddress不为空，NSUserDefault存储过程有误")
            self.performSegueWithIdentifier("goLogin", sender: self)
            return false
        }
        return true
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        return 
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
