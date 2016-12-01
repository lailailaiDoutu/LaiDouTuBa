//
//  makeModel.m
//  斗图APP
//
//  Created by wyzc04 on 16/12/1.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "makeModel.h"

@implementation makeModel

+(void)load{
    
    [makeModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID":@"id"};
    }];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}



@end
