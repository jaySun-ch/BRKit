//
//  BRMediaPicker.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2023/2/16.
//

#import "BRMediaPicker.h"
#import "BRCenterButton.h"
#import "BRCollectionImageCell.h"
#import "BRCollectionVideoCell.h"
#import "BRHeadTableCell.h"
#import "BRConfigHelper.h"
#import "BRCropCricleImage.h"
#import "BRPreviewVideoDefaultController.h"


NSString *const BRImagecell = @"BRImageCell";
NSString *const BRVideocell = @"BRVideoCell";
NSString *const BRTableCell = @"BRTableCell";

@interface BRMediaPicker()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UITableView *tableView; //显示选择相册
@property (nonatomic,strong) UICollectionView *collectionView; //显示视频或者照片
@property (nonatomic,strong) PHImageManager *imageManager;//相册资源管理器
@property (nonatomic,assign) CGSize assetGridThumbnailSize;//单个格子大小
@property (nonatomic,strong) NSMutableArray<ImageAlbumItem*> *items; //获取到的相册资源
@property (nonatomic,assign) CGFloat GridCount; //一行显示多少个
@property (nonatomic,strong) NSIndexPath *VideoSelectPath; //挑选的视频
@property (nonatomic,strong) UIButton *nextbutton; //完成视频挑选button
@property (nonatomic,strong) NSMutableArray<PHAsset *> *PickImageArray;
@property (nonatomic,strong) UIScrollView *MultiPickDetialBar;


@property (nonatomic,strong) BRMediaConfig *Defaultconfig;
@property (nonatomic,strong) ImageAlbumItem *currentItem;
@property (nonatomic,strong) UIView *TopBar;
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UIButton *multiPickButton;
@property (nonatomic,strong) BRCenterButton *CenterButton;
@property (nonatomic,assign) BOOL IsShowTable;

@end

@implementation BRMediaPicker

- (instancetype)initWithConfig:(BRMediaConfig *)config{
    self = [super init];
    if(self){
        self.Defaultconfig = config;
        
        self.view.backgroundColor = config.backgroundColor;
        if(self.Defaultconfig.type == BRVideo){
            self.Defaultconfig.pickLimit = 1;
        }
        self.imageManager = [PHCachingImageManager defaultManager];
        self.GridCount = self.Defaultconfig.GridCount;
        self.PickImageArray = [NSMutableArray array];
        self.assetGridThumbnailSize = CGSizeMake(((ScreenWidth/self.GridCount)-1) * (UIScreen.mainScreen.scale), ((ScreenWidth/self.GridCount)-1) * (UIScreen.mainScreen.scale));
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    NSLog(@"_Defaultconfig @%f",self.Defaultconfig.GridCount);
    [self initColletionViews];
    if(self.Defaultconfig.type == BRImage){
        [self initTableView];
    }
    [self GetMeidaAssets];
    if(self.Defaultconfig.isShowMultiPickDetial && self.Defaultconfig.pickLimit > 1){
        [self initMultiImage];
    }
}

#pragma 多选图片缩略图
-(void)initMultiImage{
    self.MultiPickDetialBar = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 170)];
    self.MultiPickDetialBar.backgroundColor = [UIColor whiteColor];
    self.MultiPickDetialBar.top = self.view.bottom - 200;
    self.MultiPickDetialBar.alwaysBounceHorizontal = YES;
    self.MultiPickDetialBar.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.MultiPickDetialBar];
}

#pragma 修改TableView的状态
-(void)EditTableViewMode{
    if(self.IsShowTable){
        self.IsShowTable = NO;
        [self DismissTableView];
    }else{
        self.IsShowTable = YES;
        [self ShowTableView];
    }
    [self.CenterButton RoateIcon:self.IsShowTable];
}


#pragma 显示TableView
-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,50, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.transform = CGAffineTransformMakeTranslation(0,-ScreenHeight);
    [self.tableView registerClass:[BRHeadTableCell class] forCellReuseIdentifier:BRTableCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
}

