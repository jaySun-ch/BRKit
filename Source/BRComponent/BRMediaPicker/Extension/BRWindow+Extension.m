//
//  BRWindow+Extension.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2023/2/17.
//

#import "BRWindow+Extension.h"
#import "BRMediaPicker.h"

@interface UIWindow (Extension)
@end

@implementation UIWindow (Extension)

+ (void)PresentPickerWithConfig:(BRMediaConfig *)Config{
    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
    UIViewController *rootController = window.rootViewController;
    BRMediaPicker *pickerController = [[BRMediaPicker alloc] initWithConfig:Config];
    [rootController presentViewController:pickerController animated:YES completion:nil];
}

@end
