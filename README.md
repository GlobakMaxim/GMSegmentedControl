# GMSegmentedControl

* Customization
* Swipeable
* Nullable (Able to deselect segment)

![Sample](./sample.gif)

## Usage

```objective-c
  NSArray *segments = @[@"First", @"Second", @"Third"];
  
  GMSegmentedControl *segmentedControl = [[GMSegmentedControl alloc] initWithItems:segments];
  segmentedControl.frame = CGRectMake(0, 0, 300, 40);
  segmentedControl.center = self.view.center;
  segmentedControl.cornerType = GMSegmentedControlCornerType_pill;
  segmentedControl.backgroundColor = [UIColor greenColor];
  segmentedControl.borderColor = [UIColor greenColor];
  segmentedControl.tintColor = [UIColor whiteColor];
  [segmentedControl addTarget:self
                       action:@selector(segmentedControlValueChanged:)
             forControlEvents:UIControlEventValueChanged];

  [self.view addSubview:segmentedControl];
```

## Default settings

```objective-c
  self.clipsToBounds = YES;
  self.layer.borderWidth = 1;
  self.selectedSegmentIndex = NSNotFound;
  self.cornerType = GMSegmentedControlCornerType_default;
  self.backgroundColor = [UIColor clearColor];
  self.tintColor = [UIColor greenColor];
  self.animationDuration = 0.1;
  self.selectedItemTextColor = [UIColor darkGrayColor];
```

## Corner radius

```objective-c
typedef NS_ENUM(NSInteger, GMSegmentedControlCornerType) {
  GMSegmentedControlCornerType_default, 	// cornerRadius = 0
  GMSegmentedControlCornerType_rounded1, 	// cornerRadius = 4
  GMSegmentedControlCornerType_rounded2, 	// cornerRadius = 8
  GMSegmentedControlCornerType_pill, 		// cornerRadius = half height
};
```