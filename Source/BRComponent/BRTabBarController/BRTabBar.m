//
//  AEtabBar.m
//  Academic_exchange
//
//  Created by 孙志雄 on 2023/3/12.
//

#import "BRTabBar.h"


@interface BRTabBar()

///The Defalut Style Config
@property (nonatomic) BRTabBarStyleConfig defalutConfig;
///The currentIndex for Tabbar
@property (nonatomic,assign) NSInteger currentIndex;
///The allcount for Item
@property (nonatomic,assign) NSInteger allcount;
@end

@implementation BRTabBar


- (instancetype)initWithTabBarItem:(NSArray<BRTabBarItem *> *)items{
    self = [super init];
    if(self){
        [self setBarItemWithArray:items];
    }
    return self;
}

/// the method for add Item
-(void)addTabBarItem:(BRTabBarItem *)item tag:(NSInteger)tag allcount:(NSInteger)allcount  ItemType:(BRTabBarItemType)type{
    CGFloat itemSpace = (BRScreenWidth - (allcount * AETabBarItemWidth)) / (allcount + 1);
    item.tag = tag + 10;
    self.allcount = allcount;
    if(type == BRTabBarItemDefalut){
        item.x = (itemSpace * (tag+1)+AETabBarItemWidth * (tag));
        item.y = self.defalutConfig.topSpace;
    }else if(type == BRTabBarItemCustom){
        item.centerX = BRScreenWidth / 2;
        item.y = ((BRTabBarDefaultHeight - item.height) / 2) > 0 ?  (BRTabBarDefaultHeight - item.height)/ 2 : self.defalutConfig.topSpace;
    }else{
        item.centerX = BRScreenWidth / 2;
        item.centerY = self.center.y;
    }
    [self addSubview:item];
}

/// InitTabbarItem for Tabbar
-(void)setBarItemWithArray:(NSArray<BRTabBarItem *> *)items{
    NSInteger iconcount = items.count;
    self.allcount = iconcount;
    CGFloat itemSpace = (BRScreenWidth - (iconcount * AETabBarItemWidth)) / (iconcount + 1);
    for(int i = 0 ; i < iconcount;i++){
        BRTabBarItem *item = items[i];
        item.tag = i+10;
        if(item.title){
            item.x = (itemSpace * (i+1)+AETabBarItemWidth * (i));
            item.y = self.defalutConfig.topSpace;
        }else{
            item.centerX = BRScreenWidth / 2;
            item.y = ((BRTabBarDefaultHeight - item.height) / 2) > 0 ?  (BRTabBarDefaultHeight - item.height)/ 2 : self.defalutConfig.topSpace;
        }
    }
    [self didSelectItemWithTag:0];
}

-(BRTabBarItem *)BarItemForTag:(NSInteger)tag{
    BRTabBarItem *objItem = [self viewWithTag:tag+10];
    return objItem;
}

-(void)changeItemWithConfig:(BRTabBarStyleConfig)config{
    self.defalutConfig = config;
    for(int i = 0 ; i < self.allcount;i++){
        BRTabBarItem *item = [self viewWithTag:i+10];
        [item SetNewStyleWithConfig:config];
    }
}

-(void)didSelectItemWithTag:(NSInteger)tag{
    BRTabBarItem *item = [self viewWithTag:self.currentIndex+10];
    [item UnSelected];
    self.currentIndex = tag;
    item = [self viewWithTag:self.currentIndex+10];
    [item Selected];
}

@end
