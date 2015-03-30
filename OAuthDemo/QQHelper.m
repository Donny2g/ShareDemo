//
//  QQHelper.m
//  OAuthDemo
//
//  Created by Donny2g Hu on 15/3/30.
//  Copyright (c) 2015年 Donny2g Hu. All rights reserved.
//

#import "QQHelper.h"
@interface QQHelper()
@property (nonatomic, strong) TencentOAuth *qqOAuth;
@end
@implementation QQHelper
static QQHelper *_gWeixinHelper = nil;

+ (QQHelper *) helper
{
    if(!_gWeixinHelper) {
        _gWeixinHelper = [[QQHelper alloc] init];
    }
    return _gWeixinHelper;
}

- (id) init
{
    self = [super init];
    if(self) {
        NSString *appid = kQQAppKey;
        self.qqOAuth = [[TencentOAuth alloc] initWithAppId:appid
                                               andDelegate:self];
    }
    return self;
}


- (void)qqlogin
{
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
                            kOPEN_PERMISSION_ADD_IDOL,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_PIC_T,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            kOPEN_PERMISSION_DEL_IDOL,
                            kOPEN_PERMISSION_DEL_T,
                            kOPEN_PERMISSION_GET_FANSLIST,
                            kOPEN_PERMISSION_GET_IDOLLIST,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            kOPEN_PERMISSION_GET_REPOST_LIST,
                            kOPEN_PERMISSION_LIST_ALBUM,
                            kOPEN_PERMISSION_UPLOAD_PIC,
                            kOPEN_PERMISSION_GET_VIP_INFO,
                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                            kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                            nil];

    [self.qqOAuth authorize:permissions inSafari:NO];
    
}


- (void)shareTextMessage:(NSString *)text type:(enum TencentShareType)type
{
    QQApiTextObject* txtObj = [QQApiTextObject objectWithText:text];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:txtObj];
    
    if (type == TencentShareQQ) {
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        [self handleSendResult:sent];


    }else if(type == TencentShareQQZone)
    {
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        [self handleSendResult:sent];
    }
    
}

- (void)shareImageMessage:(NSString *)title description:(NSString *)description image:(UIImage *)image  type:(enum TencentShareType)type
{
    NSData* data = UIImagePNGRepresentation(image);

    
    QQApiImageObject* img = [QQApiImageObject objectWithData:data previewImageData:data title:title description:description];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    
    if (type == TencentShareQQ) {
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        [self handleSendResult:sent];
        
        
    }else if(type == TencentShareQQZone)
    {
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        [self handleSendResult:sent];
    }
}

- (void)shareLinkMessagetitle:(NSString *)title description:(NSString *)description image:(UIImage *)image  url:(NSString *)url type:(enum TencentShareType)type
{
    
    NSData* data = UIImagePNGRepresentation(image);
    NSURL* openurl = [NSURL URLWithString:url];
    
    QQApiNewsObject* img = [QQApiNewsObject objectWithURL:openurl title:title description:description previewImageData:data];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    
    if (type == TencentShareQQ) {
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        [self handleSendResult:sent];
        
        
    }else if(type == TencentShareQQZone)
    {
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        [self handleSendResult:sent];
    }
}



- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        default:
        {
            break;
        }
    }
}



#pragma mark -
#pragma mark - OAuth Delegate
- (void)tencentDidLogin
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessed object:self];
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginFailed object:self];
}

- (void)tencentDidNotNetWork
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginFailed object:self];
}

- (NSArray *)getAuthorizedPermissions:(NSArray *)permissions withExtraParams:(NSDictionary *)extraParams
{
    return nil;
}

- (void)tencentDidLogout
{
    
}


- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth withPermissions:(NSArray *)permissions
{
    return YES;
}


- (BOOL)tencentNeedPerformReAuth:(TencentOAuth *)tencentOAuth
{
    return YES;
}

- (void)tencentDidUpdate:(TencentOAuth *)tencentOAuth
{
}


- (void)tencentFailedUpdate:(UpdateFailType)reason
{
}


- (void)getUserInfoResponse:(APIResponse*) response
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kGetUserInfoResponse object:self  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:response, kResponse, nil]];
}





@end
