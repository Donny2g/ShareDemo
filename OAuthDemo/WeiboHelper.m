//
//  WeiboHelper.m
//  WeiboHelper
//
//  Created by HarveyHu on 2014/1/17.
//  Copyright (c) 2014年 HarveyHu. All rights reserved.
//

#import "WeiboHelper.h"

@implementation WeiboHelper
#pragma mark- singleton
+(instancetype) sharedInstance {
    static dispatch_once_t pred;
    static WeiboHelper *instance = nil;
    dispatch_once(&pred, ^{instance = [[self alloc] initSingleton];});
    return instance;
}
- (id)init {
    return nil;
}
- (id)initSingleton {
    
    self = [super init];
    if ((self = [super init])) {
        //TODO: ...
    }
    
    return self;
}

#pragma mark- login
- (void)SSOLogin
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kWBRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (void)Logout
{
    [WeiboSDK logOutWithToken:[self getWBToken] delegate:self withTag:@"user1"];
}


- (void)shareMessage
{
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kWBRedirectURI;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request =
    [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
}

//图片消息与多媒体不能共享
- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    message.text = NSLocalizedString(@"测试通过WeiboSDK发送文字到微博!", nil);

    WBImageObject *image = [WBImageObject object];
    image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_1" ofType:@"jpg"]];
    message.imageObject = image;

    
//    WBWebpageObject *webpage = [WBWebpageObject object];
//    webpage.objectID = @"identifier1";
//    webpage.title = NSLocalizedString(@"分享网页标题", nil);
//    webpage.description = [NSString stringWithFormat:NSLocalizedString(@"分享网页内容简介-%.0f", nil), [[NSDate date] timeIntervalSince1970]];
//    webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_2" ofType:@"jpg"]];
//    webpage.webpageUrl = @"http://sina.cn?a=1";
    
//    message.mediaObject = webpage;
    
    return message;
}



#pragma mark- token
-(void)setWBToken:(NSString*)wbtoken{
    //[[NSUserDefaults standardUserDefaults] setObject:wbtoken forKey:kToken];
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        [standardUserDefaults setObject:wbtoken forKey:WBToken];
        [standardUserDefaults synchronize];
    }
}

-(NSString*)getWBToken{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:WBToken]) {
        return nil;
    }
    return [[NSUserDefaults standardUserDefaults] stringForKey:WBToken];
}

#pragma mark- userInfo
-(void)_setUserInfo:(NSDictionary*)userInfo{
    
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:WBUserInfo];
}

-(void)getUserInfoWithCompletion:(RequestCompletion)completion{
    if (![[NSUserDefaults standardUserDefaults] dictionaryForKey:WBUserInfo]) {
        return;
    }
    self.requestCompletion = completion;
    NSDictionary* userInfo =[[NSUserDefaults standardUserDefaults] dictionaryForKey:WBUserInfo];
    NSString* url = @"https://api.weibo.com/2/users/show.json";
    
    //測試用(官方帳號)
//    NSDictionary* params = @{@"access_token": @"2.00zBrJ2EjQ8zzC15a429a8ff2pybUD",
//                             @"source": @"2045436852",
//                             @"uid": @"1904178193"};
    
    
    NSDictionary* params = @{@"access_token": [userInfo objectForKey:@"access_token"],
                             @"source": kWBAppKey,
                             @"uid": [userInfo objectForKey:@"uid"]};
    
    [WBHttpRequest requestWithAccessToken:[self getWBToken] url:url httpMethod:@"GET" params:params delegate:self withTag:@"user"];
}


