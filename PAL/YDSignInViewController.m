//
//  YDSignInViewController.m
//  PAL
//
//  Created by ZhouJialei on 15/2/2.
//  Copyright (c) 2015年 ZhouJialei. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "YDSignInViewController.h"
#import "KeychainItemWrapper.h"
@interface YDSignInViewController ()

@property (nonatomic,strong) UITextField *jidField;
@property (nonatomic,strong) UITextField *passwordField;
@end

@implementation YDSignInViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton=YES;
    
    
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.title = @"Sign in";
    
   
    self.jidField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 80.0, 280, 25.0)];
	self.jidField.borderStyle = UITextBorderStyleNone;
    self.jidField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	self.jidField.tag = 1;
	self.jidField.keyboardType = UIKeyboardTypeDefault;
	self.jidField.backgroundColor = [UIColor whiteColor];
	self.jidField.font = [UIFont systemFontOfSize:14.0];
	self.jidField.autocorrectionType = UITextAutocorrectionTypeNo;
	self.jidField.placeholder = @"Enter username";
	self.jidField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.jidField.returnKeyType = UIReturnKeyNext;
    self.jidField.borderStyle = UITextBorderStyleRoundedRect;
    self.jidField.layer.borderWidth = 1.0f;
    self.jidField.layer.borderColor = [[UIColor grayColor] CGColor];
    self.jidField.layer.cornerRadius = 5.0f;
    [self.view addSubview:self.jidField ];
    
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 120.0, 280, 25.0)];
	self.passwordField.borderStyle = UITextBorderStyleNone;
    self.passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	self.passwordField.tag = 2;
	self.passwordField.keyboardType = UIKeyboardTypeDefault;
	self.passwordField.backgroundColor = [UIColor whiteColor];
	self.passwordField.font = [UIFont systemFontOfSize:14.0];
	self.passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
	self.passwordField.placeholder = @"Enter the password";
    self.passwordField.secureTextEntry = YES;
	self.passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.passwordField.returnKeyType = UIReturnKeyNext;
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.layer.borderWidth = 1.0f;
    self.passwordField.layer.borderColor = [[UIColor grayColor] CGColor];
    self.passwordField.layer.cornerRadius = 5.0f;
    [self.view addSubview:self.passwordField ];
    
    UIButton* signInButton = [[UIButton alloc] initWithFrame:CGRectMake(20,160,280,25)];
    signInButton.backgroundColor=[UIColor blueColor];
    signInButton.layer.borderWidth = 1.0f;
    signInButton.layer.borderColor = [[UIColor grayColor] CGColor];
    signInButton.layer.cornerRadius = 5.0f;
    [signInButton addTarget:self action:@selector(saveCredentials:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *signInLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,280,25)];
    signInLabel.backgroundColor=[UIColor clearColor];
    [signInLabel setFont:[UIFont systemFontOfSize:16]];
    signInLabel.text=@"Sign in";
    signInLabel.adjustsFontSizeToFitWidth=YES;
    signInLabel.textAlignment=NSTextAlignmentCenter;
    signInLabel.textColor=[UIColor whiteColor];
    [signInButton addSubview:signInLabel];
    [self.view addSubview:signInButton];
    //Cancel
    UIButton* cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(20,200,280,25)];
    cancelButton.backgroundColor=[UIColor blueColor];
    cancelButton.layer.borderWidth = 1.0f;
    cancelButton.layer.borderColor = [[UIColor grayColor] CGColor];
    cancelButton.layer.cornerRadius = 5.0f;
    [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,280,25)];
    cancelLabel.backgroundColor=[UIColor clearColor];
    [cancelLabel setFont:[UIFont systemFontOfSize:16]];
    cancelLabel.text=@"Cancel";
    cancelLabel.adjustsFontSizeToFitWidth=YES;
    cancelLabel.textAlignment=NSTextAlignmentCenter;
    cancelLabel.textColor=[UIColor whiteColor];
    [cancelButton addSubview:cancelLabel];
    [self.view addSubview:cancelButton];

    
}
-(IBAction)saveCredentials:(UIButton *)sender
{
    if (([self.jidField.text length] == 0) ||([self.passwordField.text length] == 0) )
        {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oeps"
                            message:@"Both fields are mandatory"
                            delegate:self cancelButtonTitle:@"OK"
                            otherButtonTitles:nil, nil];
        [alert show];
        return;
        }
    else
        {
        KeychainItemWrapper* keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"YDCHAT" accessGroup:nil];
        NSString *jid = [NSString stringWithFormat:@"%@@%@",self.jidField.text,kXMPPServer];
        [[NSUserDefaults standardUserDefaults] setValue:jid forKey:kXMPPmyJID];
        [[NSUserDefaults standardUserDefaults]  synchronize];
         [keychain setObject:self.passwordField.text forKey:(__bridge id)kSecValueData];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [self.delegate credentialsStored];
        }
    
}
-(IBAction)cancel:(UIButton *)sender
{
     [self.navigationController popToRootViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
