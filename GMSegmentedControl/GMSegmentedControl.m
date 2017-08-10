//
//  GMSegmentedControl.m
//
//  Created by Maxim Globak on 05.04.17.
//  Copyright © 2017 Maxim Globak. All rights reserved.
//

#import "GMSegmentedControl.h"

@interface GMSegmentedControl ()

@property (nonatomic, assign) NSInteger selectedSegmentIndex;
@property (nonatomic, copy) NSArray <UILabel *> *labels;
@property (nonatomic, strong) CALayer *thumb;

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

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithSegments:(NSArray <NSString *> *)segments {
    self = [super init];
    if (self) {
        self.segments = segments.copy;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andSegments:(NSArray <NSString *> *)segments {
    self = [super initWithFrame:frame];
    if (self) {
        self.segments = segments.copy;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self setupDefaultValues];
    [self setupFrames];
    [self setupThumb];
    [self setupGestureRecognizer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupFrames];
    [self updateThumbFrame];
    [self updateCornerRadiusWithType:self.cornerType];
}

- (void)setupDefaultValues {
    self.clipsToBounds = YES;
    self.selectedSegmentIndex = NSNotFound;
    self.cornerType = GMSegmentedControlCornerTypeDefault;
    self.backgroundColor = [UIColor clearColor];
    self.tintColor = [UIColor greenColor];
    self.thumbTextColor = [UIColor darkGrayColor];
    self.animationDuration = 0.1;
    self.enableDeselecting = YES;
}

- (void)setupThumb {
    self.thumb = [[CALayer alloc] init];
    self.thumb.backgroundColor = self.tintColor.CGColor;
    self.thumb.opacity = 0;
    self.thumb.hidden = YES;
    [self.layer addSublayer:self.thumb];
    
    if (self.labels.count > 0) {
        self.thumb.frame = self.labels.firstObject.frame;
    } else {
        self.thumb.frame = self.bounds;
    }
}

- (void)updateThumbFrame {
    if (self.selectedSegmentIndex != NSNotFound) {
        self.thumb.frame = [self frameForThumbAtIndex:self.selectedSegmentIndex];
    }
}

- (void)setupGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:pan];
}

- (void)setupLabels {
    // Remove All labels if needed
    [self removeAllLabels];
    
    NSMutableArray *mutableLabels = [[NSMutableArray alloc] init];
    for (NSString *segment in self.segments) {
        
        UILabel *segmentLabel = [[UILabel alloc] init];
        segmentLabel.text = segment;
        segmentLabel.textAlignment = NSTextAlignmentCenter;
        segmentLabel.textColor = self.tintColor;
        
        [self addSubview:segmentLabel];
        [mutableLabels addObject:segmentLabel];
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
    return CGRectInset(self.labels[index].frame, 2, 2);
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
    if (_selectedSegmentIndex != selectedSegmentIndex) {
        _selectedSegmentIndex = selectedSegmentIndex;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)selecteSegmentIndex:(NSInteger)selectedSegmentIndex animated:(BOOL)animated {
    // Deselect item
    if (self.selectedSegmentIndex == selectedSegmentIndex && self.enableDeselecting) {
        selectedSegmentIndex = NSNotFound;
    }
    
    // Check for correct range
    BOOL incorrectRange = (selectedSegmentIndex > self.segments.count && selectedSegmentIndex < 0);
    if (incorrectRange) {
        selectedSegmentIndex = NSNotFound;
    }
    
    if (selectedSegmentIndex != NSNotFound) {
        [self setupThumbAtIndex:selectedSegmentIndex animated:animated];
    } else {
        [self hideThumbAnimated:animated];
    }
    
    self.selectedSegmentIndex = selectedSegmentIndex;
}

#pragma mark - Thumb actions

- (void)setupThumbAtIndex:(NSInteger)index animated:(BOOL)animated {
    if (self.thumb.isHidden) {
        [self showThumbAtIndex:index animated:animated];
    } else {
        [self moveThumbToIndex:index animated:animated];
    }
}

- (void)showThumbAtIndex:(NSInteger)index animated:(BOOL)animated {
    self.thumb.frame = [self frameForThumbAtIndex:index];
    self.thumb.hidden = NO;
    
    if (animated) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:self.animationDuration animations:^{
            weakSelf.thumb.opacity = 1;
            [weakSelf updateLabelsTextColorAtIndex:index animated:NO];
        }];
    } else {
        self.thumb.opacity = 1;
        [self updateLabelsTextColorAtIndex:index animated:NO];
    }
}

