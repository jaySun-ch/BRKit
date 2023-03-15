//
//  ImageAlbumItem.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/5.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface BRImageAlbumItem : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) PHFetchResult<PHAsset*> *fetchResult;
+(BRImageAlbumItem *)initWithData:(NSString *)Title  fetchResult:(PHFetchResult<PHAsset*> *)fetchResult;
@end
