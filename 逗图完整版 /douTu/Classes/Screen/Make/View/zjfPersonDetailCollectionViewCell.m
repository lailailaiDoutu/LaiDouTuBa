//
//  zjfPersonDetailCollectionViewCell.m
//  斗图APP
//
//  Created by wyzc04 on 16/12/5.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "zjfPersonDetailCollectionViewCell.h"

@implementation zjfPersonDetailCollectionViewCell

- (void)setPersonDetailmodel:(zjfPersonDetailModel *)personDetailmodel{
    if(_personDetailmodel != personDetailmodel){
        [_itemBackImageView sd_setImageWithURL:[NSURL URLWithString:personDetailmodel.picPath]];
        
        _showLabel.text = personDetailmodel.name;
        _showLabel.font = [UIFont systemFontOfSize:14];
        _showLabel.textColor = [UIColor blackColor];
        _showLabel.textAlignment = NSTextAlignmentCenter;
        
        
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self =[super initWithFrame:frame]){
        
        [self draw];
    }
    return self;
}

- (void)draw{
    [self.contentView addSubview:self.itemBackImageView];
    [self.contentView addSubview:self.showLabel];
    [self.contentView addSubview:self.gifImageView];
    [self layOut];
}

- (UIImageView *)itemBackImageView{
    
    if(!_itemBackImageView){
        
        _itemBackImageView = [[UIImageView alloc]init];
                              
    }
    return _itemBackImageView;
}

- (UIImageView *)gifImageView{
    if(!_gifImageView){
        
        _gifImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gif"]];
        
    }
    return _gifImageView;
}


- (UILabel *)showLabel{
    if(!_showLabel){
        _showLabel = [[UILabel alloc]init];
    }
    return _showLabel;
}

- (void)layOut{
    [_itemBackImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(0);
    }];
    
    [_showLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.bottom.equalTo(-10);
        make.height.equalTo(20);
        
    }];
    [_gifImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(0);
        make.height.equalTo(20);
        make.width.equalTo(20);
        
    }];

    
}

@end
