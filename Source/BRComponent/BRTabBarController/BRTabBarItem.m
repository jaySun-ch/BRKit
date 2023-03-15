//
//  BRTabBarItem.m
//  Academic_exchange
//
//  Created by 孙志雄 on 2023/3/12.
//

#import "BRTabBarItem.h"


@interface BRTabBarItem()
///The Defalut Config
@property (nonatomic) BRTabBarStyleConfig defalutConfig;
@end

@implementation BRTabBarItem

- (instancetype)initWithTitle:(nonnull NSString *)title image:(UIImage * _Nullable )image selectedImage:(UIImage * _Nullable )selectedImage config:(BRTabBarStyleConfig) config{
    self = [super init];
    if(self){
        _defalutConfig = config;
        _title = [[UILabel alloc] init];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = config.textColor;
        _title.frame = CGRectMake(0, 0, AETabBarItemWidth, 20);
        [_title setText:title];
        
        [self addSubview:_title];
        self.frame = CGRectMake(0, 0, AETabBarItemWidth, BRTabBarDefaultHeight);
       
        if(image != NULL){
            _originImage = image;
            _selectedImage = selectedImage;
            _imageView = [[UIImageView alloc] init];
            [_imageView setImage:image];
            _imageView.frame = CGRectMake(0, 0, 30, 30);
            _imageView.contentMode = UIViewContentModeScaleAspectFit;
            _imageView.center = self.center;
            _imageView.tintColor = config.iconTintcolor;
            [self addSubview:_imageView];
            
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self);
                make.centerX.equalTo(self);
                make.width.height.mas_equalTo(30);
            }];
            
            [_title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_imageView.mas_bottom).inset(2);
                make.centerX.equalTo(self);
                make.width.mas_equalTo(AETabBarItemWidth);
                make.height.mas_equalTo(20);
            }];
        }else{
            _title.center = self.center;
        }

    }
    return self;
}

-(void)SetNewStyleWithConfig:(BRTabBarStyleConfig)config{
    self.defalutConfig = config;
    if(config.textColor){
        self.title.textColor = config.textColor;
    }
    
    if(config.iconTintcolor){
        self.imageView.tintColor = config.iconTintcolor;
    }
    
    if(config.imageSize.width != 0 && config.imageSize.height != 0){
        self.imageView.size = config.imageSize;
    }
    
    if(config.titleFont){
        self.title.font = config.titleFont;
    }
    
    if(config.topSpace){
        self.y = config.topSpace;
    }
}

-(void)Selected{
    if(self.defalutConfig.selectedTitleColor){
        self.title.textColor = self.defalutConfig.selectedTitleColor;
    }
    if(self.imageView){
        if(self.defalutConfig.selectedIconTintColor){
            self.imageView.tintColor = self.defalutConfig.selectedIconTintColor;
        }
        if(self.selectedImage){
            [self.imageView setImage:self.selectedImage];
        }
    }

}

-(void)UnSelected{
    self.title.textColor = self.defalutConfig.textColor;
    if(self.imageView){
        self.imageView.tintColor = self.defalutConfig.iconTintcolor;
        if(self.originImage){
            [self.imageView setImage:self.originImage];
        }
    }
}

@end
