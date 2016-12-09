//
//  MoreCollectionViewCell.h
//  Project
//
//  Created by  张泽军 on 2016/12/8.
//  Copyright © 2016年 HITWORLD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MoreImage.h"

@interface MoreCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView * image;

@property (nonatomic,strong) UILabel * NameLabel;

@property (nonatomic,strong) MoreImage * model;
 
@end