#pragma mark- WeiboSDKDelegate
//微博App來跟我們寫的App要資料，會觸發這裡，你可以透過[WeiboSDK sendResponse:]回傳資料回去
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
    {
        //ProvideMessageForWeiboViewController *controller = [[[ProvideMessageForWeiboViewController alloc] init] autorelease];
        //[self.viewController presentModalViewController:controller animated:YES];
        NSLog(@"收到來自微博App的請求");
    }
}
//這裡是用來接，微博App收到我們的請求的所發出的callback
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        /*NSString *title = @"发送结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];*/
 
        
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess)
        {
        
            
 
        }else if (response.statusCode == WeiboSDKResponseStatusCodeUserCancel)
        {
            
        }else if (response.statusCode == WeiboSDKResponseStatusCodeSentFail)
        {
 
 
        }else if (response.statusCode == WeiboSDKResponseStatusCodeAuthDeny)
        {
 
 
        }else
        {
 
        }
        NSString *mes = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
        NSLog(@"发送结果: %@", mes);
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        /*NSString *title = @"认证结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\nresponse.userId: %@\nresponse.accessToken: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];*/
        
        NSString *mes = [NSString stringWithFormat:@"响应状态: %d\nresponse.userId: %@\nresponse.accessToken: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], response.userInfo, response.requestUserInfo];
        NSLog(@"认证结果: %@", mes);
        
        //存入token
        [self setWBToken:[(WBAuthorizeResponse *)response accessToken]];
        self.token = [(WBAuthorizeResponse *)response accessToken];
        self.expirationDate = [(WBAuthorizeResponse *)response expirationDate];
        
        //存入userInfo
        [self _setUserInfo:response.userInfo];
        NSLog(@"userInfo:%@",response.userInfo);
        
        [[WeiboHelper sharedInstance] getUserInfoWithCompletion:^(id result) {
            /*NSString *title = @"User Information";
            NSString *message = [NSString stringWithFormat:@"名稱: %@\n生日: %@\n性別: %@\nuid: %@\n所在地: %@\n帳號建立時間:%@",[result objectForKey:@"screen_name"], [result objectForKey:@"avatar_large"], [result objectForKey:@"gender"], [result objectForKey:@"idstr"], [result objectForKey:@"location"], [result objectForKey:@"created_at"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];*/
            self.userID = [result objectForKey:@"idstr"];
            self.userName = [result objectForKey:@"screen_name"];
            self.userGender = [result objectForKey:@"gender"];
            self.protraitURL = [result objectForKey:@"avatar_large"];
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:WeiboLoginFinishedNotification
                            object:nil];
        }];
        
    }
    NSLog(@"收到來自微博App的回應");
}

//當你用這個方法去呼叫時[WBHttpRequest requestWithAccessToken:...]，就會call back回下面的Delegate
#pragma mark- WBHttpRequestDelegate
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //UITextField *textField=[alertView textFieldAtIndex:0];
    //NSString *jsonData = @"{\"text\": \"新浪新闻是新浪网官方出品的新闻客户端，用户可以第一时间获取新浪网提供的高品质的全球资讯新闻，随时随地享受专业的资讯服务，加入一起吧\",\"url\": \"http://app.sina.com.cn/appdetail.php?appID=84475\",\"invite_logo\":\"http://sinastorage.com/appimage/iconapk/1b/75/76a9bb371f7848d2a7270b1c6fcf751b.png\"}";
    
    //[WeiboSDK inviteFriend:jsonData withUid:(NSString*)[alertView textFieldAtIndex:0] withToken:[self getWBToken] delegate:self withTag:@"invite1"];
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    /*NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = @"收到网络回调";
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",result]
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil];
    [alert show];*/
    
    NSLog(@"收到网络回调: %@", result);
    
    if (self.requestCompletion) {
        self.requestCompletion([self _JSONParser:result]);
        self.requestCompletion = nil;
    }
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
{
    /*NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = @"请求异常";
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",error]
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil];
    [alert show];*/
    NSLog(@"请求异常: %@", error);
}

-(id)_JSONParser:(NSString*)JSONString{
    
    NSData* jsonData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error = nil;
    NSArray* jsonArray = nil;
    NSDictionary* jsonDictionary = nil;
    if (jsonData) {
        id _jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if ([_jsonObject isKindOfClass:[NSDictionary class]]) {
            jsonDictionary = (NSDictionary*)_jsonObject;
            NSLog(@"%@",jsonDictionary);
            return jsonDictionary;
        }else if ([_jsonObject isKindOfClass:[NSMutableArray class]]) {
            jsonArray = (NSArray*)_jsonObject;
            NSLog(@"%@",jsonArray);
            return jsonArray;
        }
    }
    return nil;
}


@end
