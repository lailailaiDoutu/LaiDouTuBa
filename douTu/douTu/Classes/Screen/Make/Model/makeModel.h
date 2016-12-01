//
//  makeModel.h
//  斗图APP
//
//  Created by wyzc04 on 16/12/1.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface makeModel : NSObject
//id
@property (nonatomic,copy)NSString * ID;
//名字
@property (nonatomic,copy)NSString * name;
//静态图
@property (nonatomic,copy)NSString * picPath;
//类型
@property (nonatomic,assign)BOOL mediaType;
@end
