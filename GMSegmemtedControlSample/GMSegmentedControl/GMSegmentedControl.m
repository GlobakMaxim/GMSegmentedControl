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
        _items = items.copy;
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
    _thumb = [[UIView alloc] init];
    _thumb.frame = [self frameForLabelAtIndex:0];
    _thumb.backgroundColor = _tintColor;
}

- (void)setupGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:pan];
}

- (void)setupLabels {
    NSMutableArray *mutableLabels = [[NSMutableArray alloc] init];
    for (NSString *item in _items) {
        
        UILabel *itemLabel = [[UILabel alloc] init];
        itemLabel.text = item;
        itemLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:itemLabel];
        [mutableLabels addObject:itemLabel];
    }
    _labels = mutableLabels.copy;
}

- (void)setupFrames {
    for (int i = 0; i < _labels.count; i++) {
        _labels[i].frame = [self frameForLabelAtIndex:i];
    }
}

- (CGRect)frameForLabelAtIndex:(NSInteger)index {
    CGFloat labelWidth = (CGFloat)((float)self.bounds.size.width / (float)_labels.count);
    labelWidth = isnan(labelWidth) ? 0.0 : labelWidth;
    CGFloat labelHeight = self.bounds.size.height;
    
    CGFloat labelX = (float)labelWidth * (float)index;
    CGFloat labelY = 0;
    
    return CGRectMake(labelX, labelY, labelWidth, labelHeight);
}

- (CGRect)frameForThumbAtIndex:(NSInteger)index {
    return _labels[index].frame;
}

- (void)setSelectedSegmentIndex:(NSNumber *)selectedSegmentIndex {
    
    // Deselect item
    if ([_selectedSegmentIndex isEqualToNumber:selectedSegmentIndex]) {
        selectedSegmentIndex = nil;
    }
    
    // Check for correct range
    if (selectedSegmentIndex &&
        selectedSegmentIndex.integerValue > _items.count &&
        selectedSegmentIndex.integerValue < 0) {
        selectedSegmentIndex = nil;
    }
    
    if (selectedSegmentIndex) {
        if (_thumb.isHidden) {
            [self showThumbAtIndex:selectedSegmentIndex.integerValue];
        } else {
            [self moveThumbToIndex:selectedSegmentIndex.integerValue];
        }
    } else {
        [self hideThumb];
    }
}

#pragma mark - Thumb actions

- (void)showThumbAtIndex:(NSInteger)index {
    _thumb.frame = [self frameForThumbAtIndex:index];
    _thumb.hidden = NO;
    [UIView animateWithDuration:_animateWithDuration animations:^{
        _thumb.alpha = 1;
    }];
}

- (void)moveThumbToIndex:(NSInteger)index {
    [UIView animateWithDuration:_animateWithDuration animations:^{
        _thumb.frame = [self frameForThumbAtIndex:index];
    }];
}

- (void)hideThumb {
    [UIView animateWithDuration:_animateWithDuration animations:^{
        _thumb.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            _thumb.hidden = YES;
        }
    }];
}

#pragma mark - Gesture recognize

- (void)tapAction:(UITapGestureRecognizer *)recognizer {
    
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
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
