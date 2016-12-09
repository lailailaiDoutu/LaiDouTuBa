//
//  MakeCollectionViewCell.m
//  斗图APP
//
//  Created by wyzc04 on 16/12/2.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "MakeCollectionViewCell.h"

@implementation MakeCollectionViewCell

-(void)setMakemodel:(makeModel *)makemodel{
    if(_makemodel != makemodel){
        _showLabel.text = makemodel.name;
        _showLabel.textColor = [UIColor blackColor];
        _showLabel.textAlignment = NSTextAlignmentCenter;
        _showLabel.numberOfLines = 0;
        _showLabel.shadowColor = [UIColor whiteColor];
        _showLabel.shadowOffset = CGSizeMake(2.0, 0);
        _showLabel.font = [UIFont boldSystemFontOfSize:15];
        //_showLabel.transform = CGAffineTransformMakeRotation(0.1);
        
        [_itemBackImageView sd_setImageWithURL:[NSURL URLWithString:makemodel.picPath]];
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

- (UIImageView *)gifImageView{
    if(!_gifImageView){
        
        _gifImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gif"]];
       
    }
    return _gifImageView;
}

- (void)layOut{
    [_itemBackImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.equalTo(0);
    }];
    
    [_showLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-5);
//        make.centerX.equalTo(_itemBackImageView);
        make.left.equalTo(5);
        make.right.equalTo(-5);
    }];
    [_gifImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(0);
        make.height.equalTo(20);
        make.width.equalTo(20);
        
    }];
    
}


@end
