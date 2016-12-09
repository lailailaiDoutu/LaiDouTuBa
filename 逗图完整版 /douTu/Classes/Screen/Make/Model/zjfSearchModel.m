//
//  zjfSearchModel.m
//  douTu
//
//  Created by  wyzc02 on 16/12/6.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "zjfSearchModel.h"

@implementation zjfSearchModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@ %@", self.id,self.picPath,self.gifPath];
}

@end
