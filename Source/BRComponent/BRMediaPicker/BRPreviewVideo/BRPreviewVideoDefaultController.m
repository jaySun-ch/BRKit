//
//  BRPreviewVideoController.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2023/2/18.
//


#import "BRPreviewVideoDefaultController.h"

@interface BRPreviewVideoDefaultController()
@property (nonatomic,strong) UIImageView *pauseIcon;//暂停按钮
@property (nonatomic,strong) UIButton *nextButton;//下一步按钮
@property (nonatomic,strong) AVAsset *videoAsset;
@property(nonatomic,strong) id TimeObserver;
@end


@implementation BRPreviewVideoDefaultController

- (instancetype)initWithPlayItem:(AVPlayerItem *)playitem PHAsset:(PHAsset *)asset{
    self = [super initWithPlayItem:playitem PHAsset:asset];
    if(self){
        [self initSubViews];
        [self AddVideoOberserver];
        [self initVideoProgressBar];
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
        [[PHImageManager defaultManager] requestAVAssetForVideo:self.asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            self.videoAsset = asset;
            AVAssetTrack * videoAssetTrack = [self.videoAsset tracksWithMediaType: AVMediaTypeVideo].firstObject;
            [self splitVideo:videoAssetTrack.nominalFrameRate splitCompleteBlock:^(BOOL success, NSMutableArray *splitimgs) {
                for(NSInteger i = 0;i < splitimgs.count ; i++){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIImageView *image = [[UIImageView alloc] initWithImage:splitimgs[i]];
                        image.clipsToBounds = YES;
                        image.contentMode = UIViewContentModeScaleAspectFill;
                        image.frame = CGRectMake(i * 50,0,50,60);
                        UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:10];
                        [scrollView addSubview:image];
                    });
                }
            }];
        }];

    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HandleTapGetsture)]];
}

-(void)initSubViews{
    self.pauseIcon = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"play.fill"]];
    self.pauseIcon.frame = CGRectMake(0, 0, 50, 50);
    self.pauseIcon.center = self.view.center;
    self.pauseIcon.tintColor = [UIColor whiteColor];
    [self.pauseIcon setHidden:YES];
    [self.view addSubview:self.pauseIcon];
    
    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 25)];
    self.nextButton.right = self.view.right-10;
    self.nextButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.nextButton.layer.cornerRadius = 5;
    self.nextButton.centerY = self.backbutton.centerY;
    self.nextButton.backgroundColor = [UIColor systemPinkColor];
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.nextButton];
}

-(void)HandleTapGetsture{
    if(self.playItemLayer.player.rate != 0){
        //播放
        [self.playItemLayer.player pause];
        [_pauseIcon setHidden:NO];
        _pauseIcon.transform = CGAffineTransformMakeScale(1.8f,1.8f);
        _pauseIcon.alpha = 1.0f;
        [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.pauseIcon.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        }completion:nil];
    }else{
        [self.playItemLayer.player play];
        [_pauseIcon setHidden:YES];
    }
}


-(void)AddVideoOberserver{
    __weak __typeof(self) weakself = self;
    _TimeObserver = [self.playItemLayer.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        if(weakself.playItemLayer.player.status == AVPlayerStatusReadyToPlay){
            float current = CMTimeGetSeconds(time);
            float total = CMTimeGetSeconds([weakself.playItemLayer.player.currentItem duration]);
            if(total == current){
                [weakself.playItemLayer.player seekToTime:kCMTimeZero];
                [weakself.playItemLayer.player play];
            }
        }
    }];
}

-(void)initVideoProgressBar{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    float total = CMTimeGetSeconds([self.playItemLayer.player.currentItem duration]) + 1;
    if((50 * (CGFloat)(total)) < (ScreenWidth - 40)){
        scrollView.frame = CGRectMake(0,0,50 * (CGFloat)(total),60);
    }else{
        scrollView.frame = CGRectMake(20,0,ScreenWidth - 40, 60);
    }
    scrollView.centerX = self.view.centerX;
    scrollView.contentSize = CGSizeMake(50 * (int)(total) ,60);
    [scrollView setScrollEnabled:YES];
    scrollView.alwaysBounceHorizontal = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bottom = self.view.bottom - 60;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.tag = 10;
    [self.view addSubview:scrollView];
}

-(void)AddImage{
    UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:10];
    float current = CMTimeGetSeconds(self.playItemLayer.player.currentItem.currentTime);
    NSLog(@"%d AddImage",(int)current);
    UIImageView *image = [[UIImageView alloc] initWithImage:[self getVideoImageAtTime:self.playItemLayer.player.currentItem.currentTime]];
    image.clipsToBounds = YES;
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.frame = CGRectMake((int)current * 50,0,50,60);
    [scrollView addSubview:image];
}



- (UIImage *)getVideoImageAtTime:(CMTime)time{
    NSError *error = nil;

//    NSLog(@"FPS is  : %f ", videoAssetTrack.nominalFrameRate);
    AVAssetImageGenerator *ig = [[AVAssetImageGenerator alloc] initWithAsset:self.videoAsset];
//    [ig generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)]] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
//
//    }]
    CGImageRef image = [ig copyCGImageAtTime:time actualTime:nil error:&error];
    UIImage *screenShot = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    return screenShot;
}

- (void)splitVideo:(float)fps splitCompleteBlock:(void(^)(BOOL success, NSMutableArray *splitimgs))splitCompleteBlock {
    NSMutableArray *splitImages = [NSMutableArray array];

    CMTime cmtime = self.videoAsset.duration; //视频时间信息结构体
    Float64 durationSeconds = CMTimeGetSeconds(cmtime); //视频总秒数
    NSLog(@"%f splitVideo",durationSeconds);
    NSMutableArray *times = [NSMutableArray array];
    Float64 totalFrames = durationSeconds * fps; //获得视频总帧数
    CMTime timeFrame;
    
    for (int i = 0; i <= durationSeconds; i++) {
        timeFrame = CMTimeMake(i, 1); //第i帧  帧率
        NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
        [times addObject:timeValue];
    }

    AVAssetImageGenerator *imgGenerator = [[AVAssetImageGenerator alloc] initWithAsset:self.videoAsset];
    //防止时间出现偏差
    imgGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imgGenerator.requestedTimeToleranceAfter = kCMTimeZero;

    NSInteger timesCount = [times count];
    NSLog(@"%ld splitVideo",timesCount);
    // 获取每一帧的图片
    [imgGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        NSLog(@"current-----: %lld", requestedTime.value);
        NSLog(@"timeScale----: %d",requestedTime.timescale); // 帧率
        if(error){
            NSLog(@"获取失败");
        }
        BOOL isSuccess = NO;
        switch (result) {
            case AVAssetImageGeneratorCancelled:
                NSLog(@"Cancelled");
                break;
            case AVAssetImageGeneratorFailed:
                NSLog(@"Failed");
                break;
            case AVAssetImageGeneratorSucceeded: {
                UIImage *frameImg = [UIImage imageWithCGImage:image];
                 [splitImages addObject:frameImg];
                if (requestedTime.value == timesCount) {
                    isSuccess = YES;
                    NSLog(@"completed");
                }
            }
            break;
        }
        if (splitCompleteBlock) {
            splitCompleteBlock(isSuccess,splitImages);
        }
    }];
}

   



@end