-(void)ShowTableView{
    [self.tableView reloadData];
    [UIView animateWithDuration:0.3f animations:^{
        self.tableView.transform = CGAffineTransformMakeTranslation(0,0);
    }];
}

#pragma 关闭TableView
-(void)DismissTableView{
    [UIView animateWithDuration:0.3f animations:^{
        self.tableView.transform = CGAffineTransformMakeTranslation(0,-ScreenHeight);
    } completion:^(BOOL finished) {
        [self.collectionView scrollToTopAnimated:YES];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < self.items.count){
        return 100;
    }else{
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.IsShowTable = NO;
    self.currentItem = self.items[indexPath.row];
    [self.collectionView reloadData];
    [self.CenterButton ResetTitle:self.currentItem.title];
    [self.CenterButton RoateIcon:self.IsShowTable];
    [self DismissTableView];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < self.items.count){
        BRHeadTableCell *cell = [tableView dequeueReusableCellWithIdentifier:BRTableCell];
        NSLog(@"%@ Title",self.items[indexPath.row].title);
        PHAsset *asset = self.items[indexPath.row].fetchResult.firstObject;
        // 这个不可以这样用 因为会导致 在复用的时候回重复进行加载；
        [self.imageManager requestImageForAsset:asset targetSize:CGSizeMake(80 * (UIScreen.mainScreen.scale),80 * (UIScreen.mainScreen.scale)) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [cell initWithData:result title:self.items[indexPath.row].title subtitle:[NSString stringWithFormat:@"%ld",self.items[indexPath.row].fetchResult.count]];
        }];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        return cell;
    }
}


#pragma 初始化ColletionViews
-(void)initColletionViews{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    [layout setItemSize:CGSizeMake((ScreenWidth/self.GridCount)-1,(ScreenWidth/self.GridCount)-1)];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,50, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    if(self.Defaultconfig.type == BRImage){
        [self.collectionView registerClass:[BRCollectionImageCell class] forCellWithReuseIdentifier:BRImagecell];
    }else{
        [self.collectionView registerClass:[BRCollectionVideoCell class] forCellWithReuseIdentifier:BRVideocell];
    }
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.currentItem.fetchResult.count + 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < self.currentItem.fetchResult.count){
        if(self.Defaultconfig.type == BRImage){
            BRCollectionImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BRImagecell forIndexPath:indexPath];
            cell.backgroundColor = [UIColor blackColor];
            PHAsset *asset = self.currentItem.fetchResult[indexPath.row];
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.synchronous = NO;
            [self.imageManager requestImageForAsset:asset targetSize:self.assetGridThumbnailSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                cell.image.image = result;
            }];
            if([self.PickImageArray containsObject:asset]){
                [cell ShowPickAnimation];
            }else{
                [cell DisimissPick];
            }
            return cell;
        }else{
            BRCollectionVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BRVideocell forIndexPath:indexPath];
            cell.backgroundColor = [UIColor blackColor];
            PHAsset *asset = self.currentItem.fetchResult[indexPath.row];
            [cell.totalTime setText:[self GetVideoTimeFormat:asset.duration]];
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.synchronous = NO;
            [self.imageManager requestImageForAsset:asset targetSize:self.assetGridThumbnailSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                cell.image.image = result;
                if(result.size.width >result.size.height){
                    cell.image.contentMode = UIViewContentModeScaleAspectFit;
                }else{
                    cell.image.contentMode = UIViewContentModeScaleAspectFill;
                }
            }];
            return cell;
        }
    }else{
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        return cell;
    }
}

