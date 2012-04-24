//
//  YIDetectWindow.h
//  YIDetectWindow
//
//  Created by Inami Yasuhiro on 11/12/10.
//  Copyright (c) 2011年 Yasuhiro Inami. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const YIDetectWindowDidReceiveShakeNotification;
extern NSString* const YIDetectWindowDidReceiveStatusBarTapNotification;
extern NSString* const YIDetectWindowDidReceiveTouchBeganNotification;
extern NSString* const YIDetectWindowDidReceiveTouchEndedNotification;
extern NSString* const YIDetectWindowDidReceiveLongPressNotification;

extern NSString* const YIDetectWindowTouchLocationUserInfoKey;
extern NSString* const YIDetectWindowTouchViewUserInfoKey;


@interface YIDetectWindow : UIWindow 
{
    UIWindow*   _statusBarWindow;
    
    CGPoint     _touchStartLocation;
}

@property (nonatomic, assign) BOOL shakeEnabled;
@property (nonatomic, assign) BOOL statusBarTapEnabled;
@property (nonatomic, assign) BOOL singleTouchEnabled;  // single touchBegan/touchEnded
@property (nonatomic, assign) BOOL longPressEnabled;    // single longPress

@end
