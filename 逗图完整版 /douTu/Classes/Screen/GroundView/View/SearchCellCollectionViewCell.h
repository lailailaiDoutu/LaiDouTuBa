//
//  SearchCellCollectionViewCell.h
//  Project
//
//  Created by  张泽军 on 2016/12/7.
//  Copyright © 2016年 HITWORLD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CImage.h"

@interface SearchCellCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) CImage * model;

@property (nonatomic,strong) UIImageView * image;

@property (nonatomic,strong) UILabel * NameLabel;

@end
