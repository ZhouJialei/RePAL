//
//  YDMenuItem.m
//  SideMenuDemo
//
//  Created by Peter van de Put on 12/09/2013.
//  Copyright (c) 2013 Peter van de Put. All rights reserved.
//

#import "YDMenuItem.h"
@interface YDMenuItem()

@property (nonatomic, strong) NSString *menuTitle;
@property (nonatomic, strong) NSString *backgroundColorHexString;
@property (nonatomic, strong) NSString *textColorHexString;
@property (nonatomic, strong) NSString* controllerTAG;
@property (nonatomic, strong) NSString* imageName;

@end

@implementation YDMenuItem

-(id)initWithTitle:(NSString *)title backgroundColorHexString:(NSString *)bgColorHexString textColorHexString:(NSString *)txtColorHexString viewControllerTAG:(NSString *)tag  imageName:(NSString *)image
{self = [super init];
	if ( self != nil)
	{
        self.menuTitle=title;
        self.backgroundColorHexString=bgColorHexString;
        self.textColorHexString=txtColorHexString;
        self.controllerTAG=tag;
        self.imageName=image;
	}
	return self;
}
@end
