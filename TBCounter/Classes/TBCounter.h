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
    TBCounterStateCounting = 1,
    TBCounterStateFired = 2,
    TBCounterStateFiredAndCounting = 3,
    TBCounterStateInvalidated = 4
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
@property (strong, nonatomic, readonly, nullable) NSError * error;

@property (assign, nonatomic, readonly) TBCounterState state;
@property (assign, nonatomic, readonly) BOOL shouldContinueAfterFire;


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
         and don't call it when counter reach all task finished state
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
