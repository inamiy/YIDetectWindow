YIDetectWindow 1.0.0
====================

A subclass of UIWindow for detecting shake, status-bar-tap, long-press, touchBegan/Moved/Ended/Cancelled, via NSNotification.

Install via [CocoaPods](http://cocoapods.org/)
----------

```
pod 'YIDetectWindow'
```

How to use
----------

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIViewController* rootViewController = self.window.rootViewController;
    
    // replace UIWindow with YIDetectWindow
    YIDetectWindow* window = [[YIDetectWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.detectsShake = YES;
    window.detectsStatusBarTap = YES;
    window.detectsTouchPhases = YES;
    window.detectsLongPress = YES;
    
    self.window = window;
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}
```

Notifications
-------------

```
extern NSString* const YIDetectWindowDidReceiveShakeNotification;
extern NSString* const YIDetectWindowDidReceiveStatusBarTapNotification;
extern NSString* const YIDetectWindowDidReceiveTouchesBeganNotification;
extern NSString* const YIDetectWindowDidReceiveTouchesMovedNotification;
extern NSString* const YIDetectWindowDidReceiveTouchesEndedNotification;
extern NSString* const YIDetectWindowDidReceiveTouchesCancelledNotification;
extern NSString* const YIDetectWindowDidReceiveLongPressNotification;
```

License
-------
`YIDetectWindow` is available under the [Beerware](http://en.wikipedia.org/wiki/Beerware) license.

If we meet some day, and you think this stuff is worth it, you can buy me a beer in return.