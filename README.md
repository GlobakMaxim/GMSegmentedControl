# GMSegmentedControl

* Customization
* Swipeable
* Nullable (Able to deselect segment)

![Sample](./images/sample.gif)

## Installation

Cocoapods
```
pod 'GMSegmentedControl'
```

## Usage

```objective-c
  NSArray *segments = @[@"First", @"Second", @"Third"];
  
  GMSegmentedControl *segmentedControl = [[GMSegmentedControl alloc] initWithSegments:segments];
  segmentedControl.frame = CGRectMake(0, 0, 300, 40);
  segmentedControl.center = self.view.center;
  segmentedControl.cornerType = GMSegmentedControlCornerTypePill;
  [segmentedControl addTarget:self
                       action:@selector(segmentedControlValueChanged:)
             forControlEvents:UIControlEventValueChanged];

  [self.view addSubview:segmentedControl];
```

## Default settings

```objective-c
self.clipsToBounds = YES;
self.selectedSegmentIndex = NSNotFound;
self.cornerType = GMSegmentedControlCornerTypeDefault;
self.backgroundColor = [UIColor blueColor];
self.tintColor = [UIColor whiteColor];
self.thumbTextColor = [UIColor darkGrayColor];
self.animationDuration = 0.1;
self.enableDeselecting = YES;
```

## Corner radius

```objective-c
typedef NS_ENUM(NSInteger, GMSegmentedControlCornerType) {
  GMSegmentedControlCornerTypeDefault,    // cornerRadius = 0
  GMSegmentedControlCornerTypeRounded1,   // cornerRadius = 4
  GMSegmentedControlCornerTypeRounded2,   // cornerRadius = 8
  GMSegmentedControlCornerTypePill,       // cornerRadius = half height
};
```

* GMSegmentedControlCornerTypeDefault

![GMSegmentedControlCornerTypeDefault](./images/GMSegmentedControlCornerTypeDefault.png)

* GMSegmentedControlCornerTypeRounded1

![GMSegmentedControlCornerTypeRounded1](./images/GMSegmentedControlCornerTypeRounded1.png)

* GMSegmentedControlCornerTypeRounded2

![GMSegmentedControlCornerTypeRounded2](./images/GMSegmentedControlCornerTypeRounded2.png)

* GMSegmentedControlCornerTypePill

![GMSegmentedControlCornerTypePill](./images/GMSegmentedControlCornerTypePill.png)


## License

GMSegmentedControl is licensed under the terms of the MIT License. Please see the [LICENSE](./LICENSE.md) file for full details.