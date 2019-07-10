//
//  FNRouteModule.m
//  FN_iOS_Weex_Demo
//
//  Created by Mingyoung on 2019/6/19.
//  Copyright © 2019 feiniu. All rights reserved.
//

#import "FNRouteModule.h"
#import "FNWebViewController.h"
#import "AppDelegate.h"
#import "FNLoginViewController.h"
#import "FNWebViewController.h"
#import "FNUser.h"

@implementation FNRouteModule

WX_EXPORT_METHOD(@selector(jump:callBack:))


/*
 * url支持  fn://login   http://webview
 *
 * callBack-
 *  result { code: 0, message: '', data: id }
 **/
- (void)jump:(NSString *)url callBack:(WXModuleCallback)callBack {
    //跳转
    NSURL *URL = [NSURL URLWithString:url];
    if (!URL) {
        [self failureUnsafeUrlJump:callBack];
        return;
    }
    
    if ([URL.scheme isEqualToString:@"fn"]) {
        //进入native页面
        if ([URL.host isEqualToString:@"login"]) {
            [self pushLoginVcWithCallBack:callBack];
        }else {
              [self failureUnsupportUrlJump:callBack];
        }
    }else if([URL.scheme isEqualToString:@"http"] || [URL.scheme isEqualToString:@"https"]){
        //进入webview页面
        [self pushWebViewVcWithUrl:url];
    }else {
        [self failureUnsupportUrlJump:callBack];
    }
    
}

//不支持url
- (void)failureUnsupportUrlJump:(WXModuleCallback)callBack {
    NSDictionary *dic = @{
                          @"code": @(1002),
                          @"message": @"url不支持"
                          };
    callBack(dic);
}
//不合法url处理
- (void)failureUnsafeUrlJump:(WXModuleCallback)callBack {
    NSDictionary *dic = @{
                          @"code": @(1001),
                          @"message": @"url不合法"
                          };
    callBack(dic);
}

- (UINavigationController *)rootVc {
     return (UINavigationController *)((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
}

//进入webVc
- (void)pushWebViewVcWithUrl:(NSString *)url {
    FNWebViewController *webVc = [[FNWebViewController alloc] initWithUrl:url];
    [[self rootVc] pushViewController:webVc animated:YES];
}

//跳转登录
- (void)pushLoginVcWithCallBack:(WXModuleCallback) callBack {
    FNLoginViewController *loginVc = [[FNLoginViewController alloc] initWithComplete:^(BOOL success) {
        NSDictionary *userInfo = @{};
        NSNumber *code = @(1002);
        if (success) {
            userInfo = @{
                         @"username": [FNUser shared].userInfo.username,
                         @"userid": [FNUser shared].userInfo.userId,
                         @"token":[FNUser shared].userInfo.token
                         };
            code = @(0);
        }
        
        NSDictionary *result = @{
                                 @"data":userInfo,
                                 @"message":success ? @"登录成功":@"登录失败",
                                 @"code": code
                                 };
        callBack(result);
    }];
    
    UINavigationController *navigationVc = [[UINavigationController alloc] initWithRootViewController:loginVc];
    
    UIViewController *rootVc = [self rootVc];
    
    [rootVc presentViewController:navigationVc animated:YES completion:nil];
    
    
}

@end
