//
//  AppDelegate.m
//  Fresh_water_daily
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 yangkenneg.com. All rights reserved.
//

#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "LeftViewController.h"
#import "FirstTableViewController.h"

@interface AppDelegate ()

@property(nonatomic,retain)SWRevealViewController *revealVC;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //获取storyBoard
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //获取前置视图
    LeftViewController *leftVC = [sb  instantiateViewControllerWithIdentifier:@"leftVC"];
    //获取后面的视图
    FirstTableViewController *centerVC = [sb instantiateViewControllerWithIdentifier:@"firstVC"];
    //初始化一个revealVC
    self.revealVC = [[SWRevealViewController alloc] initWithRearViewController:leftVC frontViewController:centerVC];
    //设置最大的平移量
    self.revealVC.rightViewRevealWidth = 250;
    //设置为根视图控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.revealVC];
    
 //   nav.navigationItem.title = @"首页";
    self.window.rootViewController = nav;
    
    
    
    
    
    
    
    
    
    
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
