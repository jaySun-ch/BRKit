//
//  BRData.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2023/2/17.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol BRMediaPickerDelegate<NSObject>

-(void)DidDismissPickView;

-(void)DidSelectVideo:(AVPlayerItem *)playItem;

-(void)DidSelectImage:(NSMutableArray<UIImage *> *)image;

@end

typedef NS_ENUM(NSInteger,BRMediaType){
    BRImage = 0,
    BRVideo = 1,
};

typedef NS_ENUM(NSInteger,BRVideoPreviewType){
    BRVideoPreviewNone = 0,    //没有预览页面,可以直接拿到视频,自己定制画面
    BRVideoPreviewDefault = 1, //有默认的预览画面,内置下一步,暂停....等功能
    BRVideoPreviewCustom = 2,  //只含有基本的视频Layer和返回按钮,可以在此基础上自己定制页面
};

@interface BRMediaConfig : NSObject

@property (readwrite) BRMediaType type; //显示的资源形式
@property (readwrite) BRVideoPreviewType VideoPreviewtype; //视频预览的形式
@property (readwrite) NSInteger pickLimit;//最多可以挑选多少个
@property (readwrite) BOOL isCropImage; //是否裁剪图片
@property (nonatomic,strong) UIColor *backgroundColor; //背景颜色
@property (readwrite) CGFloat GridCount; //一行显示的个数
@property (nonatomic,strong) id<BRMediaPickerDelegate>delegate; //代理
@property (readwrite) BOOL isShowMultiPickDetial; //多选的时候是否显示缩略图

@end