-(NSString *)GetVideoTimeFormat:(CGFloat)time{
    int min = time / 60;
    CGFloat sec = time - min * 60;
    if(min == 0 && sec < 10){
        return [NSString stringWithFormat:@"00:0%.0f",sec];
    }else if(min == 0 && sec >= 10){
        return [NSString stringWithFormat:@"00:%.0f",sec];;
    }else if(min < 10 && sec < 10){
        return [NSString stringWithFormat:@"0%d:0%.0f",min,sec];
    }else if(min > 10 && sec < 10){
        return [NSString stringWithFormat:@"%d:%.0f",min,sec];
    }else{
        return [NSString stringWithFormat:@"0%d:%.0f",min,sec];
    }
}

#pragma 更新缩略图
-(void)RemoveObjectUpdatePickBar:(NSInteger)index{
    self.MultiPickDetialBar.contentSize = CGSizeMake((self.PickImageArray.count+1) * 110, 150);
    for(UIView *view in self.MultiPickDetialBar.subviews){
        if(view.class == [UIImageView class]){
            NSInteger currentIndex = (view.frame.origin.x - 10)/110;
            if(currentIndex == index){
                [view removeFromSuperview];
            }else if(currentIndex > index){
                view.frame = CGRectMake((currentIndex - 1)*110 + 10, 25, 100, 100);
            }
        }
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PHAsset *asset = self.currentItem.fetchResult[indexPath.row];
    if(self.Defaultconfig.type == BRImage){
        BRCollectionImageCell *cell = (BRCollectionImageCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        if(self.Defaultconfig.pickLimit > 1){
           // 多选
            if(self.Defaultconfig.isCropImage){
                
            }else{
                if([self.PickImageArray containsObject:asset]){
                    //已经选中
                    NSInteger index = [self.PickImageArray indexOfObject:asset];
                    [self RemoveObjectUpdatePickBar:index];
                    [self.PickImageArray removeObject:asset];
                    BRCollectionImageCell *cell = (BRCollectionImageCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                    [cell DisimissPick];
                    
                }else{
                    //还未选中
                    if(self.PickImageArray.count < self.Defaultconfig.pickLimit){
                        self.MultiPickDetialBar.contentSize = CGSizeMake((self.PickImageArray.count+1) * 110, 150);
                        UIImageView *imageView = [[UIImageView alloc] initWithImage:cell.image.image];
                        imageView.clipsToBounds = YES;
                        imageView.contentMode = UIViewContentModeScaleAspectFill;
                        imageView.frame = CGRectMake(self.PickImageArray.count * 110 + 10,25, 100, 100);
                        [self.MultiPickDetialBar addSubview:imageView];
                        [self.PickImageArray addObject:asset];
                        BRCollectionImageCell *cell = (BRCollectionImageCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                        [cell ShowPickAnimation];
                    }else{
                        UIAlertController *controller = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"最多只能选择%ld张",self.Defaultconfig.pickLimit] message:nil preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                        [controller addAction:action];
                        [self presentViewController:controller animated:YES completion:nil];
                    }
                }
            }
           
        }else{
            //单选
            if(self.Defaultconfig.isCropImage){
                PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                options.resizeMode = PHImageRequestOptionsResizeModeNone;
                options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                [self.imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    BRCropCricleImage *cropImageController = [[BRCropCricleImage alloc] initWithImage:result];
                    cropImageController.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self presentViewController:cropImageController animated:NO completion:nil];
                }];
            }else{
                if(self.PickImageArray.count != 0){
                    NSIndexPath *lastcellPath = [NSIndexPath indexPathForRow:[self.currentItem.fetchResult indexOfObject:self.PickImageArray.firstObject] inSection:0];
                    BRCollectionImageCell *lastcell = (BRCollectionImageCell *)[self.collectionView cellForItemAtIndexPath:lastcellPath];
                    [lastcell DisimissPick];
                    [self.PickImageArray removeFirstObject];
                }
                [self.PickImageArray addObject:asset];
                [cell ShowPickAnimation];
            }
        }
    }else{
        if(self.Defaultconfig.VideoPreviewtype == BRVideoPreviewNone){
            if(self.VideoSelectPath){
                BRCollectionVideoCell *lastcell = (BRCollectionVideoCell *)[self.collectionView cellForItemAtIndexPath:self.VideoSelectPath];
                [lastcell.pickButton setSize:CGSizeMake(0, 0)];
            }
            [self.nextbutton setEnabled:YES];
            BRCollectionVideoCell *cell = (BRCollectionVideoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            [cell ShowPickButtonWithAnimation];
            self.VideoSelectPath = indexPath;
        }else if(self.Defaultconfig.VideoPreviewtype == BRVideoPreviewDefault){
            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
            [self.imageManager requestPlayerItemForVideo:asset options:options resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
                BRPreviewVideoDefaultController *controller = [[BRPreviewVideoDefaultController alloc] initWithPlayItem:playerItem PHAsset:asset];
                controller.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:controller animated:NO completion:nil];
            }];
        
        }else{
            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
            [self.imageManager requestPlayerItemForVideo:asset options:options resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
//                BRPreviewVideoController *controller = [[BRPreviewVideoController alloc] initWithPlayItem:playerItem];
//                controller.modalPresentationStyle = UIModalPresentationFullScreen;
//                [self presentViewController:controller animated:NO completion:nil];
            }];
        }}
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((ScreenWidth/self.GridCount)-1,(ScreenWidth/self.GridCount)-1);
}

