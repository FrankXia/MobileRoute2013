//
//  OfflineEditingAppDelegate.m
//  MobileRoute2013
//
//  Created by Frank on 3/13/13.
//  Copyright (c) 2013 Esri. All rights reserved.
//

#import "OfflineEditingAppDelegate.h"

#import "OfflineEditingViewController.h"
#import "Plenary1ViewController.h"

@implementation OfflineEditingAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        self.viewController = [[OfflineEditingViewController alloc] initWithNibName:@"OfflineEditingViewController_iPhone" bundle:nil];
//    } else {
//        self.viewController = [[OfflineEditingViewController alloc] initWithNibName:@"OfflineEditingViewController_iPad" bundle:nil];
//    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[Plenary1ViewController alloc] initWithNibName:@"Plenary1ViewController" bundle:nil];
    } else {
        self.viewController = [[Plenary1ViewController alloc] initWithNibName:@"Plenary1ViewController" bundle:nil];
    }
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
