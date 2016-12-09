//
//  zjfSearchCollectionViewCell.h
//  douTu
//
//  Created by  wyzc02 on 16/12/6.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zjfSearchModel.h"
@interface zjfSearchCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView * gifImageView;


@property (nonatomic,strong)UIImageView * itemBackImageView;

@property (nonatomic,strong)UILabel * showLabel;

@property (nonatomic,strong)zjfSearchModel * searchModel;

@end