#pragma 完成视频挑选
-(void)FinishPickVideo{
    PHAsset *asset = self.currentItem.fetchResult[self.VideoSelectPath.row];
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
    [self.imageManager requestPlayerItemForVideo:asset options:options resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        if(self.Defaultconfig.delegate){
            [self.Defaultconfig.delegate DidSelectVideo:playerItem];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}
#pragma 从相册获取Asset
-(void)GetMeidaAssets{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if(status != PHAuthorizationStatusAuthorized){
            return;
        }
        self.items = [NSMutableArray array];
        PHFetchOptions *options = [PHFetchOptions new];
        PHFetchResult<PHAssetCollection *> *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:options];
        [self convertCollection:smartAlbums];
        PHFetchResult<PHCollection*> *userCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        [self convertCollection:userCollections];
        NSArray *sortArray = [self.items sortedArrayUsingComparator:^NSComparisonResult(ImageAlbumItem *obj1, ImageAlbumItem *obj2) {
            if(obj1.fetchResult.count > obj2.fetchResult.count){
                return NSOrderedAscending;
            }else{
                return NSOrderedDescending;
            }
        }];
        [self.items removeAllObjects];
        [self.items addObjectsFromArray:sortArray];
        self.currentItem = self.items.firstObject;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            [self initTopBar];
        });
    }];
}


#pragma 筛选
-(void)convertCollection:(PHFetchResult<PHAssetCollection *> *) collection{
    for (NSInteger i = 0; i < collection.count; i++) {
        PHFetchOptions *options = [PHFetchOptions new];
        options.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO]];
        if(self.Defaultconfig.type == BRImage){
            options.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"mediaType = %ld",PHAssetMediaTypeImage]];
        }else{
            options.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"mediaType = %ld",PHAssetMediaTypeVideo]];
        }
        PHFetchResult<PHAsset *> *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection[i] options:options];
        if(assetsFetchResult.count > 0){
            NSString *title = [self titleOfAlbumForChinse:collection[i].localizedTitle];
            [self.items addObject:[ImageAlbumItem initWithData:title fetchResult:assetsFetchResult]];
            NSLog(@"%@ %ld",title,i);
        }
    }
}

