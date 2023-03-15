# BRKit

[![CI Status](https://img.shields.io/travis/SunOfDUT/BRKit.svg?style=flat)](https://travis-ci.org/SunOfDUT/BRKit)
[![Version](https://img.shields.io/cocoapods/v/BRKit.svg?style=flat)](https://cocoapods.org/pods/BRKit)
[![License](https://img.shields.io/cocoapods/l/BRKit.svg?style=flat)](https://cocoapods.org/pods/BRKit)
[![Platform](https://img.shields.io/cocoapods/p/BRKit.svg?style=flat)](https://cocoapods.org/pods/BRKit)

> The New package use to simplify our project code



To run the example project, clone the repo, and run `pod install` from the Example directory first.

****

**The package will always be updated**
[TOC]


## 1.BRComponent

### 1.1 BRTabBarController

> BRTabBarController is inherit form UITabBarController

```Objective-c

/// the sturctre use to collect all of message which will be used in initialize
struct BRTabBarControllerDataSource{
    /// the tabBar title array
    NSArray<NSString *> *titlearray;
    /// the tabBar icon array
    NSArray<NSString *> *iconarray;
    /// the tabBar selected icon array
    NSArray<NSString *> *selectediconarray;
    /// the tabBarconrtoller childviewcontrollers
    NSArray<NSString *> *viewcontrollers;
    /// the style of tabBar
    BRTabBarStyleConfig config;
};

/**
 * The Custom Method to AddChildController And BarItem
 * @param childController the newcontroller
 * @param item the new BarItem
 * @param tag the new item tag
 * @param allcount  the item total count
 * @param type  the type of item
 */
-(void)addChildViewController:(UIViewController *)childController tabBarItem:(BRTabBarItem *)item tag:(NSInteger)tag allcount:(NSInteger)allcount ItemType:(BRTabBarItemType)type;

/**
 * The Method use to initialize TabBar And ChildController
 * @param items the items add to BarItem
 * @param viewcontrollers the controllers add to childController
 * @param isProtrude the custonButton is protrude
 */
-(void)initSubViewsTabBar:(NSArray<BRTabBarItem*>*)items viewcontrollers:(NSArray<NSString*>*)viewcontrollers isProtrude:(BOOL)isProtrude;

/// The CustomTabBar for tabBarcontroller
@property (nonatomic,strong) BRTabBar *customBar;

```

+ **addChildViewController** : you can use this method to add a newChildViewController,and also add a tabBaritem which is corresponding to newChildViewController

+ **initSubViewsTabBar**:you can use this method to initialize TabBar and ChildviewControllers by setting param1 'items' and param2 'viewcontrollers',this method is necessary to use to custom your own tabBarcontroller.if you want to custom your own initialize method,you can override this method in your subclass. 

+ **BRTabBarControllerDataSource**: the BRTabBarControllerDataSource is a custom structure,this config is use to initialize BRTabBarController



#### 1.1.1 BRTabBar
> BRTabBar is inherit form UITabBar
```Objective-c
/// The Type of BRTabBarItem
typedef NS_ENUM(NSInteger,BRTabBarItemType){
    /// normal type
    BRTabBarItemDefalut = 0,
    /// custom type
    BRTabBarItemCustom = 1,
    /// protrude type
    BRTabBarItemProtrude = 2,
};
/**
 *Use TabBarItem to initialize
 *@param items the item for tabbar
 */
- (instancetype)initWithTabBarItem:(NSArray<BRTabBarItem *> *)items;

/**
 *The Method use to AddBarItem
 *@param item the new item
 *@param tag the currentItem tag
 *@param allcount all of the items count
 *@param type the type of BarItem
 */
-(void)addTabBarItem:(BRTabBarItem *)item tag:(NSInteger)tag allcount:(NSInteger)allcount ItemType:(BRTabBarItemType)type;

/**
 * Use tag to get BarItem,you can change the detial for item
 * @param tag the tag for Item
 */
-(BRTabBarItem *)BarItemForTag:(NSInteger)tag;

/**
 *Use Config to Unified change ItemStyle,you can custom made your own Item
 *@param config the config for newStyle
 */
-(void)changeItemWithConfig:(BRTabBarStyleConfig)config;


/**
 *Use tag  to Change The State for Item
 *@param tag the currentIndex
 */
-(void)didSelectItemWithTag:(NSInteger)tag;
```

+ **BRTabBarItemType**:this enum is use to classify tabBarItem type which has three type:defalutType,customType,
ProtrudeType.

+ **initWithTabBarItem**:this method is use to initialize tabBar by tabBarItem.

+ **addTabBarItem**:this method is use to add new TabBarItem to tabBar

+ **BarItemForTag**:this method is use to help user to find tabBarItem with item tag

+ **changeItemWithConfig**:this method is use to change all of items style in tabBar 

+ **didSelectItemWithTag**:this method is use to tell tabBar which item has been chosen.


#### 1.1.2 BRTabBarItem
> BRTabBarItem is inherit form UIView

```Objective-c
/**
 * InitTabBarItem With title and Image
 * @param title the title for barItem
 * @param image the image for barItem
 * @param config the config for item
 */
-(instancetype)initWithTitle:(nonnull NSString *)title image:(UIImage * _Nullable)image selectedImage:(UIImage * _Nullable )selectedImage config:(BRTabBarStyleConfig) config;

/**
 * Use BRTabBarStyleConfig to set item NewStyle,you can use it to custom your own item
 * @param config the config for newSetyle
 */
-(void)SetNewStyleWithConfig:(BRTabBarStyleConfig)config;

/**
 * Use to change Item Selected State
 */
-(void)Selected;

/**
 * Use to change Item UnSelected State
 */
-(void)UnSelected;

/// the title for TabBarItem
@property (nonatomic,strong,nonnull) UILabel * title;
/// the Image for TabBarItem
@property (nonatomic,strong) UIImageView * _Nullable imageView;
/// the selectedImage for item
@property (nonatomic,strong) UIImage * _Nullable selectedImage;
/// the originImage for item
@property (nonatomic,strong) UIImage * _Nullable originImage;
```
+ **title**:this property is use to load barItem title 

+ **imageView**:this property is use to load barItem image

+ **selectedImage**:this property is use to load imageView selected image

+ **originImage**:this property is use to load imageView origin image

+ **initWithTitle**:this method is use to initizalize tabBarItem with title,originimage,selectedimage,style

+ **SetNewStyleWithConfig**:this method is use to set new style for tabbarItem

+ **Selected**:this method is use to change the state for barItem

+ **UnSelected**:this method is use to change the state for barItem


### 1.2 BRMediaPicker

#### 1.2.1 BRMediaConfig

#### 1.2.2 BRImageAlbumItem


#### 1.2.3 BRPreviewVideoBaseController

#### 1.2.4 BRCropBaseImageController

#### 1.2.5 BRMediaPicker


## 2.BRExtension
### 2.1 UIWindow+BRExtension

### 2.2 UITableView+BRExtension

### 2.3 UIView+BRExtension

### 2.4 NSObject+BRExtension


## Requirements

## Installation

BRKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BRKit'
```

## Author

SunOfDUT, szhixiong@163.com

## License

BRKit is available under the MIT license. See the LICENSE file for more info.
