//
//  YDSlideMenuContainerViewController.h
//
//  Created by Peter van de Put 
//  Copyright (c) 2013 Peter van de Put. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString * const MFSideMenuStateNotificationEvent;

typedef enum {
    YDSLideMenuPanModeNone = 0, // pan disabled
    YDSLideMenuPanModeCenterViewController = 1 << 0, // enable panning on the centerViewController
    YDSLideMenuPanModeSideMenu = 1 << 1, // enable panning on side menus
    YDSLideMenuPanModeDefault = YDSLideMenuPanModeCenterViewController | YDSLideMenuPanModeSideMenu
} YDSLideMenuPanMode;

typedef enum {
    YDSLideMenuStateClosed, // the menu is closed
    YDSLideMenuStateLeftMenuOpen, // the left-hand menu is open
    YDSLideMenuStateRightMenuOpen // the right-hand menu is open
} YDSLideMenuState;

typedef enum {
    YDSLideMenuStateEventMenuWillOpen, // the menu is going to open
    YDSLideMenuStateEventMenuDidOpen, // the menu finished opening
    YDSLideMenuStateEventMenuWillClose, // the menu is going to close
    YDSLideMenuStateEventMenuDidClose // the menu finished closing
} YDSLideMenuStateEvent;

@protocol YDSlideMenuContainerViewControllerDelegate <NSObject>

-(void)menuWillHide;

@end

@interface YDSlideMenuContainerViewController : UIViewController<UIGestureRecognizerDelegate>

+ (YDSlideMenuContainerViewController *)containerWithCenterViewController:(id)centerViewController
                                                  leftMenuViewController:(id)leftMenuViewController
                                                 rightMenuViewController:(id)rightMenuViewController;

@property (nonatomic, strong) id<YDSlideMenuContainerViewControllerDelegate>  delegate;


@property (nonatomic, strong) id centerViewController;
@property (nonatomic, strong) UIViewController *leftMenuViewController;
@property (nonatomic, strong) UIViewController *rightMenuViewController;

@property (nonatomic, assign) YDSLideMenuState menuState;
@property (nonatomic, assign) YDSLideMenuPanMode panMode;

// menu open/close animation duration -- user can pan faster than default duration, max duration sets the limit
@property (nonatomic, assign) CGFloat menuAnimationDefaultDuration;
@property (nonatomic, assign) CGFloat menuAnimationMaxDuration;

// width of the side menus
@property (nonatomic, assign) CGFloat menuWidth;
@property (nonatomic, assign) CGFloat leftMenuWidth;
@property (nonatomic, assign) CGFloat rightMenuWidth;

 

// menu slide-in animation
@property (nonatomic, assign) BOOL menuSlideAnimationEnabled;
@property (nonatomic, assign) CGFloat menuSlideAnimationFactor; // higher = less menu movement on animation


- (void)toggleLeftSideMenuCompletion:(void (^)(void))completion;
- (void)toggleRightSideMenuCompletion:(void (^)(void))completion;
- (void)setMenuState:(YDSLideMenuState)menuState completion:(void (^)(void))completion;
- (void)setMenuWidth:(CGFloat)menuWidth animated:(BOOL)animated;
- (void)setLeftMenuWidth:(CGFloat)leftMenuWidth animated:(BOOL)animated;
- (void)setRightMenuWidth:(CGFloat)rightMenuWidth animated:(BOOL)animated;

// can be used to attach a pan gesture recognizer to a custom view
- (UIPanGestureRecognizer *)panGestureRecognizer;

@end