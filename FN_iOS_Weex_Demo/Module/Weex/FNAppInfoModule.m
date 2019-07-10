//
//  FNAppInfoModule.m
//  FN_iOS_Weex_Demo
//
//  Created by Mingyoung on 2019/6/18.
//  Copyright © 2019 feiniu. All rights reserved.
//

#import "FNAppInfoModule.h"
#import "FNUser.h"

@implementation FNAppInfoModule
WX_EXPORT_METHOD(@selector(userInfo:))

- (void)userInfo:(WXModuleCallback)callBack {
    
    if ([FNUser shared].userInfo == nil) {
        callBack(@{});
    }else {
        NSDictionary *info = @{
                               @"username": [FNUser shared].userInfo.username,
                               @"userid": [FNUser shared].userInfo.userId,
                               @"token":[FNUser shared].userInfo.token
                               };
        callBack(info);
    }
    
    
}

@end
