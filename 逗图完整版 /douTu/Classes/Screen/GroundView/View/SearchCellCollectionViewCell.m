//
//  SearchCellCollectionViewCell.m
//  Project
//
//  Created by  张泽军 on 2016/12/7.
//  Copyright © 2016年 HITWORLD. All rights reserved.
//

#import "SearchCellCollectionViewCell.h"

#import "UIImageView+WebCache.h"

@implementation SearchCellCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self IMAGE];
        
        [self label];
    }
    return self;
}

- (void)IMAGE
{
    [self.contentView addSubview:self.image];
}

- (UIImageView *)image
{
    if (!_image)
    {
        _image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 20)];
        
        _image.layer.cornerRadius = 10;
        
        [_image.layer setMasksToBounds:YES];
    }
    return _image;
}

- (void)label
{
    [self.contentView addSubview:self.NameLabel];
}

- (UILabel *)NameLabel
{
    if (!_NameLabel)
    {
        _NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height / 2, self.frame.size.width, self.frame.size.height / 2)];
        
        _NameLabel.layer.cornerRadius = 10;
        
        _NameLabel.textAlignment = NSTextAlignmentCenter;
        
        _NameLabel.numberOfLines = 0;
        
        _NameLabel.font = [UIFont systemFontOfSize:12];
       
        [_NameLabel.layer setMasksToBounds:YES];
    }
    return _NameLabel;
}

- (void)setModel:(CImage *)model
{
    _model = model;
    
    self.NameLabel.text = model.name;
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.picPath]];
}

@end
