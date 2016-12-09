//
//  zjfDetailTableViewCell.h
//  斗图APP
//
//  Created by wyzc04 on 16/12/4.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zjfMakeDetailModel.h"
@interface zjfDetailTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel * showLabel;

@property (nonatomic,strong)zjfMakeDetailModel * detailModel;
@end
