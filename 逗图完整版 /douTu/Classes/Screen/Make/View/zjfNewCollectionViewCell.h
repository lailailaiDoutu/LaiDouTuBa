//
//  zjfNewCollectionViewCell.h
//  斗图APP
//
//  Created by wyzc04 on 16/12/2.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zjfNewModel.h"
@interface zjfNewCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)UIImageView * itemBackImageView;
@property (nonatomic,strong)UIImageView * gifImageView;

@property (nonatomic,strong)UILabel * showLabel;

@property (nonatomic,strong)zjfNewModel * newzjfModel;

@end
