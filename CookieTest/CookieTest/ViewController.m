//
//  ViewController.m
//  CookieTest
//
//  Created by 杨小兵 on 15/8/27.
//  Copyright (c) 2015年 杨小兵. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (IBAction)creatCookies:(id)sender;

- (IBAction)saveCookies:(id)sender;
- (IBAction)sendCookies:(id)sender;
@end

@implementation ViewController

- (IBAction)creatCookies:(id)sender
{
    NSMutableDictionary *cookieProperties1 = [NSMutableDictionary dictionary];
    [cookieProperties1 setObject:@"cookie1" forKey:NSHTTPCookieName];
    [cookieProperties1 setObject:@"my ios cookie 1" forKey:NSHTTPCookieValue];
    [cookieProperties1 setObject:@"test" forKey:NSHTTPCookieDomain];
    [cookieProperties1 setObject:@"test" forKey:NSHTTPCookieOriginURL];
    [cookieProperties1 setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties1 setObject:@"0" forKey:NSHTTPCookieVersion];
    NSHTTPCookie *cookie1 = [NSHTTPCookie cookieWithProperties:cookieProperties1];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie1];
    
    NSMutableDictionary *cookieProperties2 = [NSMutableDictionary dictionary];
    [cookieProperties2 setObject:@"cookie2" forKey:NSHTTPCookieName];
    [cookieProperties2 setObject:@"my ios cookie 2" forKey:NSHTTPCookieValue];
    [cookieProperties2 setObject:@"test" forKey:NSHTTPCookieDomain];
    [cookieProperties2 setObject:@"test" forKey:NSHTTPCookieOriginURL];
    [cookieProperties2 setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties2 setObject:@"0" forKey:NSHTTPCookieVersion];
    NSHTTPCookie *cookie2 = [NSHTTPCookie cookieWithProperties:cookieProperties2];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie2];
    
    //获取cookie方法1
    // NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:url];
    //获取cookie方法2
    //NSString *cookieString = [[HTTPResponse allHeaderFields] valueForKey:@"Set-Cookie"];
    //获取cookie方法3
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        //        NSLog(@"cookie%@ -->> %@", cookie,cookie.debugDescription);
        
        NSLog(@"cookieName:%@ -->>cookieValue:%@", cookie.name,cookie.value);
    }
    
}

- (IBAction)saveCookies:(id)sender
{
    /**
     *  发送一个网络请求获取Cookie
     */
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com/"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:1 timeoutInterval:60];
    request.HTTPMethod = @"get";
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               //转换NSURLResponse成为HTTPResponse
                               NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
                               //获取headerfields
                               NSDictionary *fields = [HTTPResponse allHeaderFields];//原生NSURLConnection写法
                               NSLog(@"获取的cookie -->\n %@",[fields description]);
                               //获取cookie方法1
                               NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:url];
                               NSLog(@"获取的Cookie --> \n%@",cookies);
                               //获取cookie方法2
                               NSString *cookieString = [[HTTPResponse allHeaderFields] valueForKey:@"Set-Cookie"];
                               NSLog(@"获取的额cookie -->%@",cookieString);
                               //获取cookie方法3
                               NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                               for (NSHTTPCookie *cookie in [cookieJar cookies]) {
                                   NSLog(@"获取的cookiecookie\n%@", cookie);
                               }
                           }];
    
}

- (IBAction)sendCookies:(id)sender
{
    // 清空Cookies
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (id obj in _tmpArray) {
        [cookieJar deleteCookie:obj];
    }
    // 创建两个Cookie
    NSMutableDictionary *cookieProperties1 = [NSMutableDictionary dictionary];
    [cookieProperties1 setObject:@"cookie1" forKey:NSHTTPCookieName];
    [cookieProperties1 setObject:@"my ios cookie 1" forKey:NSHTTPCookieValue];
    [cookieProperties1 setObject:@"test" forKey:NSHTTPCookieDomain];
    [cookieProperties1 setObject:@"test" forKey:NSHTTPCookieOriginURL];
    [cookieProperties1 setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties1 setObject:@"0" forKey:NSHTTPCookieVersion];
    NSHTTPCookie *cookie1 = [NSHTTPCookie cookieWithProperties:cookieProperties1];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie1];
    
    NSMutableDictionary *cookieProperties2 = [NSMutableDictionary dictionary];
    [cookieProperties2 setObject:@"cookie2" forKey:NSHTTPCookieName];
    [cookieProperties2 setObject:@"my ios cookie 2" forKey:NSHTTPCookieValue];
    [cookieProperties2 setObject:@"test" forKey:NSHTTPCookieDomain];
    [cookieProperties2 setObject:@"test" forKey:NSHTTPCookieOriginURL];
    [cookieProperties2 setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties2 setObject:@"0" forKey:NSHTTPCookieVersion];
    NSHTTPCookie *cookie2 = [NSHTTPCookie cookieWithProperties:cookieProperties2];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie2];
    NSURL *url = [NSURL URLWithString:@"http://image.baidu.com/"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:1 timeoutInterval:60];
    request.HTTPMethod = @"POST";
    //  添加cookie 打印一下现在的Cookie
    NSMutableString *cookieString = [NSMutableString string];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        [cookieString appendFormat:@"%@=%@",cookie.name,cookie.value];
        NSLog(@"cookie-->%@=%@",cookie.name,cookie.value);
    }
    [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookies:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies] forURL:url mainDocumentURL:nil
     ];
    [request setValue:cookieString forHTTPHeaderField:@"Cookie"];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               NSLog(@"error --> \n%@",error);
                               //转换NSURLResponse成为HTTPResponse
                               NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
                               //获取headerfields
                               NSDictionary *fields = [HTTPResponse allHeaderFields];
                               // 原生NSURLConnection写法
                               NSLog(@"fields = %@",[fields description]);
                               //获取cookie方法1
                               NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:url];
                               NSLog(@"获取的Cookies -->%@",cookies);
                               //获取cookie方法2
                               NSString *cookieString = [[HTTPResponse allHeaderFields] valueForKey:@"Set-Cookie"];
                               NSLog(@"获取的cookie -->%@",cookieString);
                               //获取cookie方法3
                               NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                               for (NSHTTPCookie *cookie in [cookieJar cookies]) {
                                   NSLog(@"获取的cookie --> %@", cookie);
                               }
                           }];
}
@end
