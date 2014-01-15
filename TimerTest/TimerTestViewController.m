//
//  TimerTestViewController.m
//  MyLilTimer
//
//  Created by Jonathon Mah on 2014-01-12.
//  Use is subject to the MIT License, full text in the LICENSE file.
//  Copyright (c) 2014 Jonathon Mah. All rights reserved.
//

#import "TimerTestViewController.h"

#import "MyLilTimer.h"


@interface TimerTestViewController ()

@property (nonatomic) IBOutlet UILabel *hourglassLabel;
@property (nonatomic) IBOutlet UILabel *pauseOnSystemSleepLabel;
@property (nonatomic) IBOutlet UILabel *obeySystemClockChangesLabel;

@end


@implementation TimerTestViewController {
    NSMutableArray *_validTimers;
    NSTimer *_updateLabelsTimer;
    NSNumberFormatter *_numberFormatter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _validTimers = [NSMutableArray array];
    _numberFormatter = [[NSNumberFormatter alloc] init];
    _numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    _numberFormatter.minimumFractionDigits = _numberFormatter.maximumFractionDigits = 1;
}

- (IBAction)restartTimers:(id)sender
{
    [_updateLabelsTimer invalidate];
    for (MyLilTimer *timer in _validTimers) {
        [timer invalidate];
    }
    [_validTimers removeAllObjects];

    static const NSTimeInterval interval = 60;

    [_validTimers addObject:[MyLilTimer scheduledTimerWithBehavior:MyLilTimerBehaviorHourglass timeInterval:interval target:self selector:@selector(timerFired:) userInfo:self.hourglassLabel]];
    [_validTimers addObject:[MyLilTimer scheduledTimerWithBehavior:MyLilTimerBehaviorPauseOnSystemSleep timeInterval:interval target:self selector:@selector(timerFired:) userInfo:self.pauseOnSystemSleepLabel]];
    [_validTimers addObject:[MyLilTimer scheduledTimerWithBehavior:MyLilTimerBehaviorObeySystemClockChanges timeInterval:interval target:self selector:@selector(timerFired:) userInfo:self.obeySystemClockChangesLabel]];
    for (MyLilTimer *timer in _validTimers) {
        [self updateLabelForTimer:timer];
    }

    _updateLabelsTimer = [NSTimer scheduledTimerWithTimeInterval:(1. / 10.) target:self selector:@selector(updateLabelsTimerFired:) userInfo:nil repeats:YES];
}

- (void)updateLabelsTimerFired:(NSTimer *)timer
{
    for (MyLilTimer *timer in _validTimers) {
        [self updateLabelForTimer:timer];
    }
}

- (void)updateLabelForTimer:(MyLilTimer *)timer
{
    UILabel *label = timer.userInfo;
    NSTimeInterval timeSinceFireDate = timer.timeSinceFireDate;
    if (timeSinceFireDate < 0) {
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor blackColor];
    } else {
        label.backgroundColor = [UIColor greenColor];
        label.textColor = [UIColor whiteColor];
    }

    label.text = [_numberFormatter stringFromNumber:@(timeSinceFireDate)];
}

- (void)timerFired:(MyLilTimer *)timer
{
    [_validTimers removeObject:timer];
    [self updateLabelForTimer:timer];

    if (!_validTimers.count) {
        [_updateLabelsTimer invalidate];
        _updateLabelsTimer = nil;
    }
}

@end
