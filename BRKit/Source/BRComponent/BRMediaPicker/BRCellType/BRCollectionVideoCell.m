//
//  BRCollectionVideoCell.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2023/2/17.
//

#import "BRCollectionVideoCell.h"

@interface BRCollectionVideoCell()

@end

@implementation BRCollectionVideoCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.clipsToBounds = YES;
        self.image = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        self.totalTime = [[UILabel alloc] initWithFrame:CGRectMake(0,self.contentView.height - 20, self.contentView.width - 5, 20)];
        self.totalTime.textAlignment = NSTextAlignmentRight;
        self.totalTime.text = @"00:56";
        self.totalTime.font = SmallFont;
        [self.totalTime setTextColor:[UIColor whiteColor]];
        [self addSubview:self.image];
        [self addSubview:self.totalTime];
        self.pickButton = [UIButton new];
        [self.pickButton setImage:[UIImage systemImageNamed:@"checkmark.circle.fill"] forState:UIControlStateNormal];
        [self.pickButton setTintColor:[UIColor whiteColor]];
        self.pickButton.frame = CGRectMake(self.contentView.width - 25, 5, 0, 0);
        [self addSubview:self.pickButton];
    }
    return self;
}

-(void)ShowPickButtonWithAnimation{
    [UIView animateWithDuration:0.2f animations:^{
        self.pickButton.size = CGSizeMake(20, 20);
    }];
}

- (void)prepareForReuse{ 
    [super prepareForReuse];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}


@end
