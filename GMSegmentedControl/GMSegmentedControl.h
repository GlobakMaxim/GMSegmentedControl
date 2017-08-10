//
//  GMSegmentedControl.h
//
//  Created by Maxim Globak on 05.04.17.
//  Copyright © 2017 Maxim Globak. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GMSegmentedControlCornerType) {
    GMSegmentedControlCornerTypeDefault,
    GMSegmentedControlCornerTypeRounded1,
    GMSegmentedControlCornerTypeRounded2,
    GMSegmentedControlCornerTypePill,
};

@interface GMSegmentedControl : UIControl

- (instancetype)initWithSegments:(NSArray <NSString *> *)segments;
- (instancetype)initWithFrame:(CGRect)frame andSegments:(NSArray <NSString *> *)segments;

@property (nonatomic, copy) NSArray <NSString *> *segments;
@property (nonatomic, readonly, assign) NSInteger selectedSegmentIndex;
@property (nonatomic, assign) BOOL enableDeselecting;

- (void)selecteSegmentIndex:(NSInteger)selectedSegmentIndex animated:(BOOL)animated;

// Segments managment
- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segment;
- (void)removeSegmentAtIndex:(NSUInteger)segment;
- (void)removeAllSegments;
- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment;
- (NSString *)titleForSegmentAtIndex:(NSUInteger)segment;

// Castomization
@property (nonatomic, assign) GMSegmentedControlCornerType cornerType;
@property (nonatomic, assign) NSTimeInterval animationDuration;

// Tint color for thumb
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *thumbTextColor;

@end
