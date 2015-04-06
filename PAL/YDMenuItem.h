//
//  YDMenuItem.h
//  SideMenuDemo
//
//  Created by Peter van de Put on 12/09/2013.
//  Copyright (c) 2013 Peter van de Put. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDMenuItem : NSObject

@property (nonatomic, readonly) NSString *menuTitle;
@property (nonatomic, readonly) NSString *backgroundColorHexString;
@property (nonatomic, readonly) NSString *textColorHexString;
@property (nonatomic, readonly) NSString* controllerTAG;
@property (nonatomic, readonly) NSString* imageName;

-(id)initWithTitle:(NSString *)title backgroundColorHexString:(NSString *)bgColorHexString textColorHexString:(NSString *)txtColorHexString viewControllerTAG:(NSString *)tag imageName:(NSString *)image;
@end
