//
//  QQHelper.h
//  OAuthDemo
//
//  Created by Donny2g Hu on 15/3/30.
//  Copyright (c) 2015年 Donny2g Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sdkDef.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>


#define kQQAppKey @"222222"
enum TencentShareType {
    TencentShareQQ = 0,
    TencentShareQQZone
};


@interface QQHelper : NSObject<TencentSessionDelegate, TencentApiInterfaceDelegate, TCAPIRequestDelegate>


+ (QQHelper *) helper;

- (void)qqlogin;

- (void)shareTextMessage:(NSString *)text type:(enum TencentShareType)type;

- (void)shareImageMessage:(NSString *)title description:(NSString *)description image:(UIImage *)image  type:(enum TencentShareType)type;

- (void)shareLinkMessagetitle:(NSString *)title description:(NSString *)description image:(UIImage *)image  url:(NSString *)url type:(enum TencentShareType)type;
@end
