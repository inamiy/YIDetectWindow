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
NSString* const YIDetectWindowDidReceiveTouchBeganNotification = @"YIDetectWindowDidReceiveTouchBeganNotification";
NSString* const YIDetectWindowDidReceiveTouchEndedNotification = @"YIDetectWindowDidReceiveTouchEndedNotification";
NSString* const YIDetectWindowDidReceiveLongPressNotification = @"YIDetectWindowDidReceiveLongPressNotification";

NSString* const YIDetectWindowTouchUserInfoKey = @"YIDetectWindowTouchUserInfoKey";
NSString* const YIDetectWindowTouchLocationUserInfoKey = @"YIDetectWindowTouchLocationUserInfoKey";
NSString* const YIDetectWindowTouchViewUserInfoKey = @"YIDetectWindowTouchViewUserInfoKey";


@implementation YIDetectWindow 
{
    UIWindow*   _statusBarWindow;
    
    CGPoint     _longPressStartLocation;
}

@synthesize detectsShake = _detectsShake;
@synthesize detectsStatusBarTap = _detectsStatusBarTap;
@synthesize detectsTouchPhases = _detectsTouchPhases;
@synthesize detectsLongPress = _detectsLongPress;

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
    
    self.detectsShake = NO;
    self.detectsStatusBarTap = NO;
    self.detectsTouchPhases = NO;
    self.detectsLongPress = NO;
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

- (void)setDetectsStatusBarTap:(BOOL)detectsStatusBarTap
{
    _detectsStatusBarTap = detectsStatusBarTap;
    _statusBarWindow.hidden = !detectsStatusBarTap;
}

#pragma mark -

#pragma mark UIWindow

// override
- (void)sendEvent:(UIEvent *)event
{
    [super sendEvent:event];
    
    NSSet *touches = [event touchesForWindow:self];
    
    // touchBegan/Ended (for all touches, dispatching separately)
    if (self.detectsTouchPhases) {
        for (UITouch* touch in touches) {
            if ([touch phase] == UITouchPhaseBegan) {
                [self didTouchBegan:touch];
            }
            else if ([touch phase] == UITouchPhaseEnded) {
                [self didTouchEnded:touch];
            }
        }
    }
    
    // longPress (for only single touch)
    if (self.detectsLongPress) {
        if ([touches count] == 1) {
            UITouch *touch = [touches anyObject];
            
            if ([touch phase] == UITouchPhaseBegan) {
                _longPressStartLocation = [touch locationInView:self];
                
                [self performSelector:@selector(didLongPress:) 
                           withObject:touch
                           afterDelay:LONG_PRESS_DELAY];
            }
            else if ([touch phase] == UITouchPhaseMoved) {
                if (DISTANCE(_longPressStartLocation, [touch locationInView:self]) > ALLOWABLE_MOVEMENT) {
                    [NSObject cancelPreviousPerformRequestsWithTarget:self];
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
}

- (void)didTouchBegan:(UITouch*)touch
{
    if (self.detectsTouchPhases) {
        NSValue* pointValue = [NSValue valueWithCGPoint:[touch locationInView:self]];
        NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  touch, YIDetectWindowTouchUserInfoKey,
                                  pointValue, YIDetectWindowTouchLocationUserInfoKey, 
                                  touch.view, YIDetectWindowTouchViewUserInfoKey, 
                                  nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:YIDetectWindowDidReceiveTouchBeganNotification object:self userInfo:userInfo];
    }
}

- (void)didTouchEnded:(UITouch*)touch
{
    if (self.detectsTouchPhases) {
        NSValue* pointValue = [NSValue valueWithCGPoint:[touch locationInView:self]];
        NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  touch, YIDetectWindowTouchUserInfoKey,
                                  pointValue, YIDetectWindowTouchLocationUserInfoKey, 
                                  touch.view, YIDetectWindowTouchViewUserInfoKey, 
                                  nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:YIDetectWindowDidReceiveTouchEndedNotification object:self userInfo:userInfo];
    }
}

- (void)didLongPress:(UITouch*)touch
{
    if (self.detectsLongPress) {
        NSValue* pointValue = [NSValue valueWithCGPoint:[touch locationInView:self]];
        NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  touch, YIDetectWindowTouchUserInfoKey,
                                  pointValue, YIDetectWindowTouchLocationUserInfoKey, 
                                  touch.view, YIDetectWindowTouchViewUserInfoKey, 
                                  nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:YIDetectWindowDidReceiveLongPressNotification object:self userInfo:userInfo];
    }
}

#pragma mark -

#pragma mark UIResponder

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{ 
	if (self.detectsShake) {
        if (event.type == UIEventTypeMotion && motion == UIEventSubtypeMotionShake) {
            [[NSNotificationCenter defaultCenter] postNotificationName:YIDetectWindowDidReceiveShakeNotification object:self];
        } 
    }
    else {
        //
        // NOTE:
        // By calling super-class method, default shaking method
        // e.g. UITextView's undo/redo will be safely performed.
        //
        [super motionEnded:motion withEvent:event];
    }
}

#pragma mark -

#pragma mark UIGesetureRecognizer

- (void)handleStatusBarTap:(UITapGestureRecognizer*)gesture
{
    if (self.detectsStatusBarTap) {
        [[NSNotificationCenter defaultCenter] postNotificationName:YIDetectWindowDidReceiveStatusBarTapNotification object:self];
    }
}

@end
