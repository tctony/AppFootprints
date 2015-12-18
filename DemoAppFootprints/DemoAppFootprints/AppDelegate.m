//
//  AppDelegate.m
//  DemoAppFootprints
//
//  Created by changtang on 15/12/18.
//  Copyright © 2015年 Tencent House. All rights reserved.
//

#import "AppDelegate.h"

#import "QHAppFootprints.h"


@interface AppDelegate () {
    NSInteger _activeCount;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    _activeCount = 0;

    HLogFootprint(@"didFinishLaunchingWithOptions", nil);

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    HLogFootprint(@"applicationWillResignActive", nil);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    HLogFootprint(@"applicationDidEnterBackground", nil);
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    HLogFootprint(@"applicationWillEnterForeground", nil);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    _activeCount += 1;

    NSString *info = [NSString stringWithFormat:@"%d", (int)_activeCount];
    HLogFootprint(@"applicationDidBecomeActive", info);
}

- (void)applicationWillTerminate:(UIApplication *)application {
    HLogFootprint(@"applicationWillTerminate", nil);
}

@end
