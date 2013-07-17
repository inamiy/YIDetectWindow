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
extern NSString* const YIDetectWindowDidReceiveTouchesBeganNotification;
extern NSString* const YIDetectWindowDidReceiveTouchesMovedNotification;
extern NSString* const YIDetectWindowDidReceiveTouchesEndedNotification;
extern NSString* const YIDetectWindowDidReceiveTouchesCancelledNotification;
extern NSString* const YIDetectWindowDidReceiveLongPressNotification;

extern NSString* const YIDetectWindowTouchesUserInfoKey;


@interface YIDetectWindow : UIWindow

@property (nonatomic, assign) BOOL detectsShake;
@property (nonatomic, assign) BOOL detectsStatusBarTap;
@property (nonatomic, assign) BOOL detectsTouchPhases;  // for all touches, dispatching separately
@property (nonatomic, assign) BOOL detectsLongPress;    // for only single touch

+ (YIDetectWindow*)detectWindow;

@end
