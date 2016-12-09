//
//  ImageCollectionViewCell.m
//  GroupProject
//
//  Created by  张泽军 on 2016/12/5.
//  Copyright © 2016年 HITWORLD. All rights reserved.
//

#import "ImageCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self PPT];
    }
    return self;
}

- (void)PPT
{
    [self.contentView addSubview:self.image];
}

- (UIImageView *)image
{
    if (!_image)
    {
        _image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _image.layer.cornerRadius = 10;
        [_image.layer setMasksToBounds:YES];
    }
    return _image;
}

- (void)setModel:(CellImage *)model
{
    _model = model;
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.picPath]];
}

@end


