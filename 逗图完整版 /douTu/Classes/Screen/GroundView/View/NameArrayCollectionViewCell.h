//
//  NameArrayCollectionViewCell.h
//  GroupProject
//
//  Created by  张泽军 on 2016/12/5.
//  Copyright © 2016年 HITWORLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cellLabel.h"

@interface NameArrayCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UILabel * NameLabel;

@property (nonatomic,strong) cellLabel * model;

@end
