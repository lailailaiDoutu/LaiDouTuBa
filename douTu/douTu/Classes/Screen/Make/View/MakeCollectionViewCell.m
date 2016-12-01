//
//  MakeCollectionViewCell.m
//  斗图APP
//
//  Created by wyzc04 on 16/11/30.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "MakeCollectionViewCell.h"

@interface MakeCollectionViewCell () 
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;

@end

@implementation MakeCollectionViewCell

- (void)setMakemodel:(makeModel *)makemodel{
    
    if(_makemodel != makemodel){
        
        _showLabel.text = makemodel.name;
        [_itemImageView sd_setImageWithURL:[NSURL URLWithString:makemodel.picPath]];
        
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
