//
//  BaiduHelper.m
//  OAuthDemo
//
//  Created by Donny2g Hu on 15/3/30.
//  Copyright (c) 2015年 Donny2g Hu. All rights reserved.
//

#import "BaiduHelper.h"

@implementation BaiduHelper


static BaiduHelper *_gWeixinHelper = nil;

+ (BaiduHelper *) helper
{
    if(!_gWeixinHelper) {
        _gWeixinHelper = [[BaiduHelper alloc] init];
    }
    return _gWeixinHelper;
}

- (id) init
{
    self = [super init];
    if(self) {
        [self initBaiduOauth];
    }
    return self;
}



- (void) initBaiduOauth {
    self.bdConnect = nil;
    self.bdConnect = [[Baidu alloc] initWithAPIKey:BDAppKey appId:BDAppId];
}

- (void) baiduLoginWithController:(UIViewController *)controller {
    [self initBaiduOauth];
    [self.bdConnect authorizeWithTargetViewController:controller scope:@"basic,super_msg,netdisk" andDelegate:self];

}

/*
 * 授权成功
 */
- (void)loginDidSuccess
{
    /*UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"授权提示" message:@"授权成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
     [alertView show];*/
    
    [self alreadyLogin];
}

- (void)bdLogout
{
    if (self.bdConnect != nil) {
         [self.bdConnect currentUserLogout];
    }
}

- (void)alreadyLogin
{
    self.bdToken = [BaiduUserSessionManager shareUserSessionManager].currentUserSession.accessToken;
    self.bdExpirationDate = [BaiduUserSessionManager shareUserSessionManager].currentUserSession.expiresIn;
    [self saveBDToken:self.bdToken];
    [self.bdConnect apiRequestWithUrl:bdGetUserInfoURL httpMethod:@"GET" params:nil andDelegate:self];
    //NSLog(@"bdtoken: %@", self.bdToken);
}



/*
 * 取消授权
 */
- (void)loginDidCancel
{
    
}

/*
 * 授权发生错误
 */
- (void)loginFailedWithError:(NSError*)error
{
    
}


/*
 * API请求的代理
 */


/*
 * API请求成功并返回请求结果
 */
- (void)apiRequestDidFinishLoadWithResult:(id)result
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:[result description] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

/*
 * API请求发生错误
 */
- (void)apiRequestDidFailLoadWithError:(NSError*)error
{
    
}

-(void)saveBDToken:(NSString*)bdtoken{
    //[[NSUserDefaults standardUserDefaults] setObject:wbtoken forKey:kToken];
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        [standardUserDefaults setObject:bdtoken forKey:BDToken];
        [standardUserDefaults synchronize];
    }
}
@end
