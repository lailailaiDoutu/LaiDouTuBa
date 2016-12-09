//
//  zjfPersonCollectionViewCell.h
//  斗图APP
//
//  Created by wyzc04 on 16/12/2.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zjfPersonModel.h"
@interface zjfPersonCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)UIImageView * itemBackImageView;

@property (nonatomic,strong)UILabel * showLabel;

@property (nonatomic,strong)zjfPersonModel * personModel;

@property (nonatomic,assign)int chuanID;

@end
