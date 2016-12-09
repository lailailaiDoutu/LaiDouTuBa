//
//  MoreImage.m
//  Project
//
//  Created by  张泽军 on 2016/12/8.
//  Copyright © 2016年 HITWORLD. All rights reserved.
//

#import "MoreImage.h"

@implementation MoreImage

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"])
    {
        _Id = value;
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ === %@ ===%@", self.name,self.picPath,self.Id];
}

@end
