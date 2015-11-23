//
//  UserHobby.m
//  Fresh_water_daily
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 yangkenneg.com. All rights reserved.
//

#import "UserHobby.h"

@implementation UserHobby

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        self.Description = value;
    }
}


@end
