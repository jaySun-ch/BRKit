//
//  AETabBar.h
//  Academic_exchange
//
//  Created by 孙志雄 on 2023/3/12.
//

#import "BRTabBarItem.h"

/// The Type of BRTabBarItem
typedef NS_ENUM(NSInteger,BRTabBarItemType){
    /// normal type
    BRTabBarItemDefalut = 0,
    /// custom type
    BRTabBarItemCustom = 1,
    /// protrude type
    BRTabBarItemProtrude = 2,
};

@interface BRTabBar : UITabBar

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


@end
