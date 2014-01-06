//
//  MyLilTimer.m
//  TimerTest
//
//  Created by Jonathon Mah on 2014-01-01.
//  Copyright (c) 2014 Jonathon Mah. All rights reserved.
//

#import "MyLilTimer.h"

#import <sys/sysctl.h>



static NSString *NSStringFromMyLilTimerBehavior(MyLilTimerBehavior b)
{
    switch (b) {
#define CASE_RETURN(x)  case x: return @#x
            CASE_RETURN(MyLilTimerBehaviorHourglass);
            CASE_RETURN(MyLilTimerBehaviorPauseOnSystemSleep);
            CASE_RETURN(MyLilTimerBehaviorObeySystemClockChanges);
#undef CASE_RETURN
    }
    return nil;
}

static BOOL isValidBehavior(MyLilTimerBehavior b)
{
    return (NSStringFromMyLilTimerBehavior(b) != nil);
}

static NSTimeInterval timeIntervalSinceBoot(void)
{
    // TODO: Potentially a race condition if the system clock changes between reading `bootTime` and `now`
    int status;

    struct timeval bootTime;
    status = sysctl((int[]){CTL_KERN, KERN_BOOTTIME}, 2,
                    &bootTime, &(size_t){sizeof(bootTime)},
                    NULL, 0);
    NSCAssert(status == 0, nil);

    struct timeval now;
    status = gettimeofday(&now, NULL);
    NSCAssert(status == 0, nil);

    struct timeval difference;
    timersub(&now, &bootTime, &difference);

    return (difference.tv_sec + difference.tv_usec * 1.e-6);
}



@implementation MyLilTimer {
    id _target;
    SEL _action;
}


#pragma mark NSObject

- (instancetype)init
{
    NSAssert(NO, @"Bad initializer, use %s", sel_getName(@selector(initWithBehavior:timeInterval:target:selector:userInfo:)));
    return nil;
}


#pragma mark MyLilTimer: API

+ (NSTimeInterval)timeIntervalValueForBehavior:(MyLilTimerBehavior)behavior
{
    NSParameterAssert(isValidBehavior(behavior));
    switch (behavior) {
        case MyLilTimerBehaviorHourglass:
            return timeIntervalSinceBoot();
        case MyLilTimerBehaviorPauseOnSystemSleep:
            // a.k.a. [NSProcessInfo processInfo].systemUptime
            // a.k.a. _CFGetSystemUptime()
            // a.k.a. mach_absolute_time() (in different units)
            return CACurrentMediaTime();
        case MyLilTimerBehaviorObeySystemClockChanges:
            return [NSDate timeIntervalSinceReferenceDate];
    }
}


- (instancetype)initWithBehavior:(MyLilTimerBehavior)behavior timeInterval:(NSTimeInterval)intervalSinceNow target:(id)target selector:(SEL)action userInfo:(id)userInfo
{
    if (!(self = [super init])) {
        return nil;
    }

    NSParameterAssert(isValidBehavior(behavior));
    NSParameterAssert(target != nil);
    NSParameterAssert(action != NULL);

    // NSTimer behavior
    intervalSinceNow = MAX(0.1e-3, intervalSinceNow);

    _behavior = behavior;
    _target = target;
    _action = action;
    _userInfo = userInfo;

    return self;
}


@end
