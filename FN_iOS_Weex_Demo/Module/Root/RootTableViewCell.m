//
//  RootTableViewCell.m
//  FN_iOS_Weex_Demo
//
//  Created by Mingyoung on 2019/6/6.
//  Copyright © 2019 feiniu. All rights reserved.
//

#import "RootTableViewCell.h"

@implementation RootTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabel.layer.cornerRadius = 10;
    self.titleLabel.clipsToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
