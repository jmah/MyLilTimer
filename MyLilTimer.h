//
//  MyLilTimer.h
//  TimerTest
//
//  Created by Jonathon Mah on 2014-01-01.
//  Copyright (c) 2014 Jonathon Mah. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, MyLilTimerBehavior) {
    /// The timer fires after an interval has elapsed, regardless of system clock changes and system sleep.
    MyLilTimerBehaviorHourglass = 0,

    /// The timer fires after the system has run for some duration; this is paused while the operating system was asleep.
    ///
    /// This is the behavior of \p NSTimer and \p NSRunLoop / \p CFRunLoop.
    MyLilTimerBehaviorPauseOnSystemSleep = 1,

    /// The timer fires when the time on the system clock passes the fire date.
    MyLilTimerBehaviorObeySystemClockChanges = 2,

    /// (aliases)
    //MyLilTimerBehaviorNSTimer = MyLilTimerBehaviorPauseOnSystemSleep,
    //MyLilTimerBehaviorForAlarms = MyLilTimerBehaviorObeySystemClockChanges,
    //MyLilTimerBehaviorForThroughput = MyLilTimerBehaviorPauseOnSystemSleep,
};


@interface MyLilTimer : NSObject

/**
 * Returns a time interval appropriate for measuring the given timer behavior.
 * An individual value is arbitrary; use the difference between two invocations of this method.
 */
+ (NSTimeInterval)timeIntervalValueForBehavior:(MyLilTimerBehavior)behavior;

/**
 * Designated initializer.
 */
- (instancetype)initWithBehavior:(MyLilTimerBehavior)behavior timeInterval:(NSTimeInterval)intervalSinceNow target:(id)target selector:(SEL)selector userInfo:(id)userInfo;

/**
 * Fires the timer immediately, sending the action to the target, then invalidates.
 * Does nothing if the timer has been invalidated.
 */
- (void)fire;

/**
 * Returns the date at which the timer is currently schedule to fire.
 * This value can change depending on the timer behavior, system clock changes, and system sleep.
 */
- (NSDate *)fireDate;

/**
 * Returns the duration that has elapsed since the timer's fire date.
 * If the timer has not yet fired, the return value will be negative indicating a time in the future.
 */
- (NSTimeInterval)timeSinceFireDate;

/**
 * A larger value allows the timer to fire later, in sync with other system activity to reduce power use.
 * \see -[NSTimer tolerance]
 */
@property (nonatomic) NSTimeInterval tolerance;

- (void)invalidate;
@property (nonatomic, readonly, getter = isValid) BOOL valid;

@property (nonatomic, readonly) id userInfo;

@end
