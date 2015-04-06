//
//  YDSignInViewController.h
//  PAL
//
//  Created by ZhouJialei on 15/2/2.
//  Copyright (c) 2015年 ZhouJialei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YDSignInViewControllerDelegate <NSObject>

-(void)credentialsStored;

@end
@interface YDSignInViewController : UIViewController
@property (nonatomic, strong) id<YDSignInViewControllerDelegate>  delegate;
@end
