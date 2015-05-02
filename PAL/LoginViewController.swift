//
//  LoginViewController.swift
//  PAL
//
//  Created by ZhouJialei on 15/2/2.
//  Copyright (c) 2015年 ZhouJialei. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{

    //登录视图
    //1.借鉴微信，qq的登录设置，一旦用户登录app，默认其为自动登录
    

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    
    func delegate() -> YDAppDelegate {
        return UIApplication.sharedApplication().delegate as YDAppDelegate
    }
    
    //登陆
    @IBAction func loginTapped(sender: AnyObject) {
        var userName: String = userTextField.text
        var userPassword: String = passwordTextField.text.md5
        
        let parameters = ["roletype": "2", "phone": userName,
        "password": userPassword]
        
        //MARK: request请求中的服务器地址用serverAddress常量定义，serverAddress定义与address.swift中
        
        request(.POST,
            serverAddress,        //地址用常量
            parameters: parameters,
            encoding: .URL).responseJSON{(request, response, JSON, erro) in
                //as we know, the return type of JSON is NSDictionary as well
                //but it's impossible for the compiler to know the type of the 
                //JSON(the exact type is NSDictionary)'s key and value
                //so we must do the following thing
                //println(response)
                let response = JSON as NSDictionary
                let status = response.objectForKey("status") as Int
                println(JSON)
                //then we deal with the response
                //如果登陆成功，则将用户名密码服务器地址都存入NSUserDefault中
                //并自动配置自动登陆
                if status == 0 {
                    self.saveCredentials()
                    //并跳转回主页
                    self.dismissViewControllerAnimated(true, completion: nil)  
                }else {
                    let alertView = UIAlertView(title: "登录失败", message: "请检查用户名密码，并确保网络通畅", delegate: nil, cancelButtonTitle: "确定")
                    alertView.show()
                }
        }
    }
    
    @IBAction func returnTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func saveCredentials() {
        
        let keychain: KeychainItemWrapper = KeychainItemWrapper(identifier: "YDCHAT", accessGroup: nil)
        let jid = "\(self.userTextField.text)@\(kXMPPServer)"
        NSUserDefaults.standardUserDefaults().setValue(jid, forKey: kXMPPmyJID)
        NSUserDefaults.standardUserDefaults().synchronize()
        keychain.setObject(self.passwordTextField.text, forKey: kSecValueData)  //kSecValueData总是对应password
        self.delegate().credentialsStored()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
