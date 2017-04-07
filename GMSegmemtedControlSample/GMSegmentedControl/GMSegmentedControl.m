//
//  GMSegmentedControl.m
//  GMSegmemtedControlSample
//
//  Created by Maxim Globak on 05.04.17.
//  Copyright © 2017 Maxim Globak. All rights reserved.
//

#import "GMSegmentedControl.h"

@interface GMSegmentedControl ()

@property (copy, nonatomic) NSArray <UILabel *> *labels;
@property (strong, nonatomic) UIView *thumb;

@end

@implementation GMSegmentedControl

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithItems:(NSArray <NSString *> *)items {
    self = [super init];
    if (self) {
        self.items = items.copy;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andItems:(NSArray <NSString *> *)items {
    self = [super initWithFrame:frame];
    if (self) {
        self.items = items.copy;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self setupLabels];
    [self setupFrames];
    [self setupThumb];
    [self setupGestureRecognizer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupFrames];
}

- (void)setupThumb {
    self.thumb = [[UIView alloc] init];
    self.thumb.backgroundColor = self.tintColor;
    [self insertSubview:self.thumb atIndex:0];
}

- (void)setupGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:pan];
}

- (void)setupLabels {
    NSMutableArray *mutableLabels = [[NSMutableArray alloc] init];
    for (NSString *item in self.items) {
        
        UILabel *itemLabel = [[UILabel alloc] init];
        itemLabel.text = item;
        itemLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:itemLabel];
        [mutableLabels addObject:itemLabel];
    }
    self.labels = mutableLabels.copy;
}

- (void)setupFrames {
    for (int i = 0; i < self.labels.count; i++) {
        self.labels[i].frame = [self frameForLabelAtIndex:i];
    }
}

- (CGRect)frameForLabelAtIndex:(NSInteger)index {
    CGFloat labelWidth = (CGFloat)((float)self.bounds.size.width / (float)self.labels.count);
    labelWidth = isnan(labelWidth) ? 0.0 : labelWidth;
    CGFloat labelHeight = self.bounds.size.height;
    
    CGFloat labelX = (float)labelWidth * (float)index;
    CGFloat labelY = 0;
    
    return CGRectMake(labelX, labelY, labelWidth, labelHeight);
}

- (CGRect)frameForThumbAtIndex:(NSInteger)index {
    return self.labels[index].frame;
}

- (void)setSelectedSegmentIndex:(NSNumber *)selectedSegmentIndex {
    
    // Deselect item
    if ([_selectedSegmentIndex isEqualToNumber:selectedSegmentIndex]) {
        selectedSegmentIndex = nil;
    }
    
    // Check for correct range
    if (selectedSegmentIndex &&
        selectedSegmentIndex.integerValue > self.items.count &&
        selectedSegmentIndex.integerValue < 0) {
        selectedSegmentIndex = nil;
    }
    
    if (selectedSegmentIndex) {
        [self setupThumbAtIndex:selectedSegmentIndex.integerValue];
    } else {
        [self hideThumb];
    }
    _selectedSegmentIndex = selectedSegmentIndex;
}

#pragma mark - Thumb actions

- (void)setupThumbAtIndex:(NSInteger)index {
    if (self.thumb.isHidden) {
        [self showThumbAtIndex:index];
    } else {
        [self moveThumbToIndex:index];
    }
}

- (void)showThumbAtIndex:(NSInteger)index {
    self.thumb.frame = [self frameForThumbAtIndex:index];
    self.thumb.hidden = NO;
    [UIView animateWithDuration:self.animateWithDuration animations:^{
        self.thumb.alpha = 1;
    }];
}

- (void)moveThumbToIndex:(NSInteger)index {
    [UIView animateWithDuration:self.animateWithDuration animations:^{
        self.thumb.frame = [self frameForThumbAtIndex:index];
    }];
}

- (void)hideThumb {
    [UIView animateWithDuration:self.animateWithDuration animations:^{
        self.thumb.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.thumb.hidden = YES;
        }
    }];
}

#pragma mark - Gesture recognize

- (void)tapAction:(UITapGestureRecognizer *)recognizer {
    CGPoint touchPoint = [recognizer locationInView:self];
    
    for (int i = 0; i < self.labels.count; i++) {
        CGRect labelRect = self.labels[i].frame;
        if (CGRectContainsPoint(labelRect, touchPoint)) {
            self.selectedSegmentIndex = @(i);
            break;
        }
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            break;
        case UIGestureRecognizerStateEnded:
            break;
        case UIGestureRecognizerStateCancelled:
            break;
        case UIGestureRecognizerStateFailed:
            break;
    }
}

#pragma mark - Castomization

- (UIColor *)tintColor {
    if (!_tintColor) {
        _tintColor = [UIColor redColor];
    }
    return _tintColor;
}

- (UIColor *)color {
    if (!_color) {
        _color = [UIColor greenColor];
    }
    return _color;
}

- (NSTimeInterval)animateWithDuration {
    if (!_animateWithDuration) {
        _animateWithDuration = 0.1;
    }
    return _animateWithDuration;
}


@end
