//
//  ImageAlbumItem.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/5.
//

#import "BRImageAlbumItem.h"

@implementation BRImageAlbumItem

+(BRImageAlbumItem *)initWithData:(NSString *)Title  fetchResult:(PHFetchResult<PHAsset*> *)fetchResult{
    BRImageAlbumItem *new = [BRImageAlbumItem new];
    new.title = Title;
    new.fetchResult = fetchResult;
    return new;
}

@end
