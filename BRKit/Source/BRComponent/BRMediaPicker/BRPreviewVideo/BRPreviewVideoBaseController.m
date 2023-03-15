//
//  BRPreviewVideoBaseController.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2023/2/18.
//

#import "BRPreviewVideoBaseController.h"

@interface BRPreviewVideoBaseController()

@end


@implementation BRPreviewVideoBaseController

- (instancetype)initWithPlayItem:(AVPlayerItem *)playitem PHAsset:(PHAsset *)asset{
    self = [super init];
    if(self){
        self.asset = asset;
        self.backbutton = [UIButton new];
        self.backbutton.tintColor = [UIColor whiteColor];
        [self.backbutton setImage:[UIImage systemImageNamed:@"chevron.left"] forState:UIControlStateNormal];
        self.backbutton.frame = CGRectMake(0, 45, 30, 30);
        [self.backbutton addTarget:self action:@selector(DismissView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.backbutton];
        self.player = [[AVPlayer alloc] initWithPlayerItem:playitem];
        self.playItemLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playItemLayer.frame = self.view.frame;
        self.playItemLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.view.layer addSublayer:self.playItemLayer];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.playItemLayer.player play];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.playItemLayer.player pause];
}

-(void)DismissView{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
