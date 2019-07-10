//
//  FNLoginViewController.m
//  FN_iOS_Weex_Demo
//
//  Created by Mingyoung on 2019/6/10.
//  Copyright © 2019 feiniu. All rights reserved.
//

#import "FNLoginViewController.h"
#import "FNUser.h"

@interface FNLoginViewController ()

@property (nonatomic, copy) void(^loginComplete)(BOOL success);
@end

@implementation FNLoginViewController

- (instancetype)initWithComplete:(void(^)(BOOL success))loginComplete
{
    if (self = [super initWithNibName:NSStringFromClass([FNLoginViewController class]) bundle:nil]) {
        self.loginComplete = loginComplete;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)loginFailureBtnClick:(id)sender {
    
    [FNUser shared].userInfo = nil;
    
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
       if(weakSelf.loginComplete) {
           weakSelf.loginComplete(false);
        }
    }];
}

- (IBAction)loginSuccessBtnClick:(id)sender {
    
    
    
    FNUserInfo *userinfo = [FNUserInfo new];
    userinfo.userId = @"100000001";
    userinfo.username = @"我是小肥牛...嘻嘻";
    userinfo.token = @"heuhieuhiu3ehreiuwrhuiwe";
    [FNUser shared].userInfo = userinfo;
    
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if(weakSelf.loginComplete) {
            weakSelf.loginComplete(true);
        }
    }];
}


@end
