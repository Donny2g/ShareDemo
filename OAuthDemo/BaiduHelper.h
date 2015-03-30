//
//  BaiduHelper.h
//  OAuthDemo
//
//  Created by Donny2g Hu on 15/3/30.
//  Copyright (c) 2015年 Donny2g Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Baidu.h"
#import "BaiduDelegate.h"
#import "BaiduUserSessionManager.h"


#define BDAppKey         @""
#define BDAppId          @""
#define BDToken          @"BDToken"

#define bdGetUserInfoURL @"https://openapi.baidu.com/rest/2.0/passport/users/getInfo"
#define bdPortraitPrefix @"http://himg.bdimg.com/sys/portraitn/item/"

@interface BaiduHelper : NSObject<BaiduAuthorizeDelegate,BaiduAPIRequestDelegate>
+ (BaiduHelper *) helper;
- (void) baiduLoginWithController:(UIViewController *)controller;

@property(nonatomic, retain) NSDate *bdExpirationDate;
@property(nonatomic, retain) NSString *bdToken;

@property(nonatomic, retain) Baidu *bdConnect;

@end
