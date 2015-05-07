//
//  MyTabBarViewController.swift
//  PAL
//
//  Created by ZhouJialei on 15/2/4.
//  Copyright (c) 2015年 ZhouJialei. All rights reserved.
//

import UIKit


class MyTabBarViewController: UITabBarController, UITabBarControllerDelegate{

    
    func delegate() -> YDAppDelegate {
        return UIApplication.sharedApplication().delegate as YDAppDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //to use the delegate method, you must set self as the delegate 
        //because you can't change the delegate of the UITabBar directly.
        self.delegate = self
        // Do any additional setup after loading the view.
        //1.从userDefaults,keychainItem中取数据
//        var userStr = NSUserDefaults.standardUserDefaults().objectForKey(kXMPPmyJID) as String
//        var userName = userStr.stringByReplacingOccurrencesOfString("@\(kXMPPServer)", withString: "")
//        let keychain: KeychainItemWrapper = KeychainItemWrapper(identifier: "YDCHAT", accessGroup: nil)
//        var userPassword = keychain.objectForKey(kSecValueData) as String
//        
//        if userStr != nil && userName != nil {
//            
//        }
//        
//        var parameters = ["roletype": "2", "phone": userName,
//            "password": userPassword]
//        //2.若为空则要跳转至登陆页面,否则正常页面跳转
//        request(.POST,
//            serverAddress,        //地址用常量
//            parameters: parameters,
//            encoding: .URL).responseJSON{(request, response, JSON, erro) in
//                //as we know, the return type of JSON is NSDictionary as well
//                //but it's impossible for the compiler to know the type of the
//                //JSON(the exact type is NSDictionary)'s key and value
//                //so we must do the following thing
//                //println(response)
//                let response = JSON as NSDictionary
//                let key = response.objectForKey("status") as Int
//                //then we deal with the response
//                //如果登陆成功，则将用户名密码服务器地址都存入NSUserDefault中
//                //并自动配置自动登陆
//                self.status = key
//        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // function used to identify whether the user has been login or not, if not, turn to the LoginViewController
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        //获取islogged变量
        var status = self.delegate().isLogged
        //为0则登陆成功，为-1则后台并无数据存储，否则不跳转并弹出警告
        if status == -1 {
            self.performSegueWithIdentifier("goLogin", sender: self)
            return false
        }else if status == 0 {
            return true
        }else {
            let alertView = UIAlertView(title: "系统异常", message: "系统存储数据与服务器匹配异常，请稍后再试", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            return false
        }
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
