//
//  BRCropImage.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2023/2/20.
//
#import "BRCropCricleImage.h"

#define MaskCircleSize 350

@interface BRCropCricleImage()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) UIView *TopBar;
@property (nonatomic,strong) UIButton *CancelButton;
@property (nonatomic,strong) UIButton *MakeSureButton;
@property (nonatomic,strong) UIButton *ReFreshButton;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) CAShapeLayer *fillLayer;
@property (nonatomic,strong) UIImage *OriginImage;

@end


@implementation BRCropCricleImage

- (instancetype)initWithImage:(UIImage *)image{
    self = [super init];
    if(self){
        self.OriginImage = image;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorNamed:@"darkgray"];
    [self initScrollView];
    [self initTopBar];
}


-(void)initTopBar{
    self.TopBar = [[UIView alloc] init];
    self.TopBar.backgroundColor = [UIColor colorNamed:@"darkgray"];
    [self.view addSubview:self.TopBar];
    
    self.CancelButton = [[UIButton alloc] init];
    [self.CancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.CancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.CancelButton addTarget:self action:@selector(dissMissView) forControlEvents:UIControlEventTouchUpInside];
    [self.TopBar addSubview:self.CancelButton];
    
    self.MakeSureButton = [[UIButton alloc] init];
    [self.MakeSureButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.MakeSureButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.MakeSureButton addTarget:self action:@selector(SaveImage) forControlEvents:UIControlEventTouchUpInside];
    [self.TopBar addSubview:self.MakeSureButton];
    
    self.ReFreshButton = [[UIButton alloc] init];
    [self.ReFreshButton setImage:[UIImage systemImageNamed:@"arrow.clockwise"] forState:UIControlStateNormal];
    [self.ReFreshButton setTintColor:[UIColor lightGrayColor]];
    [self.ReFreshButton addTarget:self action:@selector(ReSetImage) forControlEvents:UIControlEventTouchUpInside];
    [self.TopBar addSubview:self.ReFreshButton];
    
    [self.TopBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(100);
        
    }];
    
    [self.CancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TopBar).inset(60);
        make.left.equalTo(self.TopBar).inset(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.ReFreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TopBar).inset(60);
        make.centerX.equalTo(self.TopBar);
        make.height.width.mas_equalTo(20);
    }];
    
    [self.MakeSureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TopBar).inset(60);
        make.right.equalTo(self.TopBar).inset(20);
        make.height.mas_equalTo(20);
    }];
}

-(void)ReSetImage{
    [self.scrollview setZoomScale:1.0];
    [self.imageView setCenterX:(self.imageView.frame.size.width + 30) / 2 + 20];
}

-(void)dissMissView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initScrollView{
    self.scrollview = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.scrollview setZoomScale:1.0];
    [self.scrollview setMaximumZoomScale:5.0];
    self.scrollview.showsVerticalScrollIndicator = NO;
    self.scrollview.contentInsetAdjustmentBehavior  = UIScrollViewContentInsetAdjustmentNever;
    self.scrollview.alwaysBounceVertical = YES;
    self.scrollview.alwaysBounceHorizontal = YES;
    [self.scrollview setScrollEnabled:YES];
    self.scrollview.delegate = self;
    [self.view addSubview:self.scrollview];
    [self SetImage];
}

-(void)SetImage{
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0,ScreenWidth - 40, ScreenHeight)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imageView setImage:self.OriginImage];
    [self.scrollview addSubview:self.imageView];
    [self.scrollview setMinimumZoomScale:1.0];
    CGFloat newHeight = self.OriginImage.size.height * (ScreenWidth - 40)/self.OriginImage.size.width;
    [self.scrollview setContentSize:CGSizeMake(ScreenWidth - 40,newHeight)];
    NSLog(@"%f scrollSize",self.scrollview.contentSize.height);
    self.imageView.center = self.scrollview.center;
    self.maskView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.maskView setUserInteractionEnabled:NO];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.view.frame cornerRadius:0];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(ScreenWidth / 2 - MaskCircleSize / 2, ScreenHeight / 2 - MaskCircleSize / 2, MaskCircleSize, MaskCircleSize) cornerRadius:MaskCircleSize / 2];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    self.fillLayer = [CAShapeLayer layer];
    self.fillLayer.path = path.CGPath;
    self.fillLayer.fillRule = kCAFillRuleEvenOdd;
    self.fillLayer.fillColor = [UIColor colorNamed:@"darkgray"].CGColor;
    self.fillLayer.opacity = 1;
    [self.maskView.layer addSublayer:self.fillLayer];
    [self.view addSubview:self.maskView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat newHeight = (self.OriginImage.size.height * (ScreenWidth - 40)/self.OriginImage.size.width) * scrollView.zoomScale;
    CGFloat top =  (scrollView.contentSize.height - newHeight)/2;
    NSLog(@"%f TopSize",top);
    CGPoint trans = [scrollView.panGestureRecognizer translationInView:scrollView];
    
    NSLog(@"%f scrollViewDidScroll",trans.y);
    NSLog(@"%f scrollSize",scrollView.contentSize.height);
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(self.fillLayer.opacity != 1){
        [self.fillLayer removeFromSuperlayer];
        self.fillLayer.opacity = 1;
        [self.maskView.layer addSublayer:self.fillLayer];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(self.fillLayer.opacity != 0.5){
        [self.fillLayer removeFromSuperlayer];
        self.fillLayer.opacity = 0.5;
        [self.maskView.layer addSublayer:self.fillLayer];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (UIImage *)getSubImage
{
    CGRect myImageRect = CGRectMake(ScreenWidth / 2 - MaskCircleSize / 2, ScreenHeight / 2 - MaskCircleSize / 2, MaskCircleSize, MaskCircleSize);
    CGImageRef imageRef = self.imageView.image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    UIGraphicsBeginImageContext(CGSizeMake(MaskCircleSize,MaskCircleSize));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* img = [UIImage imageWithCGImage:subImageRef];
    img = [self imageWithImage:img scaledToSize:CGSizeMake(MaskCircleSize,MaskCircleSize)];
    UIGraphicsEndImageContext();
    return img;
}

-(UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


-(void)SaveImage{
    [UIWindow ShowLoadNoAutoDismiss];
    [self dismissViewToRootController:YES completion:^{
        [self SaveImageToServer];
    }];
}

-(void)SaveImageToServer{
    NSData *file = UIImagePNGRepresentation(self.OriginImage);
    [NetWorkHelper uploadWithUrlPath:[NSString stringWithFormat:@"%@?PhoneNumber=%@&ChangeMessageName=ClientImageUrl",UpdateClientImagePath,[AppUserData GetCurrenUser].phoneNumber] data:file request:nil progress:^(CGFloat percent) {
        NSLog(@"%f",percent);
    } success:^(id data) {
        SuccessResponse *response = [[SuccessResponse alloc] initWithDictionary:data error:nil];
        if([response.status isEqualToString:@"failure"]){
            [UIWindow DissMissLoadWithBlock:^{
                [UIWindow showTips:@"上传失败"];
            }];
        }else{
            [UIWindow DissMissLoadWithBlock:^{
                [UIWindow showTips:@"上传成功"];
                ClientData *data =  [AppUserData GetCurrenUser];
                data.ClientImageUrl = response.msg;
                [AppUserData SavCurrentUser:data];
            }];
        }
    } failure:^(NSError *error) {
        [UIWindow DissMissLoadWithBlock:^{
            [UIWindow showTips:@"服务器走神了哦"];
        }];
    }];
}


@end
