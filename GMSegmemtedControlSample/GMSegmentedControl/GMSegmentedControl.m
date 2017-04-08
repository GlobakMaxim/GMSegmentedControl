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
  self.layer.borderWidth = 1;
  self.selectedSegmentIndex = NSNotFound;
  self.cornerType = GMSegmentedControlCornerType_default;
  self.backgroundColor = [UIColor clearColor];
  self.tintColor = [UIColor greenColor];
  self.animateWithDuration = 0.1;
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

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
  
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
    [self setupThumbAtIndex:selectedSegmentIndex];
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
    [self updateLabelsTextColorAtIndex:index];
  }];
}

- (void)moveThumbToIndex:(NSInteger)index {
  [UIView animateWithDuration:self.animateWithDuration animations:^{
    self.thumb.frame = [self frameForThumbAtIndex:index];
    [self updateLabelsTextColorAtIndex:index];
  }];
}

- (void)hideThumb {
  [UIView animateWithDuration:self.animateWithDuration animations:^{
    self.thumb.alpha = 0;
    [self updateLabelsTextColorAtIndex:NSNotFound];
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
      self.selectedSegmentIndex = i;
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

- (void)updateLabelsTextColorAtIndex:(NSInteger)selectedIndex {
  for (int i = 0; i < self.labels.count; i++) {
    self.labels[i].textColor =
    (i == selectedIndex) ? self.selectedItemTextColor : self.tintColor;
  }
}

- (void)setSelectedItemTextColor:(UIColor *)selectedItemTextColor {
  _selectedItemTextColor = selectedItemTextColor;
  [self updateLabelsTextColorAtIndex:self.selectedSegmentIndex];
}

- (void)setBorderColor:(UIColor *)borderColor {
  _borderColor = borderColor;
  self.layer.borderColor = borderColor.CGColor;
}

- (void)setTintColor:(UIColor *)tintColor {
  _tintColor = tintColor;
  
  [self updateLabelsTextColorAtIndex:self.selectedSegmentIndex];
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
