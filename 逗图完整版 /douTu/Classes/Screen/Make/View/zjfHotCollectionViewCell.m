//
//  zjfHotCollectionViewCell.m
//  斗图APP
//
//  Created by wyzc04 on 16/12/2.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "zjfHotCollectionViewCell.h"



@implementation zjfHotCollectionViewCell

- (void)setHotModel:(zjfHotModel *)hotModel{
    if(_hotModel != hotModel){
        _showLabel.text = hotModel.name;
        _showLabel.font = [UIFont systemFontOfSize:14];
        _showLabel.textColor = [UIColor blackColor];
        _showLabel.tintColor = [UIColor blackColor];
        _showLabel.textAlignment = NSTextAlignmentCenter;
        _showLabel.numberOfLines = 0;
        _showLabel.shadowColor = [UIColor whiteColor];
        _showLabel.shadowOffset = CGSizeMake(2.0, 0);
        //_showLabel.transform = CGAffineTransformMakeRotation(0.1);
        [_itemBackImageView sd_setImageWithURL:[NSURL URLWithString:hotModel.picPath]];
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        [self drawDown];
    }
    return self;
    
}

- (void)drawDown{
    [self.contentView addSubview:self.itemBackImageView];
    [self.contentView addSubview:self.showLabel];
    [self.contentView addSubview:self.gifImageView];
    [self layOut];
}

- (UIImageView *)gifImageView{
    if(!_gifImageView){
        
        _gifImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gif"]];
        
    }
    return _gifImageView;
}

- (UIImageView *)itemBackImageView{
    if(!_itemBackImageView){
        
        _itemBackImageView = [[UIImageView alloc]init];
    }
    return _itemBackImageView;
}

- (UILabel *)showLabel{
    if(!_showLabel){
        _showLabel = [[UILabel alloc]init];
    }
    return _showLabel;
}

- (void)layOut{
    [_itemBackImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.equalTo(0);
    }];
    
    [_showLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(5);
        make.bottom.equalTo(-5);
        //make.height.equalTo(30);
        make.right.equalTo(-5);
    }];
    
    [_gifImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(0);
        make.height.equalTo(20);
        make.width.equalTo(20);
        
    }];

}
@end
