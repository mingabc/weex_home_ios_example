//
//  FNCustomComponent.m
//  FN_iOS_Weex_Demo
//
//  Created by Mingyoung on 2019/6/10.
//  Copyright © 2019 feiniu. All rights reserved.
//

#import "FNCustomComponent.h"
#import "FNCustomView.h"

@interface FNCustomComponent ()

@property (nonatomic, weak) FNCustomView *customeView;

@end

@implementation FNCustomComponent

- (UIView *)loadView {
    FNCustomView *customeView = [FNCustomView new];
    customeView.titleLabel.frame = CGRectMake(0, 0, 300, 44);
    return customeView;
}

- (void)viewWillLoad {
    [super viewWillLoad];
    
//    NSLog(@"**** custom viewWillLoad ");
}

-(void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"**** custom viewDidLoad %@ \n %@ \n %@", NSStringFromCGRect(self.calculatedFrame), NSStringFromCGRect(self.customeView.frame), NSStringFromCGRect(self.customeView.titleLabel.frame));
    self.customeView.titleLabel.frame = CGRectMake(0, 0, 200, 44);
    [self.customeView layoutIfNeeded];
    
//        NSLog(@"**** \n %@ \n %@", NSStringFromCGRect(self.customeView.frame), NSStringFromCGRect(self.customeView.titleLabel.frame));
    
}

- (void)viewWillUnload {
    [super viewWillUnload];
//    NSLog(@"**** custom viewWillUnload ");
}

- (void)viewDidUnload {
    [super viewDidUnload];
//    NSLog(@"**** custom viewDidUnload ");
}




@end
