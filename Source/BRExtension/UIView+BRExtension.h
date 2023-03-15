//
//  UIView+BRExtension.h
//  Academic_exchange
//
//  Created by 孙志雄 on 2023/3/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (BRExtension)

/// the origin for view 
@property (nonatomic) CGPoint origin;
/// the origin.x for view
@property (nonatomic) CGFloat x;
/// the origin.y for view
@property (nonatomic) CGFloat y;
/// the size for view
@property (nonatomic) CGSize size;
/// the centerX for view
@property (nonatomic) CGFloat centerX;
/// the centerY for view
@property (nonatomic) CGFloat centerY;
/// the height for view
@property (nonatomic) CGFloat height;
/// the width for view
@property (nonatomic) CGFloat width;

@end

NS_ASSUME_NONNULL_END
