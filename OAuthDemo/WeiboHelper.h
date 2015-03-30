//
//  WeiboHelper.h
//  WeiboHelper
//
//  Created by HarveyHu on 2014/1/17.
//  Copyright (c) 2014年 HarveyHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"

typedef void(^RequestCompletion)(id result);

//微博Demo用的
//bundleID com.sina.weibo.SNWeiboSDKDemo
//#define kAppKey         @"2045436852"
//#define kRedirectURI    @"http://www.sina.com"

 


//改成自己申請的

#define kWBAppKey         @"2045436852"
#define kWBRedirectURI    @"http://www.sina.com"
#define WBToken          @"WBToken"
#define WBUserInfo       @"WBUserInfo"

#define WeiboLoginFinishedNotification @"WeiboLoginFinished"

@interface WeiboHelper : NSObject <WBHttpRequestDelegate, WeiboSDKDelegate>{
    NSDictionary* _userInfo;
}
@property (strong,nonatomic) RequestCompletion requestCompletion;
@property(nonatomic, retain) NSString *userID;
@property (retain,nonatomic) NSString *userName;
@property (retain,nonatomic) NSString *userGender;
@property(nonatomic, retain) NSString *protraitURL;
@property(nonatomic, retain) NSString *token;
@property(nonatomic, retain) NSDate *expirationDate;

//singleton
+(instancetype) sharedInstance;

//login <-> logout
//认证成功后接收WeiboLoginFinished回调通知

-(void)SSOLogin;
-(void)Logout;

- (void)shareMessage;
//token
-(void)setWBToken:(NSString*)wbtoken;
-(NSString*)getWBToken;

//getUserInfo
-(void)getUserInfoWithCompletion:(RequestCompletion)completion;



@end
