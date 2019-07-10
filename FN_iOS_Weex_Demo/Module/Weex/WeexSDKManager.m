//
//  WeexSDKManager.m
//  WeexDemo
//
//  Created by yangshengtao on 16/11/14.
//  Copyright © 2016年 taobao. All rights reserved.
//

#import "WeexSDKManager.h"
#import "DemoDefine.h"
#import <WeexSDK/WeexSDK.h>
#import "WXImgLoaderDefaultImpl.h"
#import "FNLoginModule.h"
#import "FNCustomComponent.h"
#import "FNNetworkHandler.h"
#import "FNAppInfoModule.h"
#import "FNRouteModule.h"

@implementation WeexSDKManager

+ (void)setup;
{
    [self initWeexSDK];
}

+ (void)initWeexSDK
{
    [WXAppConfiguration setAppGroup:@"feiniu"];
    [WXAppConfiguration setAppName:@"FNWeexDemo"];
    [WXAppConfiguration setAppVersion:@"1.0.0"];
//    [WXAppConfiguration setExternalUserAgent:@"youxian"];
    
    [WXSDKEngine initSDKEnvironment];
    
    [WXSDKEngine registerHandler:[FNNetworkHandler new] withProtocol:@protocol(WXResourceRequestHandler)];
    [WXSDKEngine registerHandler:[WXImgLoaderDefaultImpl new] withProtocol:@protocol(WXImgLoaderProtocol)];
    [WXSDKEngine registerModule:@"login" withClass:[FNLoginModule class]];
    [WXSDKEngine registerModule:@"appInfo" withClass:[FNAppInfoModule class]];
    [WXSDKEngine registerComponent:@"customview" withClass:[FNCustomComponent class]];
    [WXSDKEngine registerModule:@"route" withClass:[FNRouteModule class]];
#ifdef DEBUG
    [WXLog setLogLevel:WXLogLevelLog];
#endif
}

@end
