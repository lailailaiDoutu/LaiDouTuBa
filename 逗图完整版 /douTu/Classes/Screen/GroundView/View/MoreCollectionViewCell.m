//
//  MoreCollectionViewCell.m
//  Project
//
//  Created by  张泽军 on 2016/12/8.
//  Copyright © 2016年 HITWORLD. All rights reserved.
//

#import "MoreCollectionViewCell.h"

#import "UIImageView+WebCache.h"
#import "Masonry.h"

@implementation MoreCollectionViewCell

-(void)setModel:(MoreImage *)model
{
    if(_model != model)
    {
        _NameLabel.text = model.name;
        _NameLabel.font = [UIFont systemFontOfSize:14];
        _NameLabel.textColor = [UIColor blackColor];
        _NameLabel.textAlignment = NSTextAlignmentCenter;
        _NameLabel.numberOfLines = 0;
        _NameLabel.shadowColor = [UIColor whiteColor];
        _NameLabel.shadowOffset = CGSizeMake(2.0, 0);
        _NameLabel.text = model.name;
        [_image sd_setImageWithURL:[NSURL URLWithString:model.picPath]];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        
        [self drawDown];
    }
    return self;
}

- (void)drawDown
{
    [self.contentView addSubview:self.image];
    [self.contentView addSubview:self.NameLabel];
}

- (UIImageView *)image
{
    if(!_image)
    {
        _image = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width / 4, 10, self.frame.size.width / 2, self.frame.size.height / 2)];
    }
    return _image;
}

- (UILabel *)NameLabel
{
    if(!_NameLabel)
    {
        _NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, (SCREENWIDTH - 65) / 4, 30)];
    }
    return _NameLabel;
}
@end
