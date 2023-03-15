//
//  BRTabBarItem.h
//  Academic_exchange
//
//  Created by 孙志雄 on 2023/3/12.
//

#import "BRTabBarStyleConfig.h"

@interface BRTabBarItem : UIView

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

@end
