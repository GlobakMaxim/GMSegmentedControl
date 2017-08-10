//
//  ViewController.m
//  GMSegmentedControlSample
//
//  Created by Maxim Globak on 05.04.17.
//  Copyright © 2017 Maxim Globak. All rights reserved.
//

#import "ViewController.h"
#import "GMSegmentedControl.h"


@interface ViewController ()

@property (strong, nonatomic) IBOutlet GMSegmentedControl *segmentedControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *segments = @[@"First", @"Second", @"Third"];
    
    
    self.segmentedControl.segments = segments;
    self.segmentedControl.cornerType = GMSegmentedControlCornerTypePill;
    self.segmentedControl.backgroundColor = [UIColor colorWithRed:0.000 green:0.745 blue:0.486 alpha:1.00];
    self.segmentedControl.tintColor = [UIColor whiteColor];
    [self.segmentedControl addTarget:self
                              action:@selector(segmentedControlValueChanged:)
                    forControlEvents:UIControlEventValueChanged];
}

- (void)segmentedControlValueChanged:(GMSegmentedControl *)sender {
    NSLog(@"item = %i", (int)sender.selectedSegmentIndex);
}

@end
