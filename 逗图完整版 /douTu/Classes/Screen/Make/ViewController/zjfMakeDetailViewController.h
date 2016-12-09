//
//  MakeDetailViewController.h
//  斗图APP
//
//  Created by wyzc04 on 16/12/1.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "makeModel.h"
#import "zjfHotModel.h"
#import "zjfNewModel.h"
#import "zjfPersonDetailModel.h"
#import "zjfSortModel.h"
@interface zjfMakeDetailViewController : UIViewController
//图库传图片用
@property (nonatomic,strong)UIImage * localImage;


//制作主页model
@property (nonatomic,strong)makeModel * model;
//热门页model
@property (nonatomic,strong)zjfHotModel * hotModel;
//分类详情页model
@property (nonatomic,strong) zjfSortModel * sortModel;
//最新model
@property (nonatomic,strong)zjfNewModel * newzjfModel;

//动态真人model
@property (nonatomic,strong)zjfPersonDetailModel * personDetailModel;

@end
