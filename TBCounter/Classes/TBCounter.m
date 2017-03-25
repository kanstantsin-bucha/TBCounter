//
//  TBTaskProcessor.m
//  QromaScan
//
//  Created by Bucha Kanstantsin on 3/16/17.
//  Copyright © 2017 Qroma. All rights reserved.
//

#import "TBCounter.h"

@interface TBCounter ()

@property (strong, nonatomic) TBCounter * counterSelfRetain;
@property (assign, nonatomic, readwrite) NSInteger remainTasksCount;
@property (assign, nonatomic, readwrite) NSInteger tasksCount;
@property (strong, nonatomic, readwrite) CDBErrorCompletion completion;
@property (strong, nonatomic, readwrite) NSError * error;
@property (assign, nonatomic, readwrite) TBCounterState state;
@property (assign, nonatomic, readwrite) BOOL shouldContinueAfterFire;

@end


@implementation TBCounter

- (NSInteger)completedTasksCount {
    NSInteger result = self.tasksCount - self.remainTasksCount;
    return result;
}

- (float)progress {
    float result = (float)(self.completedTasksCount) / self.tasksCount;
    return result;
}

/// MARK: - life cycle -

- (instancetype)initInstance {
    self = [super init];
    return self;
}

+ (instancetype)counterWithCompletion:(CDBErrorCompletion)completion {
    if (completion == nil) {
        return nil;
    }
    
    TBCounter * result = [[[self class] alloc] initInstance];
    result.state = TBCounterStateCounting;
    result.completion = completion;
    return result;
}

+ (instancetype)selfretainedCounterWithCompletion:(CDBErrorCompletion)completion {
    TBCounter * result = [self counterWithCompletion: completion];
    result.counterSelfRetain = result;
    return result;
}

/// MARK: - public -

- (void)noteExpectedTasksCount:(NSUInteger)count {
    if (self.state != TBCounterStateCounting
        && self.state != TBCounterStateFiredAndCounting) {
        return;
    }
    
    self.tasksCount += count;
    self.remainTasksCount += count;
    [self updateState];
}

- (void)noteTaskEndedWithError:(NSError *)error {
    self.error = error;
    [self noteTaskEnded];
}

- (void)noteTaskEnded {
    if (self.state != TBCounterStateCounting
        && self.state != TBCounterStateFiredAndCounting) {
        return;
    }
    
    self.remainTasksCount--;
    [self updateState];
}

- (void)noteTaskStarted {
    if (self.state != TBCounterStateCounting
        && self.state != TBCounterStateFiredAndCounting) {
        return;
    }
    
    self.tasksCount++;
    self.remainTasksCount++;
    [self updateState];
}

- (void)fire {
    if (self.state == TBCounterStateInvalidated
        || self.state == TBCounterStateFired) {
        return;
    }
    
    self.completion(self.error);
    
    if (self.shouldContinueAfterFire) {
        self.state = TBCounterStateFiredAndCounting;
        return;
    }
    
    self.state = TBCounterStateFired;
    self.counterSelfRetain = nil;
}

- (void)invalidate {
    self.state = TBCounterStateInvalidated;
}

/// MARK: - private -

- (void)updateState {
    if (self.remainTasksCount < 0) {
        NSLog(@"[Error] Task Counter note edded task before any could start!");
        NSAssert(NO, @"Task Counter note edded task before any could start");
    }
    
    if (self.remainTasksCount != 0) {
        return;
    }
    
    [self fire];
}

/// MARK description

- (NSString *)description {
    NSString * result =
        [NSString stringWithFormat: @"%@<%@> progress: %@/%@ (%@) selfretain: %@",
                                    NSStringFromClass([self class]),
                                    @(self.hash),
                                    @(self.completedTasksCount),
                                    @(self.tasksCount),
                                    @(self.progress),
                                    NSStringFromBool(self.counterSelfRetain)];
    
    return result;
}

@end
