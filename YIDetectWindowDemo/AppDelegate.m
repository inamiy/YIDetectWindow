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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTouchesBeganNotification:) name:YIDetectWindowDidReceiveTouchesBeganNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTouchesMovedNotification:) name:YIDetectWindowDidReceiveTouchesMovedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTouchesEndedNotification:) name:YIDetectWindowDidReceiveTouchesEndedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTouchesCancelledNotification:) name:YIDetectWindowDidReceiveTouchesCancelledNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLongPressNotification:) name:YIDetectWindowDidReceiveLongPressNotification object:nil];
    
    YIDetectWindow* window = [[YIDetectWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.detectsShake = YES;
    window.detectsStatusBarTap = YES;
    window.detectsTouchPhases = YES;    // touchBegan/Ended
    window.detectsLongPress = YES;
    
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

- (void)didReceiveTouchesBeganNotification:(NSNotification*)notification
{
    NSSet* touches = notification.userInfo[YIDetectWindowTouchesUserInfoKey];
    for (UITouch* touch in touches) {
        UIView* view = touch.view;
        CGPoint point = [touch locationInView:touch.view];
        
        NSLog(@"touch began at %@ (%f, %f)!",[view class],point.x,point.y);
    }
}

- (void)didReceiveTouchesMovedNotification:(NSNotification*)notification
{
    NSSet* touches = notification.userInfo[YIDetectWindowTouchesUserInfoKey];
    for (UITouch* touch in touches) {
        UIView* view = touch.view;
        CGPoint point = [touch locationInView:touch.view];
        
        NSLog(@"touch moved at %@ (%f, %f)!",[view class],point.x,point.y);
    }
}

- (void)didReceiveTouchesEndedNotification:(NSNotification*)notification
{
    NSSet* touches = notification.userInfo[YIDetectWindowTouchesUserInfoKey];
    for (UITouch* touch in touches) {
        UIView* view = touch.view;
        CGPoint point = [touch locationInView:touch.view];
        
        NSLog(@"touch ended at %@ (%f, %f)!",[view class],point.x,point.y);
    }
}

- (void)didReceiveTouchesCancelledNotification:(NSNotification*)notification
{
    NSSet* touches = notification.userInfo[YIDetectWindowTouchesUserInfoKey];
    for (UITouch* touch in touches) {
        UIView* view = touch.view;
        CGPoint point = [touch locationInView:touch.view];
        
        NSLog(@"touch cancelled at %@ (%f, %f)!",[view class],point.x,point.y);
    }
}

- (void)didReceiveLongPressNotification:(NSNotification*)notification
{
    NSSet* touches = notification.userInfo[YIDetectWindowTouchesUserInfoKey];
    UITouch* touch = [touches anyObject];
    
    UIView* view = touch.view;
    CGPoint point = [touch locationInView:touch.view];
    
    NSLog(@"long press at %@ (%f, %f)!",[view class],point.x,point.y);
}

@end
