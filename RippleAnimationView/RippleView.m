//
//  RippleView.m
//  RippleAnimationView
//
//  Created by fitloft on 2018/9/12.
//  Copyright © 2018年 Nick. All rights reserved.
//

#import "RippleView.h"
#define ColorWithAlpha(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface RippleView ()
@property (nonatomic, strong) CALayer * rippleLayer1;
@property (nonatomic, strong) CALayer * rippleLayer2;
@property (nonatomic, strong) CALayer * rippleLayer3;

@end

@implementation RippleView

- (instancetype )initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.layer.masksToBounds = NO;
        self.clipsToBounds = NO;
    }
    return self;
}

-(void)creatRippleAnimate{
    
    
    _rippleLayer1 = [CALayer layer];
    _rippleLayer1.frame = self.bounds;
    _rippleLayer1.cornerRadius = self.frame.size.width/2;
    _rippleLayer1.borderColor = self.rippleColor?self.rippleColor.CGColor:ColorWithAlpha(255, 216, 87, 0.5).CGColor;
    _rippleLayer1.borderWidth = 0.5;
    [self.layer addSublayer:_rippleLayer1];
    
    _rippleLayer2 = [CALayer layer];
    _rippleLayer2.frame = self.bounds;
    _rippleLayer2.cornerRadius = self.frame.size.width/2;
    _rippleLayer2.borderColor = self.rippleColor?self.rippleColor.CGColor:ColorWithAlpha(255, 216, 87, 0.5).CGColor;
    _rippleLayer2.borderWidth = 0.5;
    [self.layer addSublayer:_rippleLayer2];
    
    _rippleLayer3 = [CALayer layer];
    _rippleLayer3.frame = self.bounds;
    _rippleLayer3.cornerRadius = self.frame.size.width/2;
    _rippleLayer3.borderColor = self.rippleColor?self.rippleColor.CGColor:ColorWithAlpha(255, 216, 87, 0.5).CGColor;
    _rippleLayer3.borderWidth = 0.5;
    [self.layer addSublayer:_rippleLayer3];
    
    UIView * centerView = [[UIView alloc] initWithFrame:self.bounds];
    centerView.backgroundColor = self.centerColor?self.centerColor:[UIColor whiteColor];
    centerView.layer.cornerRadius = self.bounds.size.width/2;
    centerView.layer.masksToBounds = YES;
    [self addSubview:centerView];

    [_rippleLayer1 addAnimation:[self rippleAnimationGroupWithIndex:0] forKey:@"ripple"];
    [_rippleLayer2 addAnimation:[self rippleAnimationGroupWithIndex:1] forKey:@"ripple"];
    [_rippleLayer3 addAnimation:[self rippleAnimationGroupWithIndex:2] forKey:@"ripple"];

}

- (CAAnimationGroup *)rippleAnimationGroupWithIndex:(NSInteger )index{
    NSArray * animateArr = @[[self scaleAnimate] , [self gradualAnimate] , [self borderColorAnimate]];
    CAAnimationGroup * group = [CAAnimationGroup animation];
    group.animations = animateArr;
    group.beginTime = CACurrentMediaTime() + (double)index * 0.5;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    group.duration = self.singleRippleDuration>0?self.singleRippleDuration:2.5;
    group.repeatCount = HUGE;
    group.removedOnCompletion = NO;
    return group;
}

- (CABasicAnimation *)scaleAnimate{
    CABasicAnimation * scaleAnimate = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimate.repeatCount = HUGE;
    scaleAnimate.fromValue = @(1.0);
    scaleAnimate.toValue = self.scaleTimes?@(self.scaleTimes):@(3.0);
    return scaleAnimate;
}

- (CAKeyframeAnimation *)gradualAnimate{
    CAKeyframeAnimation * animate = [CAKeyframeAnimation animation];
    animate.keyPath = @"backgroundColor";
    animate.values = @[(__bridge id)ColorWithAlpha(255, 216, 87, 0.5).CGColor,
                       (__bridge id)ColorWithAlpha(255,231,152,0.4).CGColor,
                       (__bridge id)ColorWithAlpha(255, 241, 197, 0.2).CGColor,
                       (__bridge id)ColorWithAlpha(255, 241, 197, 0).CGColor
                       ];
    animate.keyTimes = @[@0.3,@0.6,@0.9,@1];
    return animate;
}

- (CAKeyframeAnimation *)borderColorAnimate{
    CAKeyframeAnimation * animate = [CAKeyframeAnimation animation];
    animate.keyPath = @"borderColor";
    animate.values = @[(__bridge id)ColorWithAlpha(255, 216, 87, 0.5).CGColor,
                       (__bridge id)ColorWithAlpha(255,231,152,0.4).CGColor,
                       (__bridge id)ColorWithAlpha(255, 241, 197, 0.2).CGColor,
                       (__bridge id)ColorWithAlpha(255, 241, 197, 0).CGColor
                       ];
    animate.keyTimes = @[@0.3,@0.6,@0.9,@1];
    return animate;
}

@end
