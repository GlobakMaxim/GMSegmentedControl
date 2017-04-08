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
  [self setupDefaultValues];
  [self setupLabels];
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
  self.layer.borderWidth = 1;
  self.selectedSegmentIndex = NSNotFound;
  self.cornerType = GMSegmentedControlCornerType_default;
  self.backgroundColor = [UIColor clearColor];
  self.tintColor = [UIColor greenColor];
  self.animationDuration = 0.1;
  self.selectedItemTextColor = [UIColor darkGrayColor];
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
  NSMutableArray *mutableLabels = [[NSMutableArray alloc] init];
  for (NSString *item in self.items) {
    
    UILabel *itemLabel = [[UILabel alloc] init];
    itemLabel.text = item;
    itemLabel.textAlignment = NSTextAlignmentCenter;
    itemLabel.textColor = self.tintColor;
    
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

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex animated:(BOOL)animated {
  
  // Deselect item
  if (_selectedSegmentIndex == selectedSegmentIndex) {
    selectedSegmentIndex = NSNotFound;
  }
  
  // Check for correct range
  if (selectedSegmentIndex > self.items.count &&
      selectedSegmentIndex < 0) {
    selectedSegmentIndex = NSNotFound;
  }
  
  if (selectedSegmentIndex != NSNotFound) {
    [self setupThumbAtIndex:selectedSegmentIndex animated:animated];
  } else {
    [self hideThumbAnimated:animated];
  }
  
  _selectedSegmentIndex = selectedSegmentIndex;
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
  [UIView animateWithDuration:animationDuration animations:^{
    self.thumb.alpha = 1;
    [self updateLabelsTextColorAtIndex:index animated:animated];
  }];
}

- (void)moveThumbToIndex:(NSInteger)index animated:(BOOL)animated {
  NSTimeInterval animationDuration = animated ? self.animationDuration : 0;
  [UIView animateWithDuration:animationDuration animations:^{
    self.thumb.frame = [self frameForThumbAtIndex:index];
    [self updateLabelsTextColorAtIndex:index animated:animated];
  }];
}

- (void)hideThumbAnimated:(BOOL)animated {
  NSTimeInterval animationDuration = animated ? self.animationDuration : 0;
  [UIView animateWithDuration:animationDuration animations:^{
    self.thumb.alpha = 0;
    [self updateLabelsTextColorAtIndex:NSNotFound animated:animated];
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
      [self setSelectedSegmentIndex:i animated:YES];
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
    case UIGestureRecognizerStateChanged: {
      CGFloat delta = [recognizer locationInView:self].x - self.thumb.center.x;
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
  
  [UIView animateWithDuration:.05 animations:^{
    self.thumb.frame = newFrameThumb;
  }];
}

#pragma mark - Castomization

- (void)updateLabelsTextColorAtIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
  NSTimeInterval animationDuration = animated ? self.animationDuration : 0;
  [UIView animateWithDuration:animationDuration animations:^{
    for (int i = 0; i < self.labels.count; i++) {
      self.labels[i].textColor =
      (i == selectedIndex) ? self.selectedItemTextColor : self.tintColor;
    }
  }];
}

- (void)setSelectedItemTextColor:(UIColor *)selectedItemTextColor {
  _selectedItemTextColor = selectedItemTextColor;
  [self updateLabelsTextColorAtIndex:self.selectedSegmentIndex animated:NO];
}

- (void)setBorderColor:(UIColor *)borderColor {
  _borderColor = borderColor;
  self.layer.borderColor = borderColor.CGColor;
}

- (void)setTintColor:(UIColor *)tintColor {
  _tintColor = tintColor;
  
  [self updateLabelsTextColorAtIndex:self.selectedSegmentIndex animated:NO];
  self.thumb.backgroundColor = tintColor;
  if (!self.borderColor) {
    self.layer.borderColor = tintColor.CGColor;
  }
}

- (void)setCornerType:(GMSegmentedControlCornerType)cornerType {
  [self updateCornerRadiusWithType:cornerType];
  _cornerType = cornerType;
}

- (void)updateCornerRadiusWithType:(GMSegmentedControlCornerType)cornerType {
  CGFloat cornerRadius;
  switch (cornerType) {
    case GMSegmentedControlCornerType_default:
      cornerRadius = 0;
      break;
    case GMSegmentedControlCornerType_rounded1:
      cornerRadius = 4;
      break;
    case GMSegmentedControlCornerType_rounded2:
      cornerRadius = 8;
      break;
    case GMSegmentedControlCornerType_pill:
      cornerRadius = self.bounds.size.height / 2;
      break;
  }
  self.layer.cornerRadius = cornerRadius;
  self.thumb.layer.cornerRadius = cornerRadius;
}

@end
