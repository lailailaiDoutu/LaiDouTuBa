//
//  CellImage.m
//  Project
//
//  Created by  张泽军 on 2016/12/7.
//  Copyright © 2016年 HITWORLD. All rights reserved.
//

#import "CellImage.h"

@implementation CellImage


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", self.picPath];
}

@end
