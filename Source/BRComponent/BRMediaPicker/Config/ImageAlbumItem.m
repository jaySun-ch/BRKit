//
//  ImageAlbumItem.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/5.
//

#import "ImageAlbumItem.h"

@implementation ImageAlbumItem

+(ImageAlbumItem *)initWithData:(NSString *)Title  fetchResult:(PHFetchResult<PHAsset*> *)fetchResult{
    ImageAlbumItem *new = [ImageAlbumItem new];
    new.title = Title;
    new.fetchResult = fetchResult;
    return new;
}

@end
