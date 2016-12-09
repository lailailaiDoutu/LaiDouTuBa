//
//  zjfSearchCollectionViewCell.m
//  斗图APP
//
//  Created by wyzc04 on 16/12/6.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "zjfSearchCollectionViewCell.h"

@implementation zjfSearchCollectionViewCell
-(void)setSearchModel:(zjfSearchModel *)searchModel{
    
    if(_searchModel != searchModel){
        
        [_itemBackImageView sd_setImageWithURL:[NSURL URLWithString:searchModel.picPath]];
        [_itemBackImageView sd_setImageWithURL:[NSURL URLWithString:searchModel.gifPath]];
        
        
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
    [self.contentView addSubview:self.itemBackImageView];
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
        make.left.top.bottom.right.equalTo(0);
    }];
    
    [_showLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-5);
        make.centerX.equalTo(_itemBackImageView);
    }];
    
    [_gifImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(0);
        make.height.equalTo(20);
        make.width.equalTo(20);
        
    }];

    
}

@end
