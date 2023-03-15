//
//  BRPreviewVideoBaseController.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2023/2/18.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "BRExtension.h"

@interface BRPreviewVideoBaseController : UIViewController
@property (nonatomic,strong) AVPlayerLayer *playItemLayer;
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) UIButton *backbutton;
@property (nonatomic,strong) PHAsset *asset;
- (instancetype)initWithPlayItem:(AVPlayerItem *)playitem PHAsset:(PHAsset *)asset;
@end
