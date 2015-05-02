//
//  SettingViewController.swift
//  PAL
//
//  Created by 周佳磊 on 15/5/1.
//  Copyright (c) 2015年 &#21608;&#20339;&#30922;. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    func delegate() -> YDAppDelegate {
        return UIApplication.sharedApplication().delegate as YDAppDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutTapped(sender: AnyObject) {
        
        let keychain: KeychainItemWrapper = KeychainItemWrapper(identifier: "YDCHAT", accessGroup: nil)
        // Delete the standardUserDefaults and reset the keychainItem
        NSUserDefaults.standardUserDefaults().removeObjectForKey(kXMPPmyJID)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(kSecValueData)
        keychain.resetKeychainItem()
        
        // then teardown the Stream
        self.delegate().disconnect()
        self.tabBarController?.selectedIndex = 0
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
