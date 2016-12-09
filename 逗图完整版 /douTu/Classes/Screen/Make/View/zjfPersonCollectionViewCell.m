//
//  zjfPersonCollectionViewCell.m
//  斗图APP
//
//  Created by wyzc04 on 16/12/2.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "zjfPersonCollectionViewCell.h"

@implementation zjfPersonCollectionViewCell
-(void)setPersonModel:(zjfPersonModel *)personModel{
    
if(_personModel != personModel){
        _showLabel.text = personModel.name;
        _showLabel.font = [UIFont systemFontOfSize:14];
        _showLabel.textColor = [UIColor blackColor];
        _showLabel.textAlignment = NSTextAlignmentCenter;
        _showLabel.numberOfLines = 0;
        _showLabel.shadowColor = [UIColor whiteColor];
        _showLabel.shadowOffset = CGSizeMake(2.0, 0);
        //_showLabel.transform = CGAffineTransformMakeRotation(0.1);
        [_itemBackImageView sd_setImageWithURL:[NSURL URLWithString:personModel.picPath]];
    
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
        _showLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, (SCREENWIDTH-80)/3, 25)];
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
    
//    [_showLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(5);
//        make.bottom.equalTo(-10);
//        //make.height.equalTo(20);
//        make.right.equalTo(-5);
//    }];
}
@end
