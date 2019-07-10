//
//  WeexViewController.m
//  FN_iOS_Weex_Demo
//
//  Created by Mingyoung on 2019/6/6.
//  Copyright © 2019 feiniu. All rights reserved.
//

#import "WeexViewController.h"
#import <WeexSDK/WXSDKInstance.h>
#import <WeexSDK/WXSDKEngine.h>
#import <WeexSDK/WXUtility.h>
#import <WeexSDK/WXDebugTool.h>
#import <WeexSDK/WXSDKManager.h>

@interface WeexViewController ()

@property (nonatomic, strong) WXSDKInstance *instance;
@property (nonatomic, strong) UIView *weexView;

@property (nonatomic, assign) CGFloat weexHeight;

@property (nonatomic,copy) NSString *url;
@end

@implementation WeexViewController

- (instancetype)initWithUrl:(NSString *)url {
    if (self = [super init]) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _weexHeight = self.view.frame.size.height - 64 - 44 - 49-100;
    
    [self render];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self canBecomeFirstResponder])
    {
        [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
        [self becomeFirstResponder];
    }
    [self updateInstanceState:WeexInstanceAppear];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self updateInstanceState:WeexInstanceDisappear];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _weexHeight = self.view.frame.size.height - 64;
    UIEdgeInsets safeArea = UIEdgeInsetsZero;
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        safeArea = self.view.safeAreaInsets;
    } else {
        // Fallback on earlier versions
    }
#endif
    _instance.frame = CGRectMake(safeArea.left, safeArea.top, self.view.frame.size.width-safeArea.left-safeArea.right, _weexHeight-safeArea.bottom);
}

- (void)dealloc {
    [_instance destroyInstance];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)render
{
    CGFloat width = self.view.frame.size.width;
    [_instance destroyInstance];
    _instance = [[WXSDKInstance alloc] init];
    _instance.viewController = self;
    _instance.frame = CGRectMake(self.view.frame.size.width-width, 0, width, _weexHeight);
    __weak typeof(self) weakSelf = self;
    _instance.onCreate = ^(UIView *view) {
        [weakSelf.weexView removeFromSuperview];
        weakSelf.weexView = view;
        [weakSelf.view addSubview:weakSelf.weexView];
    };
    _instance.onFailed = ^(NSError *error) {
        //渲染失败，降级进入h5页面
    };
    
    _instance.renderFinish = ^(UIView *view) {
        WXLogDebug(@"%@", @"Render Finish...");
        [weakSelf updateInstanceState:WeexInstanceAppear];
    };
    
    _instance.updateFinish = ^(UIView *view) {
        WXLogDebug(@"%@", @"Update Finish...");
    };
    
    NSString *url = self.url;
    NSURL *URL = [NSURL URLWithString:url];
    [_instance renderWithURL:URL options:@{@"bundleUrl":URL.absoluteString} data:nil];
    
    
    
//    if (!self.url) {
//        WXLogError(@"error: render url is nil");
//        return;
//    }
//    NSURL *URL = [NSURL URLWithString:@"http://10.200.244.100:8081/dist/index.js"];//[self testURL: [self.url absoluteString]];
    
//    NSString *url = @"http://10.200.241.130:8084/dist/index.js";
//     NSURL *URL = [NSURL URLWithString:url];
////    NSString *randomURL = [NSString stringWithFormat:@"%@%@random=%d",URL.absoluteString,URL.query?@"&":@"?",arc4random()];
//    [_instance renderWithURL:URL options:@{@"bundleUrl":URL.absoluteString} data:nil];
}

- (void)updateInstanceState:(WXState)state
{
    if (_instance && _instance.state != state) {
        _instance.state = state;
        
        if (state == WeexInstanceAppear) {
            [[WXSDKManager bridgeMgr] fireEvent:_instance.instanceId ref:WX_SDK_ROOT_REF type:@"viewappear" params:nil domChanges:nil];
        }
        else if (state == WeexInstanceDisappear) {
            [[WXSDKManager bridgeMgr] fireEvent:_instance.instanceId ref:WX_SDK_ROOT_REF type:@"viewdisappear" params:nil domChanges:nil];
        }
    }
}


@end
