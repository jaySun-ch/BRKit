//
//  BRTableCell.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2023/2/19.
//

#import "BRHeadTableCell.h"

@interface BRHeadTableCell()
@property (nonatomic,strong) UIImageView *image;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UILabel *subtitle;
@end

@implementation BRHeadTableCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initSubViews];
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}


-(void)initSubViews{
    self.image = [[UIImageView alloc] init];
    self.image.contentMode = UIViewContentModeScaleAspectFill;
    self.image.clipsToBounds = YES;
    [self addSubview:self.image];
    self.title = [[UILabel alloc] init];
    [self.title setFont:[UIFont systemFontOfSize:15.0 weight:UIFontWeightBold]];
    [self addSubview:self.title];
    self.subtitle = [[UILabel alloc]init];
    [self.subtitle setTintColor:[UIColor systemGrayColor]];
    [self.subtitle setFont:[UIFont systemFontOfSize:12.0]];
    [self addSubview:self.subtitle];
    
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).inset(20);
        make.height.width.mas_equalTo(80);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image.mas_right).inset(5);
        make.top.equalTo(self).inset(20);
        make.height.mas_equalTo(15);
    }];
    
    [self.subtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image.mas_right).inset(5);
        make.top.equalTo(self.title.mas_bottom).inset(10);
        make.height.mas_equalTo(15);
    }];
}

-(void)initWithData:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle{
    [self.image setImage:image];
    [self.title setText:title];
    [self.subtitle setText:subtitle];
}

@end
