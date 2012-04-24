//
//  AppDelegate.m
//  YIDetectWindowDemo
//
//  Created by Inami Yasuhiro on 11/12/10.
//  Copyright (c) 2011年 Yasuhiro Inami. All rights reserved.
//

#import "AppDelegate.h"

#import "YIDetectWindow.h"


@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveStatusBarTapNotification:) name:YIDetectWindowDidReceiveStatusBarTapNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveShakeNotification:) name:YIDetectWindowDidReceiveShakeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTouchBeganNotification:) name:YIDetectWindowDidReceiveTouchBeganNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTouchEndedNotification:) name:YIDetectWindowDidReceiveTouchEndedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLongPressNotification:) name:YIDetectWindowDidReceiveLongPressNotification object:nil];
    
    YIDetectWindow* window = [[YIDetectWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.statusBarTapEnabled = YES;
    window.shakeEnabled = YES;
    window.singleTouchEnabled = YES;    // single touchBegan/Ended
    window.longPressEnabled = YES;
    
    self.window = window;
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UIView* testView = [[UIView alloc] initWithFrame:CGRectMake(20, 40, 100, 100)];
    testView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    [self.window addSubview:testView];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -

#pragma mark YIDetectWindow

- (void)didReceiveStatusBarTapNotification:(NSNotification*)notification
{
    NSLog(@"status bar tapped!");
}

- (void)didReceiveShakeNotification:(NSNotification*)notification
{
    NSLog(@"shake!");
}

- (void)didReceiveTouchBeganNotification:(NSNotification*)notification
{
    UIView* view = [notification.userInfo objectForKey:YIDetectWindowTouchViewUserInfoKey];
    NSValue* pointValue = [notification.userInfo objectForKey:YIDetectWindowTouchLocationUserInfoKey];
    CGPoint point = [pointValue CGPointValue];
    
    NSLog(@"touch began at %@ (%f, %f)!",[view class],point.x,point.y);
}

- (void)didReceiveTouchEndedNotification:(NSNotification*)notification
{
    UIView* view = [notification.userInfo objectForKey:YIDetectWindowTouchViewUserInfoKey];
    NSValue* pointValue = [notification.userInfo objectForKey:YIDetectWindowTouchLocationUserInfoKey];
    CGPoint point = [pointValue CGPointValue];
    
    NSLog(@"touch ended at %@ (%f, %f)!",[view class],point.x,point.y);
}

- (void)didReceiveLongPressNotification:(NSNotification*)notification
{
    UIView* view = [notification.userInfo objectForKey:YIDetectWindowTouchViewUserInfoKey];
    NSValue* pointValue = [notification.userInfo objectForKey:YIDetectWindowTouchLocationUserInfoKey];
    CGPoint point = [pointValue CGPointValue];
    
    NSLog(@"long press at %@ (%f, %f)!",[view class],point.x,point.y);
}

@end
