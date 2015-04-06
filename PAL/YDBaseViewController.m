//
//  YDBaseViewController.m
//  PAL
//
//  Created by ZhouJialei on 15/2/2.
//  Copyright (c) 2015年 ZhouJialei. All rights reserved.
//

#import "YDBaseViewController.h"
#import "YDAppDelegate.h"
@interface YDBaseViewController ()

@property (nonatomic,strong) UILabel *statusLabel;

@end

@implementation YDBaseViewController

- (YDAppDelegate *)appDelegate
{
	return (YDAppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //if you dont want the menu buttons remove the following code
    /*
    //Create left menu button
    UIBarButtonItem *leftRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:
                                             [UIImage imageNamed:@"reveal-icon.png"]
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self action:@selector(toggleLeftMenu:)];
    self.navigationItem.leftBarButtonItem = leftRevealButtonItem;
    */
    UIImageView *statusImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, ScreenWidth, 26)];
    statusImage.image=[UIImage imageNamed:@"statusbar"];
    [self.view addSubview:statusImage];
    self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 60, ScreenWidth-60, 26)];
    self.statusLabel.backgroundColor=[UIColor clearColor];
    self.statusLabel.font = [UIFont systemFontOfSize:12];
    self.statusLabel.textColor = [UIColor redColor];
    self.statusLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.statusLabel];
     
}
-(void)updateStatus:(NSString *)newStatus
{
    self.statusLabel.text = newStatus;
}
-(void)toggleLeftMenu:(id)sender
{
 
    [[self appDelegate] toggleLeftMenu];
}
 

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
