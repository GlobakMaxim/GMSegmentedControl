//
//  GMSegmentedControl.m
//  GMSegmentedControlSample
//
//  Created by Maxim Globak on 05.04.17.
//  Copyright © 2017 Maxim Globak. All rights reserved.
//

#import "GMSegmentedControl.h"

@interface GMSegmentedControl ()

@property (assign, nonatomic) NSInteger selectedSegmentIndex;
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
  [self updateCornerRadiusWithType:self.cornerType];
}

- (void)setupDefaultValues {
  self.clipsToBounds = YES;
  self.selectedSegmentIndex = NSNotFound;
  self.cornerType = GMSegmentedControlCornerType_default;
  self.backgroundColor = [UIColor clearColor];
  self.tintColor = [UIColor greenColor];
  self.thumbTextColor = [UIColor darkGrayColor];
  self.animationDuration = 0.1;
}

- (void)setupThumb {
  self.thumb = [[UIView alloc] init];
  self.thumb.backgroundColor = self.tintColor;
  self.thumb.hidden = YES;
  [self insertSubview:self.thumb atIndex:0];
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

- (void)selecteSegmentIndex:(NSInteger)selectedSegmentIndex animated:(BOOL)animated {
  
  // Deselect item
  if (_selectedSegmentIndex == selectedSegmentIndex) {
    selectedSegmentIndex = NSNotFound;
  }
  
  // Check for correct range
  if (selectedSegmentIndex > self.segments.count &&
      selectedSegmentIndex < 0) {
    selectedSegmentIndex = NSNotFound;
  }
  
  if (selectedSegmentIndex != NSNotFound) {
    [self setupThumbAtIndex:selectedSegmentIndex animated:animated];
  } else {
    [self hideThumbAnimated:animated];
  }
  
  _selectedSegmentIndex = selectedSegmentIndex;
  [self sendActionsForControlEvents:UIControlEventValueChanged];
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
  NSTimeInterval animationDuration = animated ? self.animationDuration : 0;
  self.thumb.frame = [self frameForThumbAtIndex:index];
  self.thumb.hidden = NO;
  
  __weak typeof(self) weakSelf = self;
  [UIView animateWithDuration:animationDuration animations:^{
    weakSelf.thumb.alpha = 1;
    [weakSelf updateLabelsTextColorAtIndex:index animated:animated];
  }];
}

- (void)moveThumbToIndex:(NSInteger)index animated:(BOOL)animated {
  NSTimeInterval animationDuration = animated ? self.animationDuration : 0;
  
  __weak typeof(self) weakSelf = self;
  [UIView animateWithDuration:animationDuration animations:^{
    weakSelf.thumb.frame = [weakSelf frameForThumbAtIndex:index];
    [weakSelf updateLabelsTextColorAtIndex:index animated:animated];
  }];
}

- (void)hideThumbAnimated:(BOOL)animated {
  NSTimeInterval animationDuration = animated ? self.animationDuration : 0;
  
  __weak typeof(self) weakSelf = self;
  [UIView animateWithDuration:animationDuration animations:^{
    weakSelf.thumb.alpha = 0;
    [weakSelf updateLabelsTextColorAtIndex:NSNotFound animated:animated];
  } completion:^(BOOL finished) {
    if (finished) {
      weakSelf.thumb.hidden = YES;
    }
  }];
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
  for (int i = 0; i < self.labels.count; i++) {
    CGRect labelRect = self.labels[i].frame;
    if (CGRectContainsPoint(labelRect, touchPoint)) {
      [self selecteSegmentIndex:i animated:YES];
      break;
    }
  }
}

- (void)handlePan:(UIGestureRecognizer *)recognizer {
  CGPoint location = [recognizer locationInView:self];
  switch (recognizer.state) {
    case UIGestureRecognizerStatePossible:
      break;
    case UIGestureRecognizerStateBegan:
      [self startTumbInPoint:location];
      break;
    case UIGestureRecognizerStateChanged: {
      CGFloat delta = location.x - self.thumb.center.x;
      [self dragThumbWithDeltaX:delta];
    }
      break;
    case UIGestureRecognizerStateEnded:
    case UIGestureRecognizerStateCancelled:
    case UIGestureRecognizerStateFailed:
      [self moveThumbToIndex:self.selectedSegmentIndex animated:YES];
      break;
  }
}

- (void)startTumbInPoint:(CGPoint)point {
  for (int i = 0; i < self.labels.count; i++) {
    CGRect labelRect = self.labels[i].frame;
    if (CGRectContainsPoint(labelRect, point)) {
      [self setupThumbAtIndex:i animated:YES];
      break;
    }
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
  
  CGPoint newCeter = CGPointMake(CGRectGetMidX(newFrameThumb), CGRectGetMidY(newFrameThumb));
  for (int i = 0; i < self.labels.count; i++) {
    if (CGRectContainsPoint(self.labels[i].frame, newCeter)) {
      if (self.selectedSegmentIndex != i) {
        self.selectedSegmentIndex = i;
        [self updateLabelsTextColorAtIndex:i animated:YES];
      }
    }
  }
  
  __weak typeof(self) weakSelf = self;
  [UIView animateWithDuration:.05 animations:^{
    weakSelf.thumb.frame = newFrameThumb;
  }];
}

#pragma mark - Castomization

- (void)updateLabelsTextColorAtIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
  NSTimeInterval animationDuration = animated ? self.animationDuration : 0;
  
  for (int i = 0; i < self.labels.count; i++) {
    
    [UIView
     transitionWithView:self.labels[i]
     duration:animationDuration
     options:UIViewAnimationOptionTransitionCrossDissolve
     animations:^{
       self.labels[i].textColor =
       (i == selectedIndex) ? self.thumbTextColor : self.tintColor;
     } completion:^(BOOL finished) {
     }];
  }
}

- (void)setThumbTextColor:(UIColor *)thumbTextColor {
  _thumbTextColor = thumbTextColor;
  [self updateLabelsTextColorAtIndex:self.selectedSegmentIndex animated:NO];
}

- (void)setTintColor:(UIColor *)tintColor {
  _tintColor = tintColor;
  
  [self updateLabelsTextColorAtIndex:self.selectedSegmentIndex animated:NO];
  self.thumb.backgroundColor = tintColor;
}

- (void)setCornerType:(GMSegmentedControlCornerType)cornerType {
  [self updateCornerRadiusWithType:cornerType];
  _cornerType = cornerType;
}

- (void)updateCornerRadiusWithType:(GMSegmentedControlCornerType)cornerType {
  CGFloat cornerRadius;
  CGFloat thumbCornerRadius;
  switch (cornerType) {
    case GMSegmentedControlCornerType_default:
      cornerRadius = 0;
      thumbCornerRadius = 0;
      break;
    case GMSegmentedControlCornerType_rounded1:
      cornerRadius = 4;
      thumbCornerRadius = 4;
      break;
    case GMSegmentedControlCornerType_rounded2:
      cornerRadius = 8;
      thumbCornerRadius = 8;
      break;
    case GMSegmentedControlCornerType_pill:
      cornerRadius = self.bounds.size.height / 2;
      thumbCornerRadius = self.thumb.bounds.size.height / 2;
      break;
  }
  self.layer.cornerRadius = cornerRadius;
  self.thumb.layer.cornerRadius = thumbCornerRadius;
}

@end
