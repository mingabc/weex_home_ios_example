//
//  FNThreadSafeDictionary.h
//  FN_iOS_Weex_Demo
//
//  Created by Mingyoung on 2019/6/15.
//  Copyright © 2019 feiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  @abstract Thread safe NSMutableDictionary
 */
@interface FNThreadSafeDictionary<KeyType, ObjectType> : NSMutableDictionary

@end

NS_ASSUME_NONNULL_END
