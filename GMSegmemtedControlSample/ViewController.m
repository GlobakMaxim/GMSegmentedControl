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
  
  NSArray *segments = @[@"First", @"Second", @"Third"];
  
    UISegmentedControl *sc = [[UISegmentedControl alloc] initWithItems:segments];
    
  GMSegmentedControl *segmentedControl = [[GMSegmentedControl alloc] initWithItems:segments];
  segmentedControl.frame = CGRectMake(0, 0, 300, 40);
  segmentedControl.center = self.view.center;
  segmentedControl.cornerType = GMSegmentedControlCornerType_pill;
  segmentedControl.backgroundColor = [UIColor colorWithRed:0.000 green:0.745 blue:0.486 alpha:1.00];
  segmentedControl.tintColor = [UIColor whiteColor];
  [segmentedControl addTarget:self
                       action:@selector(segmentedControlValueChanged:)
             forControlEvents:UIControlEventValueChanged];

  
  [self.view addSubview:segmentedControl];
}

- (void)segmentedControlValueChanged:(GMSegmentedControl *)sender {
  NSLog(@"item = %i", (int)sender.selectedSegmentIndex);
}

@end
