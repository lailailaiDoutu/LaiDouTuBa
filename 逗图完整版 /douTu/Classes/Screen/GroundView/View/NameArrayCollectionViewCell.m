//
//  NameArrayCollectionViewCell.m
//  GroupProject
//
//  Created by  张泽军 on 2016/12/5.
//  Copyright © 2016年 HITWORLD. All rights reserved.
//

#import "NameArrayCollectionViewCell.h"

@implementation NameArrayCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self label];
    }
    return self;
}

- (void)label
{
    [self.contentView addSubview:self.NameLabel];
}

- (UILabel *)NameLabel
{
    if (!_NameLabel)
    {
        _NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        _NameLabel.layer.cornerRadius = 10;
        
        _NameLabel.textAlignment = NSTextAlignmentCenter;
        
        [_NameLabel.layer setMasksToBounds:YES];
    }
    return _NameLabel;
}

- (void)setModel:(cellLabel *)model
{
    _model = model;
    
    self.NameLabel.text = model.name;
}

@end