- (void)moveThumbToIndex:(NSInteger)index animated:(BOOL)animated {
    self.thumb.frame = [self frameForThumbAtIndex:index];
    [self updateLabelsTextColorAtIndex:index animated:animated];
}

- (void)hideThumbAnimated:(BOOL)animated {
    if (animated) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:self.animationDuration animations:^{
            weakSelf.thumb.opacity = 0;
            [weakSelf updateLabelsTextColorAtIndex:NSNotFound animated:animated];
        } completion:^(BOOL finished) {
            weakSelf.thumb.hidden = finished;
        }];
    } else {
        self.thumb.opacity = 0;
        [self updateLabelsTextColorAtIndex:NSNotFound animated:animated];
        self.thumb.hidden = YES;
    }
}

#pragma mark - Items managment

- (void)setSegments:(NSArray<NSString *> *)segments {
    _segments = segments;
    
    // Hide Segment control if it hasn't any items
    self.hidden = (segments.count == 0);
    
    [self setupLabels];
}

- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segment {
    NSMutableArray *newSegments = [[NSMutableArray alloc] initWithArray:self.segments];
    if (segment < self.segments.count) {
        [newSegments insertObject:title atIndex:segment];
    } else {
        [newSegments addObject:title];
    }
    self.segments = newSegments.copy;
}

- (void)removeSegmentAtIndex:(NSUInteger)segment {
    if (segment < self.segments.count) {
        NSMutableArray *newSegments = [[NSMutableArray alloc] initWithArray:self.segments];
        [newSegments removeObjectAtIndex:segment];
        self.segments = newSegments.copy;
    }
}

- (void)removeAllSegments {
    [self removeAllLabels];
    self.segments = nil;
}

- (void)removeAllLabels {
    for (UILabel *label in self.labels) {
        [label removeFromSuperview];
    }
    self.labels = nil;
}

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment {
    if (segment < self.segments.count) {
        NSMutableArray *newSegments = [[NSMutableArray alloc] initWithArray:self.segments];
        [newSegments replaceObjectAtIndex:segment withObject:title];
        self.segments = newSegments.copy;
    }
}

- (NSString *)titleForSegmentAtIndex:(NSUInteger)segment {
    return segment < self.segments.count ? self.segments[segment] : nil;
}

#pragma mark - Gesture recognize

- (void)tapAction:(UIGestureRecognizer *)recognizer {
    CGPoint touchPoint = [recognizer locationInView:self];
    NSInteger labelIndex = [self labelIndexInPoint:touchPoint];
    if (labelIndex != NSNotFound) {
        [self selecteSegmentIndex:labelIndex animated:YES];
    }
}

- (void)handlePan:(UIGestureRecognizer *)recognizer {
    if (!self.enabled) {
        return;
    }
    
    CGPoint location = [recognizer locationInView:self];
    switch (recognizer.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan:
            [self startTumbInPoint:location];
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat delta = location.x - CGRectGetMidX(self.thumb.frame);
            [self dragThumbWithDeltaX:delta];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            self.selectedSegmentIndex = [self labelIndexInFrame:self.thumb.frame];
            [self moveThumbToIndex:self.selectedSegmentIndex animated:YES];
        }
            break;
    }
}

