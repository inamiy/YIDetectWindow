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


@interface YIDetectWindow : UIWindow {
    UIWindow*   _statusBarWindow;
    
    BOOL        _shakeEnabled;
    BOOL        _statusBarTapEnabled;
}

@property (nonatomic, assign) BOOL shakeEnabled;
@property (nonatomic, assign) BOOL statusBarTapEnabled;

@end
