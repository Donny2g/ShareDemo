//
//  WeixinHelper.h
//  OAuthDemo
//
//  Created by Donny2g Hu on 15/3/30.
//  Copyright (c) 2015年 Donny2g Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import <UIKit/UIKit.h>

//微信登录需要填写AppSecret
#define kWXAppKey         @"wxd930ea5d5a258f4f"
#define kWXAppSecret      @""

@interface WeixinHelper : NSObject<WXApiDelegate>
{
  
}

@property (nonatomic ,strong) NSString *wxCode;
@property (nonatomic ,strong) NSString *access_token;
@property (nonatomic ,strong) NSString *openid;

+ (WeixinHelper *) helper;

- (void)shareTextContent:(NSString *)text scence:(enum WXScene) scene;

- (void)shareImageContent:(UIImage *)image ext:(NSString *)messageExt scence:(enum WXScene) scene;

- (void)shareLinkContent:(NSString *)title description:(NSString *)description
                   image:(UIImage *)image url:(NSString *)url scene:(enum WXScene) scene;


- (void)ssoLoginWithController:(UIViewController *)controller;


@end