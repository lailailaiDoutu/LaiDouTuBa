//
//  zjfMySendCollectionViewCell.m
//  douTu
//
//  Created by wyzc04 on 16/12/7.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "zjfMySendCollectionViewCell.h"

@implementation zjfMySendCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        [self drawDown];
    }
    return self;
    
}

- (void)drawDown{
    [self.contentView addSubview:self.itemBackImageView];
    [self layOut];
}

- (UIImageView *)itemBackImageView{
    if(!_itemBackImageView){
        
        _itemBackImageView = [[UIImageView alloc]init];
    }
    return _itemBackImageView;
}

- (void)layOut{
    [_itemBackImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.equalTo(0);
    }];
    
}

@end
