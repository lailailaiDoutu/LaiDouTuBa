//
//  zjfSortModel.h
//  斗图APP
//
//  Created by wyzc04 on 16/12/2.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface zjfSortModel : NSObject
@property (nonatomic,copy)NSString * id;

//名字
@property (nonatomic,copy)NSString * name;
//静态图
@property (nonatomic,copy)NSString * picPath;
//动态图
@property (nonatomic,copy)NSString * gifPath;


@end
