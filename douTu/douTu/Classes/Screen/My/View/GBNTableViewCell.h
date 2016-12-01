//
//  GBNTableViewCell.h
//  douTu
//
//  Created by  wyzc02 on 16/12/1.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBNTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headerImage;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UILabel *twoLabel;
@property (strong, nonatomic) IBOutlet UIImageView *gameImage;

@end
