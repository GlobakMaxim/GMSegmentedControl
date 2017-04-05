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
    _items = items.copy;
    [self commonInit];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame andItems:(NSArray <NSString *> *)items {
  self = [super initWithFrame:frame];
  if (self) {
    _items = items;
    [self commonInit];
  }
  return self;
}

- (void)commonInit {
  [self setupLabels];
  [self setupFrames];
}

- (void)setupLabels {
  NSMutableArray *mutableLabels = [[NSMutableArray alloc] init];
  for (NSString *item in _items) {
    UILabel *itemLabel = [[UILabel alloc] init];
    itemLabel.text = item;
    [mutableLabels addObject:itemLabel];
  }
  _labels = mutableLabels.copy;
}

- (void)setupFrames {
  
  CGFloat labelWidth = CGRect(Float(CGRectGetWidth(self.bounds)) / Float(_labels.count));
  CGFloat labelHeight
}



@end
