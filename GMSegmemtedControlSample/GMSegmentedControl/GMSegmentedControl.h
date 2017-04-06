//
//  GMSegmentedControl.h
//  GMSegmemtedControlSample
//
//  Created by Maxim Globak on 05.04.17.
//  Copyright © 2017 Maxim Globak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMSegmentedControl : UIControl

@property (copy, nonatomic) NSArray <NSString *> *items;
@property (strong, nonatomic) NSNumber *selectedSegmentIndex; // Able to be nil

// Castomization
@property (strong, nonatomic) UIColor *tintColor;
@property (strong, nonatomic) UIColor *color;
@property (assign, nonatomic) NSTimeInterval animateWithDuration;



- (instancetype)initWithItems:(NSArray <NSString *> *)items;
- (instancetype)initWithFrame:(CGRect)frame
                     andItems:(NSArray <NSString *> *)items;

@end
