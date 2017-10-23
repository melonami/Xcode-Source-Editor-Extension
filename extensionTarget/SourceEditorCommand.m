//
//  SourceEditorCommand.m
//  extensionTarget
//
//  Created by sj on 2017/9/14.
//  Copyright © 2017年 sj. All rights reserved.
//

#import "SourceEditorCommand.h"
#import "NSString+MD5.h"
#import <AppKit/AppKit.h>

@implementation SourceEditorCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler
{
    // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
    NSString *identifier = invocation.commandIdentifier;
    
    if ([identifier hasSuffix:@"SourceEditorCommand"]) {
        //注释代码
        [self translate:invocation];
    }

    completionHandler(nil);
}
-(void)translate:(XCSourceEditorCommandInvocation *)invocation{
    
    XCSourceTextRange *range=invocation.buffer.selections[0];
        NSInteger startLine = range.start.line;
        NSInteger startColumn = range.start.column;
        NSInteger endColumn = range.end.column;
        
        NSString *line = invocation.buffer.lines[startLine];
        NSString *str= [line substringWithRange:NSMakeRange(startColumn, endColumn-startColumn)];
    NSLog(@"就是这样？%@",str);
    NSURLSessionConfiguration *defaultConfigObject =[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session  = [NSURLSession sessionWithConfiguration:
                              defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    //签名，通过md5(appKey+q+salt+密钥)生成
    NSString *q=str;
    NSString *appKey=@"5e7374b07f75c24d";
    NSString *key=@"fZOlBiLjs0IVGXd0XwmgW32hWqZjIiEs";
    uint32_t salt=arc4random();
    NSString *signstr=[NSString stringWithFormat:@"%@%@%d%@",appKey,q,salt,key];
    NSString *sign=[signstr MD5Digest];
    NSURL *url = [NSURL
                  URLWithString:[[NSString alloc] initWithFormat:@"http://openapi.youdao.com/api?q=%@&from=EN&to=zh_CHS&appKey=%@&salt=%d&sign=%@",q,appKey,salt,sign]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url
                                                         cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                     timeoutInterval:10.0];
    request.HTTPMethod = @"GET";
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    
    NSURLSessionTask *task =  [session dataTaskWithRequest:request
                                         completionHandler:^(NSData *data, NSURLResponse *response,
                                                             NSError *error) {
                                             NSString *responseStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                             NSLog(@"data =%@",responseStr);
                                             
                                              NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                             
                                             
                                             NSArray* explains = [resultDictionary objectForKey:@"translation"];
                                             
                                             
                                             NSString *responseStr1=[explains objectAtIndex:0];
                                             
                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"notifacation" object:responseStr1];
                                            
                                             
                                         }
                               ];
    [task resume];
    
    return;
}

@end
