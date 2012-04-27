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

extern NSString* const YIDetectWindowTouchUserInfoKey;
extern NSString* const YIDetectWindowTouchLocationUserInfoKey;
extern NSString* const YIDetectWindowTouchViewUserInfoKey;


@interface YIDetectWindow : UIWindow

@property (nonatomic, assign) BOOL detectsShake;
@property (nonatomic, assign) BOOL detectsStatusBarTap;
@property (nonatomic, assign) BOOL detectsTouchPhases;  // for all touches, dispatching separately
@property (nonatomic, assign) BOOL detectsLongPress;    // for only single touch

@end
