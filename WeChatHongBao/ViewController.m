//
//  ViewController.m
//  WeChatHongBao
//
//  Created by 大家保 on 2017/6/2.
//  Copyright © 2017年 小魏. All rights reserved.
//

#import "ViewController.h"
#import "RedEnvelope.h"
#import "SECController.h"
#import "JCAlertView.h"
#define APP_WIDTH  [UIScreen mainScreen].bounds.size.width
#define APP_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic,strong)JCAlertView *alert;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(20, 100, 100, 50)];
    [button setTitleColor:[UIColor blackColor] forState:0];
    [button setTitle:@"弹出红包" forState:0];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button addTarget:self action:@selector(alertHongbao) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)alertHongbao{
    RedEnvelope *red=[[RedEnvelope alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH-120, (APP_WIDTH-120)*1.5)];
    [red setLookBlock:^{
        [self.alert dismissWithCompletion:^{
            SECController *sec=[[SECController alloc]init];
            sec.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:sec animated:YES];
        }];
    }];
    [red setCloseBlock:^{
        [self.alert dismissWithCompletion:nil];
    }];
    self.alert=[[JCAlertView alloc]initWithCustomView:red dismissWhenTouchedBackground:NO];
    [self.alert show];
}



@end
