//
//  FNLoginViewController.h
//  FN_iOS_Weex_Demo
//
//  Created by Mingyoung on 2019/6/10.
//  Copyright © 2019 feiniu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 login
 */
@interface FNLoginViewController : UIViewController

- (instancetype)initWithComplete:(void(^)(BOOL success))loginComplete;

@end

NS_ASSUME_NONNULL_END
