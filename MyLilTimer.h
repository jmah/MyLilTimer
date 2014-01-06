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

- (instancetype)init NS_UNAVAILABLE;

/**
 * Creates a new timer, without scheduling it on a run loop.
 * \em (Designated initializer.)
 *
 * \param behavior determines how time is measured.
 *
 * \param intervalSinceNow the number of seconds before the timer fires.
 *     The minimum value is 0.0001 for consistency with NSTimer.
 *
 * \param target the object to which to send the message specified by \p action when the timer fires.
 *     The timer maintains a strong reference to target until it (the timer) is invalidated.
 *
 * \param action the message to send to \p target when the timer fires.
 *     This method should have the signature:
 *     \p - (void)timerFired:(MyLilTimer *)timer
 */
- (instancetype)initWithBehavior:(MyLilTimerBehavior)behavior timeInterval:(NSTimeInterval)intervalSinceNow target:(id)target selector:(SEL)action userInfo:(id)userInfo;

/**
 * Currently only timers on the main thread (using the main loop) are supported.
 */
- (void)scheduleOnMainRunLoopForModes:(NSSet *)modes;

/**
 * Fires the timer immediately, sending the action to the target, then invalidates.
 * Does nothing if the timer has been invalidated.
 */
- (void)fire;

@property (nonatomic, readonly) MyLilTimerBehavior behavior;
@property (nonatomic, readonly) id userInfo;

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

@end
