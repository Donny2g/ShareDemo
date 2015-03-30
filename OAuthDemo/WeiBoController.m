//
//  WeiBoController.m
//  OAuthDemo
//
//  Created by Donny2g Hu on 15/3/30.
//  Copyright (c) 2015年 Donny2g Hu. All rights reserved.
//

#import "WeiBoController.h"
#import "WeiboHelper.h"
@implementation WeiBoController


- (void)viewDidLoad
{
    //微博认证回调
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center
     addObserver:self
     selector:@selector(weiboLoginFinished)
     name:@"WeiboLoginFinished"
     object:nil];
}


- (IBAction)wbLogin:(id)sender
{
    [[WeiboHelper sharedInstance]SSOLogin];
}


- (IBAction)wblogout:(id)sender
{
    [[WeiboHelper sharedInstance]Logout];
}




- (IBAction)wbshare:(id)sender
{
    [[WeiboHelper sharedInstance]shareMessage];
}


- (void) weiboLoginFinished {
}
    

@end
