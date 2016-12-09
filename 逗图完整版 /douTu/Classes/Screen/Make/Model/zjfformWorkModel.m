//
//  zjfformWorkModel.m
//  斗图APP
//
//  Created by wyzc04 on 16/12/6.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "zjfformWorkModel.h"

@implementation zjfformWorkModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ === %@ %@", self.name,self.picPath,self.id];
}


@end
