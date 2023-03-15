//
//  BRWindow+Extension.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2023/2/17.
//

#import <UIKit/UIKit.h>
#import "BRMediaPicker.h"


@interface UIWindow (BRExtension)

+(void)PresentPickerWithConfig:(BRMediaConfig *)Config;

@end
