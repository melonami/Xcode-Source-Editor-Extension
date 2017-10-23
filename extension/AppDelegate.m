//
//  AppDelegate.m
//  extension
//
//  Created by sj on 2017/9/14.
//  Copyright © 2017年 sj. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(executenow:)
                                                 name:@"nowalert"
                                               object:nil];
}

-(void)executenow:(NSNotification*) notification{
    NSLog(@"%@",[NSString stringWithFormat:@"%@",[notification object]]);
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
