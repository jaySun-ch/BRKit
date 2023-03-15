//
//  UIView+BRExtension.m
//  Academic_exchange
//
//  Created by 孙志雄 on 2023/3/12.
//

#import "UIView+BRExtension.h"

@implementation UIView (BRExtension)


-(CGFloat)x{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x{
    CGRect originFrame = self.frame;
    originFrame.origin = CGPointMake(x, self.frame.origin.y);
    self.frame = originFrame;
}

-(CGFloat)y{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y{
    CGRect originFrame = self.frame;
    originFrame.origin = CGPointMake(self.frame.origin.x,y);
    self.frame = originFrame;
}

-(CGPoint)origin{
    return self.frame.origin;
}

-(void)setOrigin:(CGPoint)origin{
    CGRect originFrame = self.frame;
    originFrame.origin = origin;
    self.frame = originFrame;
}

- (CGSize)size{
    return self.frame.size;
}

- (void)setSize:(CGSize)size{
    CGRect originFrame = self.frame;
    originFrame.size = size;
    self.frame = originFrame;
}

- (CGFloat)centerX{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX{
    CGPoint orgincenter = self.center;
    orgincenter.x = centerX;
    self.center = orgincenter;
}

- (CGFloat)centerY{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint orgincenter = self.center;
    orgincenter.y = centerY;
    self.center = orgincenter;
}

- (CGFloat)height{
    return self.size.height;
}

- (void)setHeight:(CGFloat)height{
    CGSize originsize = self.size;
    originsize.height = height;
    self.size = originsize;
}

- (CGFloat)width{
    return self.size.width;
}

- (void)setWidth:(CGFloat)width{
    CGSize originsize = self.size;
    originsize.width = width;
    self.size = originsize;
}



@end
