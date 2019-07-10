//
//  FNCustomView.m
//  FN_iOS_Weex_Demo
//
//  Created by Mingyoung on 2019/6/10.
//  Copyright © 2019 feiniu. All rights reserved.
//

#import "FNCustomView.h"


@implementation FNCustomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:frame];
        [self addSubview:titleLabel];
        titleLabel.text = @"我是自定义view";
        titleLabel.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, 0, 100, 44);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
