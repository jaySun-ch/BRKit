//
//  UITableView+BRExtension.h
//  Academic_exchange
//
//  Created by 孙志雄 on 2023/3/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (BRExtension)

/**
 * make tableview be fullScreen,you need to set tableView.style to be UITableViewStylePlain
 */
-(void)settableViewFullScreen;

@end

NS_ASSUME_NONNULL_END
