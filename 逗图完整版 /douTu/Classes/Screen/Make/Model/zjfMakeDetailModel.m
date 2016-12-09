//
//  zjfMakeDetailModel.m
//  斗图APP
//
//  Created by wyzc04 on 16/12/4.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "zjfMakeDetailModel.h"

@implementation zjfMakeDetailModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ +++ %@", self.itemId,self.word];
}

@end
