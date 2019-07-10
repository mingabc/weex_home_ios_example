//
//  FNWebViewController.m
//  FN_iOS_Weex_Demo
//
//  Created by Mingyoung on 2019/6/19.
//  Copyright © 2019 feiniu. All rights reserved.
//

#import "FNWebViewController.h"

@interface FNWebViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic,copy) NSString *url;
@end

@implementation FNWebViewController

- (instancetype)initWithUrl:(NSString *)url {
    if (self = [super init]) {
        self.url = url;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =  @"h5";
    self.titleLabel.text = [NSString stringWithFormat:@"URL:  %@",self.url];
}

@end
