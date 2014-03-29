//
//  YIDetectWindow.m
//  YIDetectWindow
//
//  Created by Inami Yasuhiro on 11/12/10.
//  Copyright (c) 2011年 Yasuhiro Inami. All rights reserved.
//

#import "YIDetectWindow.h"

#define IS_PORTRAIT             UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)
#define STATUS_BAR_HEIGHT       (IS_PORTRAIT ? [UIApplication sharedApplication].statusBarFrame.size.height : [UIApplication sharedApplication].statusBarFrame.size.width)

#define LONG_PRESS_DELAY    0.5
#define ALLOWABLE_MOVEMENT  10

#define DISTANCE(a,b) sqrtf((a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y))

NSString* const YIDetectWindowDidReceiveShakeNotification = @"YIDetectWindowDidReceiveShakeNotification";
NSString* const YIDetectWindowDidReceiveStatusBarTapNotification = @"YIDetectWindowDidReceiveStatusBarTapNotification";
NSString* const YIDetectWindowDidReceiveTouchesBeganNotification = @"YIDetectWindowDidReceiveTouchesBeganNotification";
NSString* const YIDetectWindowDidReceiveTouchesMovedNotification = @"YIDetectWindowDidReceiveTouchesMovedNotification";
NSString* const YIDetectWindowDidReceiveTouchesEndedNotification = @"YIDetectWindowDidReceiveTouchesEndedNotification";
NSString* const YIDetectWindowDidReceiveTouchesCancelledNotification = @"YIDetectWindowDidReceiveTouchesCancelledNotification";
NSString* const YIDetectWindowDidReceiveLongPressNotification = @"YIDetectWindowDidReceiveLongPressNotification";

NSString* const YIDetectWindowTouchesUserInfoKey = @"YIDetectWindowTouchesUserInfoKey";


@interface YIDetectStatusBarViewController : UIViewController
@end


@implementation YIDetectStatusBarViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIViewController* vc = [YIDetectWindow detectWindow].rootViewController;

    while (vc.childViewControllerForStatusBarStyle) {
        vc = vc.childViewControllerForStatusBarStyle;
    }
    
    return vc.preferredStatusBarStyle;
}

@end


#pragma mark -


@interface YIDetectStatusBarWindow : UIWindow
@end


@implementation YIDetectStatusBarWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rootViewController = [[YIDetectStatusBarViewController alloc] init];
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* rootView = self.rootViewController.view;
    CGPoint convertedPoint = [self convertPoint:point toView:rootView];
    
    // don't detect touches if statusBar is hidden
    if (self.rootViewController.prefersStatusBarHidden || [UIApplication sharedApplication].statusBarHidden) {
        return NO;
    }
    
    // detect only if touch is inside statusBarRect
    CGRect statusBarRect = rootView.bounds;
    statusBarRect.size.height = STATUS_BAR_HEIGHT;
    if (CGRectContainsPoint(statusBarRect, convertedPoint)) {
        return YES;
    }
    
    return NO;
}

@end


#pragma mark -


@interface YIDetectWindow ()

@property (nonatomic, strong)   UIWindow*       statusBarWindow;
@property (nonatomic)           CGPoint         longPressStartLocation;

@end


@implementation YIDetectWindow 

@synthesize detectsShake = _detectsShake;
@synthesize detectsStatusBarTap = _detectsStatusBarTap;
@synthesize detectsTouchPhases = _detectsTouchPhases;
@synthesize detectsLongPress = _detectsLongPress;

#pragma mark -

#pragma mark Class Method

+ (YIDetectWindow*)detectWindow
{
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        if ([window isKindOfClass:[YIDetectWindow class]]) {
            return (YIDetectWindow*)window;
        }
    }
    
    return nil;
}

#pragma mark -

#pragma mark Init/Dealloc

- (void)_setup
{
    _statusBarWindow = [[YIDetectStatusBarWindow alloc] init];
    _statusBarWindow.frame = [UIScreen mainScreen].bounds;
    _statusBarWindow.windowLevel = UIWindowLevelStatusBar+1;
    _statusBarWindow.backgroundColor = [UIColor clearColor];
    [_statusBarWindow makeKeyAndVisible];
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleStatusBarTap:)];
    gesture.numberOfTouchesRequired = 1;
    [_statusBarWindow addGestureRecognizer:gesture];
    
    _detectsShake = NO;
    _detectsStatusBarTap = NO;
    _detectsTouchPhases = NO;
    _detectsLongPress = NO;
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
    NSSet *touches = [event touchesForWindow:self];
    
    // touchBegan/Ended (for all touches, dispatching separately)
    if (self.detectsTouchPhases) {
        NSMutableSet* beganTouches = [NSMutableSet set];
        NSMutableSet* movedTouches = [NSMutableSet set];
        NSMutableSet* endedTouches = [NSMutableSet set];
        NSMutableSet* cancelledTouches = [NSMutableSet set];
        
        for (UITouch* touch in touches) {
            if ([touch phase] == UITouchPhaseBegan) {
                [beganTouches addObject:touch];
            }
            else if ([touch phase] == UITouchPhaseMoved) {
                [movedTouches addObject:touch];
            }
            else if ([touch phase] == UITouchPhaseEnded) {
                [endedTouches addObject:touch];
            }
            else if ([touch phase] == UITouchPhaseCancelled) {
                [cancelledTouches addObject:touch];
            }
        }
        
        [self didBeginTouches:beganTouches];
        [self didMoveTouches:movedTouches];
        [self didEndTouches:endedTouches];
        [self didCancelTouches:cancelledTouches];
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

    [super sendEvent:event];
}

- (void)didBeginTouches:(NSSet*)touches
{
    if (!self.detectsTouchPhases || touches.count == 0) return;
    
    NSDictionary* userInfo = @{ YIDetectWindowTouchesUserInfoKey : touches };
    [[NSNotificationCenter defaultCenter] postNotificationName:YIDetectWindowDidReceiveTouchesBeganNotification object:self userInfo:userInfo];
}

- (void)didMoveTouches:(NSSet*)touches
{
    if (!self.detectsTouchPhases || touches.count == 0) return;
    
    NSDictionary* userInfo = @{ YIDetectWindowTouchesUserInfoKey : touches };
    [[NSNotificationCenter defaultCenter] postNotificationName:YIDetectWindowDidReceiveTouchesMovedNotification object:self userInfo:userInfo];
}

- (void)didEndTouches:(NSSet*)touches
{
    if (!self.detectsTouchPhases || touches.count == 0) return;
    
    NSDictionary* userInfo = @{ YIDetectWindowTouchesUserInfoKey : touches };
    [[NSNotificationCenter defaultCenter] postNotificationName:YIDetectWindowDidReceiveTouchesEndedNotification object:self userInfo:userInfo];
}

- (void)didCancelTouches:(NSSet*)touches
{
    if (!self.detectsTouchPhases || touches.count == 0) return;
    
    NSDictionary* userInfo = @{ YIDetectWindowTouchesUserInfoKey : touches };
    [[NSNotificationCenter defaultCenter] postNotificationName:YIDetectWindowDidReceiveTouchesCancelledNotification object:self userInfo:userInfo];
}

- (void)didLongPress:(UITouch*)touch
{
    if (!self.detectsLongPress || !touch) return;
    
    NSDictionary* userInfo = @{ YIDetectWindowTouchesUserInfoKey : [NSSet setWithObject:touch] };
    [[NSNotificationCenter defaultCenter] postNotificationName:YIDetectWindowDidReceiveLongPressNotification object:self userInfo:userInfo];
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
