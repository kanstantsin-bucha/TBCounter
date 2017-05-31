//
//  TBTaskProcessor.h
//  QromaScan
//
//  Created by Bucha Kanstantsin on 3/16/17.
//  Copyright © 2017 Qroma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CDBKit/CDBKit.h>


typedef NS_ENUM(NSInteger, TBCounterState) {
    TBCounterStateUndefined = 0,
    TBCounterStateNoTasks = 1,
    TBCounterStateProcessingTasks = 2,
    TBCounterStateFinishedAllTasks = 3,
    TBCounterStateFiredAndStopped = 4,
    TBCounterStateInvalidated = 5
};

@interface TBCounter : NSObject

@property (assign, nonatomic, readonly) NSInteger remainTasksCount;
@property (assign, nonatomic, readonly) NSInteger completedTasksCount;
@property (assign, nonatomic, readonly) NSInteger tasksCount;

/**
 @brief: normalized progress 0 to 1.0
**/

@property (assign, nonatomic, readonly) float progress;

@property (strong, nonatomic, readonly, nonnull) CDBErrorCompletion completion;
/**
    @brief: will be called when counter note first task started
            if (shouldContinueAfterFire == YES) will be called each time 
            it started task after was fired
*/
@property (strong, nonatomic, nullable) CDBCompletion start;
@property (strong, nonatomic, readonly, nullable) NSError * error;

@property (assign, nonatomic, readonly) TBCounterState state;
@property (assign, nonatomic) BOOL shouldContinueAfterFire;


/**
 @brief: complition block will be called when all tasks will be finished
         with last acqiered error if any occured
 **/

+ (instancetype _Nullable)counterWithCompletion:(CDBErrorCompletion _Nonnull)completion;

/**
 @brief: counter will retain itself when first Task will be noted
         and release only after firing or invalidation
**/

+ (instancetype _Nullable)selfretainedCounterWithCompletion:(CDBErrorCompletion _Nonnull)completion;

/**
 @brief: call completion from current state
         and set remain tasks count to 0
**/

- (void)fire;

/**
 @brief: disable counter - never call completion again, release itself if retain
 **/

- (void)noteExpectedTasksCount:(NSUInteger)count;

- (void)noteTaskStarted;
- (void)noteTaskEnded;
- (void)noteTaskEndedWithError:(NSError * _Nullable)error;

@end
