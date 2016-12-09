//
//  zjfSortCollectionViewCell.m
//  斗图APP
//
//  Created by wyzc04 on 16/12/5.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "zjfSortCollectionViewCell.h"

@implementation zjfSortCollectionViewCell

- (void)setFormWorkModel:(zjfformWorkModel *)formWorkModel{
    if(_formWorkModel != formWorkModel){
        
        _showLabel.text = formWorkModel.name;
        _showLabel.font = [UIFont systemFontOfSize:14];
        _showLabel.textColor = [UIColor blackColor];
        _showLabel.tintColor = [UIColor blackColor];
        _showLabel.textAlignment = NSTextAlignmentCenter;
        
        [_itemBackImageView sd_setImageWithURL:[NSURL URLWithString:formWorkModel.picPath]];
        
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
    [self layOut];
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
        make.top.equalTo(10);
        make.left.equalTo(25);
        make.right.equalTo(-25);
        make.bottom.equalTo(_showLabel.top).offset(-10);
    }];
    
    [_showLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.bottom.equalTo(-10);
        make.height.equalTo(20);
        
    }];
    
}
@end
