//
//  BRWindow+Extension.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2023/2/17.
//

#import "UIWindow+BRExtension.h"

@interface UIWindow (BRExtension)

@end

@implementation UIWindow (BRExtension)

+ (void)PresentPickerWithConfig:(BRMediaConfig *)Config{
    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
    UIViewController *rootController = window.rootViewController;
    BRMediaPicker *pickerController = [[BRMediaPicker alloc] initWithConfig:Config];
    [rootController presentViewController:pickerController animated:YES completion:nil];
}

@end
