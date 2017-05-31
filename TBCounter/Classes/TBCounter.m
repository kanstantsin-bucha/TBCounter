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

@property (assign, nonatomic, readonly) BOOL finished;
@property (assign, nonatomic, readonly) BOOL shouldLaunch;

@end


@implementation TBCounter

- (BOOL)finished {
    BOOL result = self.state == TBCounterStateFiredAndStopped
                    || self.state == TBCounterStateInvalidated;
    return result;
}

- (BOOL)shouldLaunch {
    BOOL result = self.state == TBCounterStateNoTasks
                  || self.state == TBCounterStateFinishedAllTasks;
    return result;
}

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
    result.state = TBCounterStateNoTasks;
    result.completion = completion;
    return result;
}

+ (instancetype)selfretainedCounterWithCompletion:(CDBErrorCompletion)completion {
    TBCounter * result = [self counterWithCompletion: completion];
    result.counterSelfRetain = result;
    return result;
}

/// MARK: - public -

- (void)noteTaskStarted {
    if (self.finished) {
        return;
    }
    
    if (self.shouldLaunch) {
       [self makeLaunch];
    }
    
    self.tasksCount++;
    self.remainTasksCount++;
    [self updateState];
}

- (void)noteExpectedTasksCount:(NSUInteger)count {
    if (self.finished) {
        return;
    }
    
    if (self.shouldLaunch) {
       [self makeLaunch];
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
    if (self.finished) {
        return;
    }
    
    self.remainTasksCount--;
    [self updateState];
}

- (void)fire {
    if (self.finished) {
        return;
    }
    
    self.completion(self.error);
    self.remainTasksCount = 0;
    
    if (self.shouldContinueAfterFire) {
        self.state = TBCounterStateFinishedAllTasks;
        return;
    }
    
    self.state = TBCounterStateFiredAndStopped;
    self.counterSelfRetain = nil;
}

- (void)makeLaunch {
     if (self.start == nil) {
        return;
     }
     self.start();
}

- (void)invalidate {
    self.state = TBCounterStateInvalidated;
    self.counterSelfRetain = nil;
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
