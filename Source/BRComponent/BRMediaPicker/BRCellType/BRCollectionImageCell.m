//
//  BRCollectionImageCell.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2023/2/17.
//

#import "BRCollectionImageCell.h"

@interface BRCollectionImageCell()

@end

@implementation BRCollectionImageCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.clipsToBounds = YES;
        self.image = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        self.image.contentMode = UIViewContentModeScaleAspectFill;
        self.pickImage = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"circle"]];
        self.pickImage.frame = CGRectMake(self.width - 30, 5, 25, 25);
        self.pickImage.tintColor = [UIColor whiteColor];
        [self addSubview:self.image];
        [self.image addSubview:self.pickImage];
    }
    return self;
}

-(void)ShowPickAnimation{
    self.pickImage.image = [UIImage systemImageNamed:@"checkmark.circle.fill"];
    [self.pickImage setHidden:NO];
    self.pickImage.tintColor = [UIColor greenColor];
    [self.pickImage.layer removeAllAnimations];
    CAKeyframeAnimation *scaleAnimation = [[CAKeyframeAnimation alloc] init];
    scaleAnimation.duration = 0.2f;
    scaleAnimation.keyPath = @"transform.scale";
    [scaleAnimation setValues:@[
        [NSNumber numberWithFloat:1.0],
        [NSNumber numberWithFloat:0.8],
        [NSNumber numberWithFloat:1.0],
    ]];
    [self.pickImage.layer addAnimation:scaleAnimation forKey:@"animation"];
}

-(void)DisimissPick{
    self.pickImage.tintColor = [UIColor whiteColor];
    self.pickImage.image = [UIImage systemImageNamed:@"circle"];
}

- (void)prepareForReuse{
    [super prepareForReuse];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

@end
