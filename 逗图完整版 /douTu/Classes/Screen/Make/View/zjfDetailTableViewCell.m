//
//  zjfDetailTableViewCell.m
//  斗图APP
//
//  Created by wyzc04 on 16/12/4.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "zjfDetailTableViewCell.h"

@implementation zjfDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self draw];
        }

    return self;
    
}

- (void)draw{
    [self.contentView addSubview:self.showLabel];
}

- (UILabel *)showLabel{
    if(!_showLabel){
        
        _showLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
        _showLabel.textAlignment = NSTextAlignmentCenter;
        _showLabel.highlightedTextColor = [UIColor greenColor];
        _showLabel.font = [UIFont systemFontOfSize:18];

    }
    return _showLabel;
    
}

-(void)setDetailModel:(zjfMakeDetailModel *)detailModel{
    if(_detailModel != detailModel){
        _showLabel.text = detailModel.word;
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
