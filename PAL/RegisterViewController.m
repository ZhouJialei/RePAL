//
//  RegisterViewController.m
//  PAL
//
//  Created by 周佳磊 on 15/4/21.
//  Copyright (c) 2015年 &#21608;&#20339;&#30922;. All rights reserved.
//

#import "RegisterViewController.h"
#import "PAL-Swift.h"
#import <AFNetworking.h>

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *authCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordAuthTextField;

@property (weak, nonatomic) NSString *registerAddress;
@end

@implementation RegisterViewController

@synthesize registerAddress;

- (IBAction)getAuthCode:(id)sender {
    registerAddress = @"http://192.168.1.11/pal_studio/index.php/Wap/Register/register";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{ @"role_type": @"2",
                                  @"phone": self.phoneNumberTextField.text,
                                  @"phone_check_num": self.authCodeTextField.text,
                                  @"user_password": self.passwordTextField.text,
                                  @"user_password_check": self.passwordAuthTextField.text
                                };
    [manager POST:registerAddress parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        [self dismissViewControllerAnimated:true completion:nil];
        [self.parentViewController dismissViewControllerAnimated:true completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)returnTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
