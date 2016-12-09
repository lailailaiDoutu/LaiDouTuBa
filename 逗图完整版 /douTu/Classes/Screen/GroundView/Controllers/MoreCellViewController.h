//
//  MoreCellViewController.h
//  Project
//
//  Created by  张泽军 on 2016/12/8.
//  Copyright © 2016年 HITWORLD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "cellLabel.h"

@interface MoreCellViewController : UIViewController

@property (nonatomic,strong) cellLabel * model;

@property (nonatomic,copy) NSString * Id;
@end
