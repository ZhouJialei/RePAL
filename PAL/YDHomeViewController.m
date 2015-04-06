//
//  YDHomeViewController.m
//  PAL
//
//  Created by ZhouJialei on 15/2/2.
//  Copyright (c) 2015年 ZhouJialei. All rights reserved.
//

#import "YDHomeViewController.h"
#import "YDAppDelegate.h"
@interface YDHomeViewController ()

@property (nonatomic,strong) UILabel *statusLabel;
@end

@implementation YDHomeViewController

- (YDAppDelegate *)appDelegate
{
	return (YDAppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor=[UIColor whiteColor];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100,260,200,80)];
    welcomeLabel.textColor = [UIColor redColor];
    welcomeLabel.backgroundColor=[UIColor clearColor];
    welcomeLabel.text = @"Welcome";
    welcomeLabel.adjustsFontSizeToFitWidth=YES;
    welcomeLabel.font = [UIFont systemFontOfSize:40];
    welcomeLabel.transform = CGAffineTransformMakeRotation((M_PI/14) * -1);
    [self.view addSubview:welcomeLabel];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
