//
//  ViewController.m
//  FN_iOS_Weex_Demo
//
//  Created by Mingyoung on 2019/6/6.
//  Copyright © 2019 feiniu. All rights reserved.
//

#import "ViewController.h"
#import "RootTableViewCell.h"
#import "WeexViewController.h"
//#import "WXDemoViewController.h"
#import "FNUser.h"

static NSString * _tableCellReuseIdentifier = @"RootListTableViewCell";

@interface ViewController ()

@property (nonatomic, copy) NSArray *dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"WeexDemo示例";
    
    /*
    FNUserInfo *userinfo = [FNUserInfo new];
    userinfo.userId = @"100000001";
    userinfo.username = @"我是小肥牛...嘻嘻";
    userinfo.token = @"ehiurhiurhiuwhiurhwer";
    [FNUser shared].userInfo = userinfo;
    */
}

- (NSArray *)dataArr {
    return @[
             @"首页列表",
             @"重置Appinfo信息"
             ];
}



#pragma mark tableview datasource

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = self.dataArr[indexPath.row];
    RootTableViewCell *cell = (RootTableViewCell *)[tableView dequeueReusableCellWithIdentifier:_tableCellReuseIdentifier];
    cell.titleLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            //首页列表
            NSString *url = @"http://10.200.241.130:8082/dist/index.js";
            WeexViewController *vc = [[WeexViewController alloc] initWithUrl:url];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            case 1:
        {
            [FNUser shared].userInfo = nil;

        }break;
        default:
            break;
    }
}

@end
