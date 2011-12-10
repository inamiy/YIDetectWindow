//
//  YIDetectWindow.m
//  YIDetectWindow
//
//  Created by Inami Yasuhiro on 11/12/10.
//  Copyright (c) 2011年 Yasuhiro Inami. All rights reserved.
//

#import "YIDetectWindow.h"

#define IS_ARC (__has_feature(objc_arc))

NSString* const YIDetectWindowDidReceiveShakeNotification = @"YIDetectWindowDidReceiveShakeNotification";
NSString* const YIDetectWindowDidReceiveStatusBarTapNotification = @"YIDetectWindowDidReceiveStatusBarTapNotification";


@implementation YIDetectWindow

@synthesize shakeEnabled = _shakeEnabled;
@synthesize statusBarTapEnabled = _statusBarTapEnabled;

- (void)_setup
{
    _statusBarWindow = [[UIWindow alloc] init];
    [_statusBarWindow setWindowLevel:UIWindowLevelStatusBar+1]; 
    [_statusBarWindow setBackgroundColor:[UIColor clearColor]]; 
    [_statusBarWindow setFrame:[[UIApplication sharedApplication] statusBarFrame]];
    [_statusBarWindow makeKeyAndVisible];
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleStatusBarTap:)];
    gesture.numberOfTouchesRequired = 1;
    [_statusBarWindow addGestureRecognizer:gesture];
    
#if !IS_ARC
    [gesture release];
#endif
    
    self.shakeEnabled = NO;
    self.statusBarTapEnabled = NO;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self _setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setup];
        
    }
    return self;
}

#if !IS_ARC
- (void)dealloc
{
    [_statusBarWindow release];
    [super dealloc];
}
#endif

#pragma mark -

#pragma mark Accessors

- (void)setStatusBarTapEnabled:(BOOL)statusBarTapEnabled
{
    _statusBarTapEnabled = statusBarTapEnabled;
    _statusBarWindow.hidden = !statusBarTapEnabled;
}

#pragma mark -

#pragma mark UIResponder

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event { 
	if (_shakeEnabled && event.type == UIEventTypeMotion && motion == UIEventSubtypeMotionShake) {
		[[NSNotificationCenter defaultCenter] postNotificationName:YIDetectWindowDidReceiveShakeNotification object:self];
	}  
}

#pragma mark -

#pragma mark UIGesetureRecognizer

- (void)handleStatusBarTap:(UITapGestureRecognizer*)gesture
{
    [[NSNotificationCenter defaultCenter] postNotificationName:YIDetectWindowDidReceiveStatusBarTapNotification object:self];
}

@end
