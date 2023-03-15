//
//  UITableView+BRExtension.m
//  Academic_exchange
//
//  Created by 孙志雄 on 2023/3/13.
//

#import "UITableView+BRExtension.h"

@interface UITableView(BRExtension)

@end

@implementation UITableView(BRExtension)

/// make tableview be fullScreen
-(void)settableViewFullScreen{
    self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
}



@end
