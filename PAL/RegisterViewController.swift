//
//  RegisterViewController.swift
//  PAL
//
//  Created by 周佳磊 on 15/4/29.
//  Copyright (c) 2015年 &#21608;&#20339;&#30922;. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var authCodeTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAuthTextField: UITextField!
    @IBOutlet weak var getAuthCode: UIButton!
    
    func delegate() -> YDAppDelegate {
        return UIApplication.sharedApplication().delegate as YDAppDelegate
    }
    
    let parentType: String = roleType.parents.rawValue
    let teacherType: String = roleType.parents.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getAuthCode(sender: UIButton) {
        self.getAuthCode.titleLabel?.text = "请等待"
        let phoneNumber = phoneNumberTextField.text
        var parameters = [
            "phone": phoneNumber,
            "role_type": teacherType
        ]
        request(.POST, authCodeAddress, parameters: parameters, encoding:.URL).responseJSON(){
            (request, response, JSON, error) in
            
            let response = JSON as NSDictionary
            let status = response.objectForKey("status") as Int
            
            println(status)
            
            if status == 0{
                self.getAuthCode.titleLabel?.text = "获取成功"
            }else {
                let alertView = UIAlertView(title: "获取失败", message: "请检查输入手机号，并在网络状况良好的情况下再试一次", delegate: nil, cancelButtonTitle: "确定")
                alertView.show()
                self.getAuthCode.titleLabel?.text = "获取验证码"
            }
        }
    }
    
    
    @IBAction func goRegister(sender: UIButton) {
        
        let phoneNumber: String = self.phoneNumberTextField.text
        let authCode: String = self.authCodeTextField.text
        let password: String = self.passwordTextField.text
        let authPassword: String = self.passwordAuthTextField.text
        
        let parameters = [
            "role_type": parentType,
            "phone": phoneNumber,
            "phone_check_num": authCode,
            "user_password": password.md5,
            "user_password_check": authPassword.md5
        ]
        request(.POST, innerNetRegisterAddress, parameters: parameters, encoding: .URL).responseJSON({
                (request, response, JSON, error) in
            
                println(request)
                println(response)
                println(JSON)
            
                let response = JSON as NSDictionary
                let status = response.objectForKey("status") as Int
                //返回值若 status == 0 则成功
                if status == 0 {
                    //若成功,在本地数据库存储jid与password
                    self.saveCredentials()
                    self.dismissViewControllerAnimated(true, completion: nil)
                }else {
                    //否则弹出窗口要求重新输入
                    let alertView = UIAlertView(title: "注册失败", message: "请检查输入，在网络状况良好的情况下再试一次", delegate: nil, cancelButtonTitle: "确定")
                    alertView.show()
                    self.getAuthCode.titleLabel?.text = "获取验证码"
                }
    })
    }
    
    @IBAction func returnTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveCredentials() {
        
        let keychain: KeychainItemWrapper = KeychainItemWrapper(identifier: "YDCHAT", accessGroup: nil)
        let jid = "\(self.phoneNumberTextField.text)@\(kXMPPServer)"
        NSUserDefaults.standardUserDefaults().setValue(jid, forKey: kXMPPmyJID)
        NSUserDefaults.standardUserDefaults().synchronize()
        keychain.setObject(self.passwordTextField.text, forKey: kSecValueData)  //kSecValueData总是对应password
        self.delegate().credentialsStored()
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
