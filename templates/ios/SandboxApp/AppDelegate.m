//
//  AppDelegate.m
//  SandboxApp
//
//  Created by hendy.christianto on 09/03/20.
//  Copyright © 2020 Traveloka. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [UIViewController new];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
