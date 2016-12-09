//
//  makeModel.h
//  斗图APP
//
//  Created by wyzc04 on 16/12/1.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "zjfMakeDetailModel.h"
@interface makeModel : NSObject
//id
@property (nonatomic,copy)NSString * id;
//名字
@property (nonatomic,copy)NSString * name;
//静态图
@property (nonatomic,copy)NSString * picPath;

@property (nonatomic,copy)NSString * gifPath;
@property (nonatomic,assign)NSInteger createTime;
@property (nonatomic,assign)NSInteger  recommendTime;
//类型
@property (nonatomic,assign)BOOL mediaType;

@property (nonatomic,strong)zjfMakeDetailModel * detailModel;
@end
