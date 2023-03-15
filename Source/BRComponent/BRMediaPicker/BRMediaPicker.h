//
//  BRMediaPicker.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2023/2/16.
//

#import <UIKit/UIKit.h>
#import "BRExtension.h"
#import "BRDefine.h"
#import "BRImageAlbumItem.h"
#import "BRCenterButton.h"
#import "BRCollectionImageCell.h"
#import "BRCollectionVideoCell.h"
#import "BRHeadTableCell.h"
#import "BRConfigHelper.h"
#import "BRCropCricleImage.h"
#import "BRPreviewVideoDefaultController.h"


@interface BRMediaPicker : UIViewController

- (instancetype)initWithConfig:(BRMediaConfig*)config;

@end
