//
//  QQViewController.m
//  OAuthDemo
//
//  Created by Donny2g Hu on 15/3/30.
//  Copyright (c) 2015年 Donny2g Hu. All rights reserved.
//

#import "QQViewController.h"
#import "QQHelper.h"

@interface QQViewController ()
{
    BOOL _isLogined;

}
@end

@implementation QQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessed) name:kLoginSuccessed object:[QQHelper helper]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed) name:kLoginFailed object:[QQHelper helper]];
    
}


- (IBAction)qqlogin:(id)sender
{
    [[QQHelper helper]qqlogin];
}

- (IBAction)shareTextToQQ:(id)sender
{
    [[QQHelper helper]shareTextMessage:@"分析文字" type: TencentShareQQ];
}


- (IBAction)shareImageToQQ:(id)sender
{
    [[QQHelper helper]shareImageMessage:@"标题" description:@"描述" image:[UIImage imageNamed:@"image_1.jpg"] type:TencentShareQQ];
}


- (IBAction)shareLinkToQQ:(id)sender
{
    [[QQHelper helper]shareLinkMessagetitle:@"表态" description:@"描述" image:[UIImage imageNamed:@"image_1.jpg"] url:@"http://www.baidu.com" type:TencentShareQQ];
}
#pragma mark message
- (void)loginSuccessed
{
    if (NO == _isLogined)
    {
        _isLogined = YES;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"结果" message:@"登录成功" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
    
}

- (void)loginFailed
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"结果" message:@"登录失败" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
