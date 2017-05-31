//
//  TBViewController.m
//  TBCounter
//
//  Created by truebucha on 03/25/2017.
//  Copyright (c) 2017 truebucha. All rights reserved.
//

#import "TBViewController.h"
#import <TBCounter/TBCounter.h>

@interface TBViewController ()

@property (strong, nonatomic) TBCounter * counter;

@end

@implementation TBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.counter = [TBCounter counterWithCompletion:^(NSError * _Nullable error) {
        NSLog(@"You are watching view now!");
    }];
    
    self.counter.start = ^{
        NSLog(@"Start counting!");
    };
    
    [self.counter noteExpectedTasksCount: 2];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    NSLog(@"view will appear!");
    [self.counter noteTaskEnded];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    NSLog(@"view did appear!");
    [self.counter noteTaskEnded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
