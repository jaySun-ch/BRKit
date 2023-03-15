//
//  BRCollectionVideoCell.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2023/2/17.
//

#import <UIKit/UIKit.h>

@interface BRCollectionVideoCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *image;
@property (nonatomic,strong) UILabel *totalTime;
@property (nonatomic,strong) UIButton  *pickButton;
-(void)ShowPickButtonWithAnimation;
@end
