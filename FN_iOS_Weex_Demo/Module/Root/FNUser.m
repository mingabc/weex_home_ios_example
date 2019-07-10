//
//  FNUser.m
//  FN_iOS_Weex_Demo
//
//  Created by Mingyoung on 2019/6/18.
//  Copyright © 2019 feiniu. All rights reserved.
//

#import "FNUser.h"

@implementation FNUser

+ (FNUser *)shared {
    static FNUser *_shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[FNUser alloc] init];
    });
    return _shareInstance;
}

@end
