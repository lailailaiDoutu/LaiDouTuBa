//
//  ImageCollectionViewCell.h
//  GroupProject
//
//  Created by  张泽军 on 2016/12/5.
//  Copyright © 2016年 HITWORLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellImage.h"

@interface ImageCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) CellImage * model;

@property (nonatomic,strong) UIImageView * image;

@end
