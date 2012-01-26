//
//  YIDetectWindow.m
//  YIDetectWindow
//
//  Created by Inami Yasuhiro on 11/12/10.
//  Copyright (c) 2011年 Yasuhiro Inami. All rights reserved.
//

#import "YIDetectWindow.h"

#define IS_ARC (__has_feature(objc_arc))

#define LONG_PRESS_DELAY    0.5
#define ALLOWABLE_MOVEMENT  10

#define DISTANCE(a,b) sqrtf((a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y))

NSString* const YIDetectWindowDidReceiveShakeNotification = @"YIDetectWindowDidReceiveShakeNotification";
NSString* const YIDetectWindowDidReceiveStatusBarTapNotification = @"YIDetectWindowDidReceiveStatusBarTapNotification";
NSString* const YIDetectWindowDidReceiveLongPressNotification = @"YIDetectWindowDidReceiveLongPressNotification";


@implementation YIDetectWindow

@synthesize shakeEnabled = _shakeEnabled;
@synthesize statusBarTapEnabled = _statusBarTapEnabled;
@synthesize longPressEnabled = _longPressEnabled;

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
    self.longPressEnabled = NO;
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

#pragma mark UIWindow

// override
- (void)sendEvent:(UIEvent *)event
{
    [super sendEvent:event];
    
    if (!self.longPressEnabled) return;
    
    NSSet *touches = [event touchesForWindow:self];
    
    if ([touches count] == 1) {
        UITouch *touch = [touches anyObject];
        
        if ([touch phase] == UITouchPhaseBegan) {
            _touchStartLocation = [touch locationInView:self];
            
            [self performSelector:@selector(didLongPress:) 
                       withObject:[NSValue valueWithCGPoint:_touchStartLocation]
                       afterDelay:LONG_PRESS_DELAY];
        }
        else if ([touch phase] == UITouchPhaseMoved) {
            if (DISTANCE(_touchStartLocation, [touch locationInView:self]) > ALLOWABLE_MOVEMENT) {
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
            }
            else {
                return;
            }
        }
        else {
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
        }
    } 
    else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
}

- (void)didLongPress:(NSValue*)pointValue
{
    if (self.longPressEnabled) {
        [[NSNotificationCenter defaultCenter] postNotificationName:YIDetectWindowDidReceiveLongPressNotification object:pointValue];
    }
}

#pragma mark -

#pragma mark UIResponder

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{ 
	if (self.shakeEnabled) {
        if (event.type == UIEventTypeMotion && motion == UIEventSubtypeMotionShake) {
            [[NSNotificationCenter defaultCenter] postNotificationName:YIDetectWindowDidReceiveShakeNotification object:self];
        } 
    }
}

#pragma mark -

#pragma mark UIGesetureRecognizer

- (void)handleStatusBarTap:(UITapGestureRecognizer*)gesture
{
    if (self.statusBarTapEnabled) {
        [[NSNotificationCenter defaultCenter] postNotificationName:YIDetectWindowDidReceiveStatusBarTapNotification object:self];
    }
}

@end
