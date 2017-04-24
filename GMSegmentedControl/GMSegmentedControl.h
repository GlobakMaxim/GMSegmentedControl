//
//  GMSegmentedControl.h
//  GMSegmentedControlSample
//
//  Created by Maxim Globak on 05.04.17.
//  Copyright © 2017 Maxim Globak. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GMSegmentedControlCornerType) {
  GMSegmentedControlCornerType_default,
  GMSegmentedControlCornerType_rounded1,
  GMSegmentedControlCornerType_rounded2,
  GMSegmentedControlCornerType_pill,
};


@interface GMSegmentedControl : UIControl

@property (copy, nonatomic) NSArray <NSString *> *segments;
@property (assign, nonatomic, readonly) NSInteger selectedSegmentIndex;

- (void)selecteSegmentIndex:(NSInteger)selectedSegmentIndex animated:(BOOL)animated;

// Segments managment
- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segment;
- (void)removeSegmentAtIndex:(NSUInteger)segment;
- (void)removeAllSegments;
- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment;
- (NSString *)titleForSegmentAtIndex:(NSUInteger)segment;

// Castomization
@property (assign, nonatomic) GMSegmentedControlCornerType cornerType;
@property (assign, nonatomic) NSTimeInterval animationDuration;

// Tint color for thumb 
@property (strong, nonatomic) UIColor *tintColor;
@property (strong, nonatomic) UIColor *thumbTextColor;


- (instancetype)initWithSegments:(NSArray <NSString *> *)segments;
- (instancetype)initWithFrame:(CGRect)frame
                  andSegments:(NSArray <NSString *> *)segments;

@end
