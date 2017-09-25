//
//  ViewController.m
//  GMSegmentedControlSample
//
//  Created by Globak Maxim on 25/09/2017.
//  Copyright © 2017 Globak Maxim. All rights reserved.
//

#import "ViewController.h"
#import "GMSegmentedControl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *segments = @[@"First", @"Second", @"Third"];
    
    GMSegmentedControl *segmentedControl = [[GMSegmentedControl alloc] initWithSegments:segments];
    segmentedControl.frame = CGRectMake(0, 0, 300, 40);
    segmentedControl.center = self.view.center;
    segmentedControl.cornerType = GMSegmentedControlCornerTypePill;
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segmentedControl];
}

- (void)segmentedControlValueChanged:(GMSegmentedControl *)sender {
    NSLog(@"GMSegmentedControl selected index is %li", (long)sender.selectedSegmentIndex);
}

@end
