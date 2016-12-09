//
//  zjfSortCollectionViewCell.h
//  斗图APP
//
//  Created by wyzc04 on 16/12/5.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zjfformWorkModel.h"
@interface zjfSortCollectionViewCell : UICollectionViewCell


@property (nonatomic,strong)UILabel * showLabel;

@property (nonatomic,strong)UIImageView * itemBackImageView;

@property (nonatomic,strong)zjfformWorkModel * formWorkModel;

@end
