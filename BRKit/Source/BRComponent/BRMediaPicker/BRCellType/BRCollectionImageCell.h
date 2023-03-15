//
//  BRCollectionImageCell.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2023/2/17.
//

#import <UIKit/UIKit.h>

@interface BRCollectionImageCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *image;
@property (nonatomic,strong) UIImageView *pickImage;
-(void)ShowPickAnimation;
-(void)DisimissPick;
@end
