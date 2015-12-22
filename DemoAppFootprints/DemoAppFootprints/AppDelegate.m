//
//  AppDelegate.m
//  DemoAppFootprints
//
//  Created by changtang on 15/12/18.
//  Copyright © 2015年 Tencent House. All rights reserved.
//

#import "AppDelegate.h"

#define XLog NSLog
#define LogFootprintConsoleLog XLog

#import "QHAppFootprints.h"


@interface AppDelegate () {
    NSInteger _activeCount;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _activeCount = 0;

    LogFootprint(@"didFinishLaunchingWithOptions", nil);

    LogFootprint(@"test special chars", @",_:");

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    LogFootprint(@"applicationWillResignActive", nil);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    LogFootprint(@"applicationDidEnterBackground", nil);
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    LogFootprint(@"applicationWillEnterForeground", nil);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    _activeCount += 1;

    NSString *info = [NSString stringWithFormat:@"%d", (int)_activeCount];
    LogFootprint(@"applicationDidBecomeActive", info);
}

- (void)applicationWillTerminate:(UIApplication *)application {
    LogFootprint(@"applicationWillTerminate", nil);
}

@end