- (void)startTumbInPoint:(CGPoint)point {
    NSInteger labelIndex = [self labelIndexInPoint:point];
    if (labelIndex != NSNotFound) {
        [self setupThumbAtIndex:labelIndex animated:YES];
    }
}

- (void)dragThumbWithDeltaX:(CGFloat)delta {
    CGRect newFrameThumb = self.thumb.frame;
    newFrameThumb.origin.x += delta;
    
    CGFloat maxXThumb = CGRectGetMaxX(newFrameThumb);
    CGFloat minXThumb = CGRectGetMinX(newFrameThumb);
    CGFloat maxXView = CGRectGetMaxX(self.bounds);
    CGFloat minXView = CGRectGetMinX(self.bounds);
    
    if (maxXThumb > maxXView) {
        newFrameThumb.origin.x = maxXView - CGRectGetWidth(newFrameThumb);
    } else if (minXThumb < minXView) {
        newFrameThumb.origin.x = minXView;
    }
    
    NSInteger index = [self labelIndexInFrame:newFrameThumb];
    [self updateLabelsTextColorAtIndex:index animated:YES];
    
    [CATransaction setDisableActions:YES];
    self.thumb.frame = newFrameThumb;
}

- (NSInteger)labelIndexInPoint:(CGPoint)point {
    for (NSInteger i = 0; i < self.labels.count; i++) {
        CGRect labelRect = self.labels[i].frame;
        if (CGRectContainsPoint(labelRect, point)) {
            return i;
        }
    }
    return NSNotFound;
}

- (NSInteger)labelIndexInFrame:(CGRect)frame {
    CGFloat midX = CGRectGetMidX(frame);
    CGFloat midY = CGRectGetMidY(frame);
    CGPoint center = CGPointMake(midX, midY);
    return [self labelIndexInPoint:center];
}
#pragma mark - Castomization

- (void)updateLabelsTextColorAtIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    for (int i = 0; i < self.labels.count; i++) {
        UIColor *textColor = (i == selectedIndex) ? self.thumbTextColor : self.tintColor;
        [self updateLabel:self.labels[i] color:textColor animated:animated];
    }
}

- (void)updateLabel:(UILabel *)label color:(UIColor *)color animated:(BOOL)animated {
    NSTimeInterval animationDuration = animated ? self.animationDuration : 0;
    [UIView transitionWithView:label
                      duration:animationDuration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        label.textColor = color;
                    } completion:nil];
}

- (void)setThumbTextColor:(UIColor *)thumbTextColor {
    _thumbTextColor = thumbTextColor;
    [self updateLabelsTextColorAtIndex:self.selectedSegmentIndex animated:NO];
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    
    [self updateLabelsTextColorAtIndex:self.selectedSegmentIndex animated:NO];
    self.thumb.backgroundColor = tintColor.CGColor;
}

- (void)setCornerType:(GMSegmentedControlCornerType)cornerType {
    [self updateCornerRadiusWithType:cornerType];
    _cornerType = cornerType;
}

- (void)updateCornerRadiusWithType:(GMSegmentedControlCornerType)cornerType {
    CGFloat cornerRadius;
    CGFloat thumbCornerRadius;
    switch (cornerType) {
        case GMSegmentedControlCornerTypeDefault:
            cornerRadius = 0;
            thumbCornerRadius = 0;
            break;
        case GMSegmentedControlCornerTypeRounded1:
            cornerRadius = 4;
            thumbCornerRadius = 4;
            break;
        case GMSegmentedControlCornerTypeRounded2:
            cornerRadius = 8;
            thumbCornerRadius = 8;
            break;
        case GMSegmentedControlCornerTypePill:
            cornerRadius = self.bounds.size.height / 2;
            thumbCornerRadius = self.thumb.bounds.size.height / 2;
            break;
    }
    self.layer.cornerRadius = cornerRadius;
    self.thumb.cornerRadius = thumbCornerRadius;
}

@end
