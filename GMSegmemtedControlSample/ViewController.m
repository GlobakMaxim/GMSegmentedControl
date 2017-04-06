//
//  ViewController.m
//  GMSegmemtedControlSample
//
//  Created by Maxim Globak on 05.04.17.
//  Copyright © 2017 Maxim Globak. All rights reserved.
//

#import "ViewController.h"
#import "GMSegmentedControl.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISegmentedControl *sc = [[UISegmentedControl alloc] init];
    sc.selectedSegmentIndex = 0;
    
    NSArray *segments = @[@"fisrt", @"second", @"third"];
    GMSegmentedControl *segmentedControl = [[GMSegmentedControl alloc] initWithItems:segments];
    segmentedControl.frame = CGRectMake(0, 0, 300, 35);
    segmentedControl.center = self.view.center;
    
    [self.view addSubview:segmentedControl];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"0");
}


@end
