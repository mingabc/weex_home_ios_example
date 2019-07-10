//
//  FNUser.h
//  FN_iOS_Weex_Demo
//
//  Created by Mingyoung on 2019/6/18.
//  Copyright © 2019 feiniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNUserInfo.h"


@interface FNUser : NSObject


@property (nonatomic,strong) FNUserInfo *userInfo;


+ (FNUser *)shared;

@end


