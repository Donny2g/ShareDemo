//
//  WeixinHelper.m
//  OAuthDemo
//
//  Created by Donny2g Hu on 15/3/30.
//  Copyright (c) 2015年 Donny2g Hu. All rights reserved.
//

#import "WeixinHelper.h"

@implementation WeixinHelper

static WeixinHelper *_gWeixinHelper = nil;

+ (WeixinHelper *) helper
{
    if(!_gWeixinHelper) {
        _gWeixinHelper = [[WeixinHelper alloc] init];
    }
    return _gWeixinHelper;
}

- (id) init
{
    self = [super init];
    if(self) {
         
    }
    return self;
}


- (void)shareTextContent:(NSString *)text scence:(enum WXScene) scene
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = text;
    req.bText = YES;
    req.scene = scene;
    
    [WXApi sendReq:req];
}

- (void)shareImageContent:(UIImage *)image ext:(NSString *)messageExt scence:(enum WXScene) scene;
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"res1thumb.png"]];
    
    WXImageObject *ext = [WXImageObject object];
    
    ext.imageData = UIImagePNGRepresentation(image);
    
    message.mediaObject = ext;
    message.mediaTagName = [NSString stringWithFormat:@"%f",[[NSDate date]timeIntervalSince1970]];
    message.messageExt = messageExt;
    message.messageAction = @"<action>dotalist</action>";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
}

- (void)shareLinkContent:(NSString *)title description:(NSString *)description
                   image:(UIImage *)image url:(NSString *)url scene:(enum WXScene) scene
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
    
    message.mediaObject = ext;
    message.mediaTagName = [NSString stringWithFormat:@"%f",[[NSDate date]timeIntervalSince1970]];
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}


- (void)ssoLoginWithController:(UIViewController *)controller
{
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"0744" ;
 
    
//    SendAuthReq* req = [[SendAuthReq alloc] init];
//    req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"; // @"post_timeline,sns"
//    req.state = @"xxx";
//    
    [WXApi sendAuthReq:req viewController:controller delegate:self];
}


- (void) dealloc
{
    
}



- (BOOL) isWeixinInstalled
{
    if([WXApi isWXAppInstalled]) return YES;
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) return YES;
    return NO;
}
- (void) openWeixinApp
{
    [WXApi openWXApp];
}

- (BOOL) checkWeixinInstalled
{
    // alert weixin note installed
    if([self isWeixinInstalled]) return YES;
    
    NSString *strTitle = @"尚未安装微信";
    NSString *strMsg  = @"需要先安装微信才能使用微信分享功能，要现在安装吗？";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"现在安装", nil];
    alert.tag = 1;
    alert.delegate = self;
    [alert show];
    return NO;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%s", __func__);
    if(alertView.tag==1 && buttonIndex==1) {
    }
}


#pragma mark -
#pragma mark - WXDelegate
-(void) onReq:(BaseReq*)req
{
    NSLog(@"req: %@",[req description]);
}




-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *temp = (SendAuthResp*)resp;
        
        NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
        NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", temp.code, temp.state, temp.errCode];
        
        
        if (temp.errCode== 0) {
            NSString *code = temp.code;
            NSDictionary *dic = @{@"code":code};
            self.wxCode = code;
            
            [self getAccess_token];
        }
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}


-(void)getAccess_token  {
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWXAppKey,kWXAppSecret,self.wxCode];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                /*
                 {
                 "access_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWiusJMZwzQU8kXcnT1hNs_ykAFDfDEuNp6waj-bDdepEzooL_k1vb7EQzhP8plTbD0AgR8zCRi1It3eNS7yRyd5A";
                 "expires_in" = 7200;
                 openid = oyAaTjsDx7pl4Q42O3sDzDtA7gZs;
                 "refresh_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWi2ZzH_XfVVxZbmha9oSFnKAhFsS0iyARkXCa7zPu4MqVRdwyb8J16V8cWw7oNIff0l-5F-4-GJwD8MopmjHXKiA";
                 scope = "snsapi_userinfo,snsapi_base";
                 }
                 */
                
                self.access_token = [dic objectForKey:@"access_token"];
                self.openid = [dic objectForKey:@"openid"];
                
                [self getUserInfo];
            }
        });
    });
}


-(void)getUserInfo
{
    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",self.access_token,self.openid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                /*
                 {
                 city = Haidian;
                 country = CN;
                 headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
                 language = "zh_CN";
                 nickname = "xxx";
                 openid = oyAaTjsDx7pl4xxxxxxx;
                 privilege =     (
                 );
                 province = Beijing;
                 sex = 1;
                 unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
                 }
                 */
                
                NSLog(@"dic :%@",[dic
                       description]);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:[dic
                                                                                              description]
                                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                });
                
            }
        });
        
    });
}





@end