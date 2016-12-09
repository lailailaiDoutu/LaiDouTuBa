//
//  CImage.m
//  Project
//
//  Created by  张泽军 on 2016/12/7.
//  Copyright © 2016年 HITWORLD. All rights reserved.
//

#import "CImage.h"

@implementation CImage

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ +++ %@",self.name,self.picPath];
}

@end