#pragma 转换中文
-(NSString *)titleOfAlbumForChinse:(NSString *)title{
    if([title isEqualToString:@"Slo-mo"]) {
        return @"慢动作";
    } else if([title isEqualToString:@"Recently Added"]){
        return @"最近添加";
    } else if([title isEqualToString:@"Favorites"]){
        return @"个人收藏";
    } else if([title isEqualToString:@"Recently Deleted"]){
        return @"最近删除";
    } else if([title isEqualToString:@"Videos"]){
        return @"视频";
    } else if([title isEqualToString:@"All Photos"]){
        return @"所有照片";
    } else if([title isEqualToString:@"Selfies"]){
        return @"自拍";
    } else if([title isEqualToString:@"Screenshots"]){
        return @"屏幕快照";
    } else if([title isEqualToString:@"Camera Roll"]){
        return @"相机胶卷";
    }else if([title isEqualToString:@"Recents"]){
        return @"最近项目";
    }else if([title isEqualToString:@"Not Uploaded to iCloud"]){
        return @"未上传iCloud的照片";
    }else if([title isEqualToString:@"Portrait"]){
        return @"人像";
    }else if([title isEqualToString:@"Live Photos"]){
        return @"实况";
    }
    return title;
}


#pragma 初始化顶部工具栏
-(void)initTopBar{
    self.TopBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    [self.TopBar setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.TopBar];
    if(self.Defaultconfig.type == BRImage){
        self.CenterButton = [[BRCenterButton alloc] initWithFrame: CGRectMake(0, 0, 100, 30)];
        [self.CenterButton setUserInteractionEnabled:YES];
        self.CenterButton.center = self.TopBar.center;
        [self.CenterButton initWithData:self.currentItem.title];
        [self.CenterButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(EditTableViewMode)]];
        [self.TopBar addSubview:self.CenterButton];
        
        self.multiPickButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 70, 10, 60, 30)];
        [self.multiPickButton setTitle:@"完成" forState:UIControlStateNormal];
        [self.multiPickButton addTarget:self action:@selector(FinishPickImage) forControlEvents:UIControlEventTouchUpInside];
        [self.multiPickButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.TopBar addSubview:self.multiPickButton];
        
    }else{
        self.CenterButton = [[BRCenterButton alloc] initWithFrame: CGRectMake(0, 0, 100, 30)];
        [self.CenterButton setUserInteractionEnabled:NO];
        self.CenterButton.center = self.TopBar.center;
        [self.CenterButton initWithData:@"挑选视频"];
        [self.CenterButton.image setHidden:YES];
        [self.TopBar addSubview:self.CenterButton];
        
        if(self.Defaultconfig.VideoPreviewtype == BRVideoPreviewNone){
            self.nextbutton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 70, 30)];
            [self.nextbutton setTitle:@"完成" forState:UIControlStateNormal];
            self.nextbutton.right = self.TopBar.right;
            [self.nextbutton.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
            self.nextbutton.centerY = self.TopBar.centerY;
            [self.nextbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.nextbutton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
            [self.TopBar addSubview:self.nextbutton];
            [self.nextbutton addTarget:self action:@selector(FinishPickVideo) forControlEvents:UIControlEventTouchUpInside];
            [self.nextbutton setEnabled:NO];
        }
    }
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [self.backButton setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
    [self.backButton setTintColor:[UIColor blackColor]];
    [self.backButton addTarget:self action:@selector(DismissView) forControlEvents:UIControlEventTouchUpInside];
    [self.TopBar addSubview:self.backButton];
}

#pragma 挑选图像之后的回调
-(void)FinishPickImage{
    NSMutableArray *array = [NSMutableArray array];
    for(PHAsset *pick in self.PickImageArray){
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeNone;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        //PHImageManagerMaximumSize
        [self.imageManager requestImageForAsset:pick targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
           [array addObject:result];
           if(pick == self.PickImageArray.lastObject){
               NSLog(@"%ld FinishPickImage",array.count);
               if(self.Defaultconfig.delegate) {
                   [self.Defaultconfig.delegate DidSelectImage:array];
               }
               [self dismissViewControllerAnimated:YES completion:nil];
            }
           
        }];
    }
}

-(void)DismissView{
    [self dismissViewControllerAnimated:YES completion:nil];
}






@end
