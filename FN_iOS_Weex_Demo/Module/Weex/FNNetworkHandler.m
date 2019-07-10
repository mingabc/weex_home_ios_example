//
//  FNNetworkHandler.m
//  FN_iOS_Weex_Demo
//
//  Created by Mingyoung on 2019/6/15.
//  Copyright © 2019 feiniu. All rights reserved.
//

#import "FNNetworkHandler.h"
#import "FNThreadSafeDictionary.h"

@interface FNNetworkHandler ()<NSURLSessionDelegate>

@end

@implementation FNNetworkHandler
{
    NSURLSession *_session;
    FNThreadSafeDictionary<NSURLSessionDataTask *, id<WXResourceRequestDelegate>> *_delegates;
}

#pragma mark - WXResourceRequestHandler

- (void)sendRequest:(WXResourceRequest *)request withDelegate:(id<WXResourceRequestDelegate>)delegate
{
    if (!_session) {
        NSURLSessionConfiguration *urlSessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        if ([WXAppConfiguration customizeProtocolClasses].count > 0) {
            NSArray *defaultProtocols = urlSessionConfig.protocolClasses;
            urlSessionConfig.protocolClasses = [[WXAppConfiguration customizeProtocolClasses] arrayByAddingObjectsFromArray:defaultProtocols];
        }
        _session = [NSURLSession sessionWithConfiguration:urlSessionConfig
                                                 delegate:self
                                            delegateQueue:[NSOperationQueue mainQueue]];
        _delegates = [FNThreadSafeDictionary new];
    }
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request];
    request.taskIdentifier = task;
    [_delegates setObject:delegate forKey:task];
    [task resume];
}

- (void)cancelRequest:(WXResourceRequest *)request
{
    if ([request.taskIdentifier isKindOfClass:[NSURLSessionTask class]]) {
        NSURLSessionTask *task = (NSURLSessionTask *)request.taskIdentifier;
        [task cancel];
        [_delegates removeObjectForKey:task];
    }
}

#pragma mark - NSURLSessionTaskDelegate & NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust && challenge.protectionSpace.serverTrust != nil) {
        NSURLCredential *card = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, card);
    }else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    id<WXResourceRequestDelegate> delegate = [_delegates objectForKey:task];
    [delegate request:(WXResourceRequest *)task.originalRequest didSendData:bytesSent totalBytesToBeSent:totalBytesExpectedToSend];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)task
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    id<WXResourceRequestDelegate> delegate = [_delegates objectForKey:task];
    [delegate request:(WXResourceRequest *)task.originalRequest didReceiveResponse:(WXResourceResponse *)response];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)task didReceiveData:(NSData *)data
{
    id<WXResourceRequestDelegate> delegate = [_delegates objectForKey:task];
    [delegate request:(WXResourceRequest *)task.originalRequest didReceiveData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    id<WXResourceRequestDelegate> delegate = [_delegates objectForKey:task];
    if (error) {
        [delegate request:(WXResourceRequest *)task.originalRequest didFailWithError:error];
    }else {
        [delegate requestDidFinishLoading:(WXResourceRequest *)task.originalRequest];
    }
    [_delegates removeObjectForKey:task];
}

#ifdef __IPHONE_10_0
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics
API_AVAILABLE(ios(10.0)){
    id<WXResourceRequestDelegate> delegate = [_delegates objectForKey:task];
    if (@available(iOS 10.0, *)) {
        [delegate request:(WXResourceRequest *)task.originalRequest didFinishCollectingMetrics:metrics];
    } else {
        // Fallback on earlier versions
    }
}
#endif
@end

