//
//  RootController.h
//  Academic_exchange
//
//  Created by 孙志雄 on 2023/3/12.
//
#import "BRTabBar.h"


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

///BRKIT--BRTabBarController: Custom your own TabBar and package some usually used method
@interface BRTabBarController : UITabBarController

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


@end
