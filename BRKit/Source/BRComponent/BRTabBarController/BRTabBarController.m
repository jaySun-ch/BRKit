//
//  RootController.m
//  Academic_exchange
//
//  Created by 孙志雄 on 2023/3/12.
//

#import "BRTabBarController.h"

@interface BRTabBarController()<UITabBarDelegate>

@end

@implementation BRTabBarController

- (void)viewDidLoad{
    [super viewDidLoad];
}

-(void)initSubViewsTabBar:(NSArray<BRTabBarItem*>*)items viewcontrollers:(NSArray<NSString*>*)viewcontrollers isProtrude:(BOOL)isProtrude{
    self.customBar = [[BRTabBar alloc] init];
    for (int i = 0; i < items.count; i++) {
        Class vcType = NSClassFromString(viewcontrollers[i]);
        UIViewController *vc = [[vcType alloc] init];
        vc.tabBarItem.tag = i;
        if(items[i].title){
            [self addChildViewController:vc tabBarItem:items[i] tag:i allcount:items.count ItemType:BRTabBarItemDefalut];
        }else{
            [self addChildViewController:vc tabBarItem:items[i] tag:i allcount:items.count ItemType:isProtrude ? BRTabBarItemProtrude:BRTabBarItemCustom];
        }
    }
    [_customBar didSelectItemWithTag:0];
    _customBar.translucent = NO;
    _customBar.backgroundColor = [UIColor whiteColor];
    self.customBar.delegate = self;
    [self setValue:_customBar forKey:@"tabBar"];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if(tabBar.selectedItem.tag != 2){
        [_customBar didSelectItemWithTag:tabBar.selectedItem.tag];
    }
}

-(void)addChildViewController:(UIViewController *)childController tabBarItem:(BRTabBarItem *)item tag:(NSInteger)tag allcount:(NSInteger)allcount ItemType:(BRTabBarItemType)type{
    [self addChildViewController:childController];
    childController.tabBarItem.tag = tag;
    [self.customBar addTabBarItem:item tag:tag allcount:allcount ItemType:type];
}



@end
