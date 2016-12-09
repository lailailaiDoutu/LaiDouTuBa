//
//  cellLabel.m
//  GroupProject
//
//  Created by  张泽军 on 2016/12/6.
//  Copyright © 2016年 HITWORLD. All rights reserved.
//

#import "cellLabel.h"

@implementation cellLabel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"])
    {
        _Id = value;
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ +++ %@", self.name,self.Id];
}

@end
