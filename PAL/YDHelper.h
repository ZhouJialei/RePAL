//  YDChat
//
//  Created by Peter van de Put on 08/12/2013.
//  Copyright (c) 2013 YourDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDHelper : NSObject

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+(BOOL )createUser:(NSString *)username password:(NSString *)password name:(NSString *)name email:(NSString *)email;
+(NSString *)dayLabelForMessage:(NSDate *)msgDate;
@end
