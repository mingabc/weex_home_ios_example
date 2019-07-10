//
//  FNThreadSafeDictionary.m
//  FN_iOS_Weex_Demo
//
//  Created by Mingyoung on 2019/6/15.
//  Copyright © 2019 feiniu. All rights reserved.
//

#import "FNThreadSafeDictionary.h"
#import "WXUtility.h"
#import <pthread/pthread.h>
#import <os/lock.h>

@interface FNThreadSafeDictionary ()
{
    pthread_mutex_t _safeThreadDictionaryMutex;
    pthread_mutexattr_t _safeThreadDictionaryMutexAttr;
}

@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) NSMutableDictionary* dict;

@end

#define OVERRIDE_METHOD(method,retValue) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if (![WXUtility threadSafeCollectionUsingLock]) {\
dispatch_sync(_queue, ^{\
if ([_dict respondsToSelector:method]) {\
retValue = [_dict performSelector:method];\
}\
});\
} else {\
pthread_mutex_lock(&_safeThreadDictionaryMutex);\
if ([_dict respondsToSelector:method]) {\
retValue = [_dict performSelector:method];\
}\
pthread_mutex_unlock(&_safeThreadDictionaryMutex);\
}\
_Pragma("clang diagnostic pop")\
} while (0)

@implementation FNThreadSafeDictionary

- (instancetype)initCommon
{
    self = [super init];
    if (self) {
        NSString* uuid = [NSString stringWithFormat:@"com.feiniu.weex.dictionary_%p", self];
        _queue = dispatch_queue_create([uuid UTF8String], DISPATCH_QUEUE_CONCURRENT);
        pthread_mutexattr_init(&(_safeThreadDictionaryMutexAttr));
        pthread_mutexattr_settype(&(_safeThreadDictionaryMutexAttr), PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init(&(_safeThreadDictionaryMutex), &(_safeThreadDictionaryMutexAttr));
    }
    return self;
}

- (instancetype)init
{
    self = [self initCommon];
    if (self) {
        _dict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems
{
    self = [self initCommon];
    if (self) {
        _dict = [NSMutableDictionary dictionaryWithCapacity:numItems];
    }
    return self;
}

- (NSDictionary *)initWithContentsOfFile:(NSString *)path
{
    self = [self initCommon];
    if (self) {
        _dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self initCommon];
    if (self) {
        _dict = [[NSMutableDictionary alloc] initWithCoder:aDecoder];
    }
    return self;
}

- (instancetype)initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt
{
    self = [self initCommon];
    if (self) {
        _dict = [NSMutableDictionary dictionary];
        for (NSUInteger i = 0; i < cnt; ++i) {
            _dict[keys[i]] = objects[i];
        }
        
    }
    return self;
}

- (NSUInteger)count
{
    __block NSUInteger count;
    if (![WXUtility threadSafeCollectionUsingLock]) {
        dispatch_sync(_queue, ^{
            count = _dict.count;
        });
    } else {
        pthread_mutex_lock(&_safeThreadDictionaryMutex);
        count = [_dict count];
        pthread_mutex_unlock(&_safeThreadDictionaryMutex);
    }
    return count;
}

- (id)objectForKey:(id)aKey
{
    if (nil == aKey){
        return nil;
    }
    __block id obj;
    if (![WXUtility threadSafeCollectionUsingLock]) {
        dispatch_sync(_queue, ^{
            obj = _dict[aKey];
        });
    } else {
        pthread_mutex_lock(&_safeThreadDictionaryMutex);
        obj = _dict[aKey];
        pthread_mutex_unlock(&_safeThreadDictionaryMutex);
    }
    return obj;
}

- (NSEnumerator *)keyEnumerator
{
    __block NSEnumerator *enu;
    if (![WXUtility threadSafeCollectionUsingLock]) {
        dispatch_sync(_queue, ^{
            enu = [_dict keyEnumerator];
        });
    } else {
        pthread_mutex_lock(&_safeThreadDictionaryMutex);
        enu = [_dict keyEnumerator];
        pthread_mutex_unlock(&_safeThreadDictionaryMutex);
    }
    return enu;
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    aKey = [aKey copyWithZone:NULL];
    if (![WXUtility threadSafeCollectionUsingLock]) {
        dispatch_barrier_async(_queue, ^{
            _dict[aKey] = anObject;
        });
    } else {
        pthread_mutex_lock(&_safeThreadDictionaryMutex);
        _dict[aKey] = anObject;
        pthread_mutex_unlock(&_safeThreadDictionaryMutex);
    }
}

- (NSArray *)allKeys
{
    __block NSArray *allKeys = nil;
    OVERRIDE_METHOD(_cmd, allKeys);
    return allKeys;
}

- (NSArray *)allValues
{
    __block NSArray *allValues = nil;
    OVERRIDE_METHOD(_cmd, allValues);
    return allValues;
}

- (void)removeObjectForKey:(id)aKey
{
    if (![WXUtility threadSafeCollectionUsingLock]) {
        dispatch_barrier_async(_queue, ^{
            [self->_dict removeObjectForKey:aKey];
        });
    } else {
        pthread_mutex_lock(&_safeThreadDictionaryMutex);
        [_dict removeObjectForKey:aKey];
        pthread_mutex_unlock(&_safeThreadDictionaryMutex);
    }
}

- (void)removeAllObjects
{
    if (![WXUtility threadSafeCollectionUsingLock]) {
        dispatch_barrier_async(_queue, ^{
            [self->_dict removeAllObjects];
        });
    }else {
        pthread_mutex_lock(&_safeThreadDictionaryMutex);
        [_dict removeAllObjects];
        pthread_mutex_unlock(&_safeThreadDictionaryMutex);
    }
}

- (id)copy{
    __block id copyInstance;
    if (![WXUtility threadSafeCollectionUsingLock]) {
        dispatch_sync(_queue, ^{
            copyInstance = [self->_dict copy];
        });
    } else {
        pthread_mutex_lock(&_safeThreadDictionaryMutex);
        copyInstance = [_dict copy];
        pthread_mutex_unlock(&_safeThreadDictionaryMutex);
    }
    
    return copyInstance;
}

- (void)dealloc
{
    pthread_mutex_destroy(&_safeThreadDictionaryMutex);
    pthread_mutexattr_destroy(&_safeThreadDictionaryMutexAttr);
}

@end
