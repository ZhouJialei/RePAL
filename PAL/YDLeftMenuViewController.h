//
//  SideMenuViewController.h
//
//  Created by Peter van de Put
//  Copyright (c) 2013 Peter van de Put. All rights reserved.


//This controller displays your menu
#import <UIKit/UIKit.h>
#import "YDMenuItem.h"
@protocol YDLeftMenuViewControllerDelegate <NSObject>

-(void)leftMenuSelectionItemClick:(YDMenuItem *)item;

@end
@interface YDLeftMenuViewController : UIViewController

@property (nonatomic, strong) id<YDLeftMenuViewControllerDelegate>  delegate;

@property(nonatomic,strong)NSArray* menuItems;



@end