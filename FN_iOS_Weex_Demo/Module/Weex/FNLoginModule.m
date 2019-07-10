//
//  FNLoginModule.m
//  FN_iOS_Weex_Demo
//
//  Created by Mingyoung on 2019/6/10.
//  Copyright © 2019 feiniu. All rights reserved.
//

#import "FNLoginModule.h"
#import "AppDelegate.h"
#import "FNLoginViewController.h"
#import "FNUser.h"

@implementation FNLoginModule

WX_EXPORT_METHOD(@selector(login:))

- (void)login:(WXModuleCallback) callBack {
    FNLoginViewController *loginVc = [[FNLoginViewController alloc] initWithComplete:^(BOOL success) {
        NSDictionary *userInfo = @{};
        if (success) {
            userInfo = @{
                         @"username": [FNUser shared].userInfo.username,
                         @"userid": [FNUser shared].userInfo.userId,
                         @"token":[FNUser shared].userInfo.token
                         };
        }
        
        NSDictionary *result = @{
                                 @"userInfo":userInfo,
                                 @"msg":success ? @"登录成功":@"登录失败",
                                 @"result": @(success)
                                 };
        callBack(result);
    }];
    
    UINavigationController *navigationVc = [[UINavigationController alloc] initWithRootViewController:loginVc];
    
    UIViewController *rootVc =((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
    
    [rootVc presentViewController:navigationVc animated:YES completion:nil];
    
}





@end
