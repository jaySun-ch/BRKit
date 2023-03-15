//
//  CustomCenterButton.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/5.
//

#import "BRCenterButton.h"

@interface BRCenterButton()
@end

@implementation BRCenterButton

-(void)initWithData:(NSString *)title{
    self.Title = [[UILabel alloc] init];
    [self.Title setText:title];
    [self.Title setFont:[UIFont systemFontOfSize:18.0 weight:UIFontWeightBold]];
    self.image = [[UIImageView alloc]initWithImage:[UIImage systemImageNamed:@"chevron.down"]];

    [self.image setTintColor:[UIColor blackColor]];
    [self addSubview:self.Title];
    [self addSubview:self.image];
    
    [self.Title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.mas_equalTo(20);
    }];
    
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.Title.mas_right).inset(5);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(16);
    }];
}

-(void)ResetTitle:(NSString *)title{
    [self.Title setText:title];
}

-(void)RoateIcon:(BOOL)show{
    if(show){
        [UIView animateWithDuration:0.3f animations:^{
            self.image.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }else{
        [UIView animateWithDuration:0.3f animations:^{
            self.image.transform = CGAffineTransformMakeRotation(0);
        }];
      
    }
   
}

@end
