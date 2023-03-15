//
//  CustomCenterButton.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/5.
//

#import <UIKit/UIKit.h>

@interface BRCenterButton : UIView
@property (nonatomic,strong) UILabel *Title;
@property (nonatomic,strong) UIImageView *image;
-(void)initWithData:(NSString *)title;
-(void)RoateIcon:(BOOL)show;
-(void)ResetTitle:(NSString *)title;
@end
