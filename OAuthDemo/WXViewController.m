//
//  WXViewController.m
//  OAuthDemo
//
//  Created by Donny2g Hu on 15/3/30.
//  Copyright (c) 2015年 Donny2g Hu. All rights reserved.
//

#import "WXViewController.h"
#import "WeixinHelper.h"
@interface WXViewController ()

@end

@implementation WXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)shareTextToFriend:(id)sender
{
    [[WeixinHelper helper]shareTextContent:@"这是一段文字" scence:WXSceneSession];
}


- (IBAction)shareImageToFriend:(id)sender
{
    [[WeixinHelper helper]shareImageContent:[UIImage imageNamed:@"image_1.jpg"] ext:@"附加文字" scence:WXSceneSession];
}


- (IBAction)shareLinkToFriend:(id)sender
{
    [[WeixinHelper helper]shareLinkContent:@"标题" description:@"描述" image:[UIImage imageNamed:@"image_1.jpg"] url:@"http://www.baidu.com" scene:WXSceneSession];
}

- (IBAction)shareTextToTimeline:(id)sender
{
    [[WeixinHelper helper]shareTextContent:@"这是一段文字" scence:WXSceneTimeline];

}


- (IBAction)shareImageToTimeline:(id)sender
{
    [[WeixinHelper helper]shareImageContent:[UIImage imageNamed:@"image_1.jpg"] ext:@"附加文字" scence:WXSceneTimeline];

}


- (IBAction)shareLinkToTimeline:(id)sender
{
    [[WeixinHelper helper]shareLinkContent:@"标题" description:@"描述" image:[UIImage imageNamed:@"image_1.jpg"] url:@"http://www.baidu.com" scene:WXSceneTimeline];

}


- (IBAction)wxlogin:(id)sender
{
    [[WeixinHelper helper]ssoLoginWithController:self];
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
