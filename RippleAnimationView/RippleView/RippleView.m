//
//  RippleView.m
//  RippleAnimationView
//
//  Created by fitloft on 2018/9/12.
//  Copyright © 2018年 Nick. All rights reserved.
//

#import "RippleView.h"
#define ColorWithAlpha(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface RippleView ()<CAAnimationDelegate>
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
        [self addAnimationLayer];
    }
    return self;
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}


- (void)addAnimationLayer {
    CGFloat width = self.frame.size.width - 2;
    
    _rippleLayer1 = [CALayer layer];
    _rippleLayer1.frame = CGRectMake((self.frame.size.width -width)/2, (self.frame.size.width -width)/2, width, width);
    _rippleLayer1.cornerRadius = width/2;
    _rippleLayer1.borderColor = self.rippleColor?self.rippleColor.CGColor:ColorWithAlpha(255, 216, 87, 0.5).CGColor;
    _rippleLayer1.borderWidth = 0.5;
    [self.layer addSublayer:_rippleLayer1];
    
    _rippleLayer2 = [CALayer layer];
    _rippleLayer2.frame = CGRectMake((self.frame.size.width -width)/2, (self.frame.size.width -width)/2, width, width);
    _rippleLayer2.cornerRadius = width/2;
    _rippleLayer2.borderColor = self.rippleColor?self.rippleColor.CGColor:ColorWithAlpha(255, 216, 87, 0.5).CGColor;
    _rippleLayer2.borderWidth = 0.5;
    [self.layer addSublayer:_rippleLayer2];
    
    _rippleLayer3 = [CALayer layer];
    _rippleLayer3.frame = CGRectMake((self.frame.size.width -width)/2, (self.frame.size.width -width)/2, width, width);
    _rippleLayer3.cornerRadius = width/2;
    _rippleLayer3.borderColor = self.rippleColor?self.rippleColor.CGColor:ColorWithAlpha(255, 216, 87, 0.5).CGColor;
    _rippleLayer3.borderWidth = 0.5;
    [self.layer addSublayer:_rippleLayer3];
    
    _rippleLayer1.hidden = YES;
    _rippleLayer2.hidden = YES;
    _rippleLayer3.hidden = YES;
}

//修改的可能有问题
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.frame.size.width - 2;
    _rippleLayer1.frame = CGRectMake((self.frame.size.width -width)/2, (self.frame.size.width -width)/2, width, width);
    _rippleLayer2.frame = CGRectMake((self.frame.size.width -width)/2, (self.frame.size.width -width)/2, width, width);
    _rippleLayer3.frame = CGRectMake((self.frame.size.width -width)/2, (self.frame.size.width -width)/2, width, width);
    _rippleLayer1.cornerRadius = width/2;
    _rippleLayer2.cornerRadius = width/2;
    _rippleLayer3.cornerRadius = width/2;
}

- (void)setRippleColor:(UIColor *)rippleColor{
    _rippleColor = rippleColor;
    _rippleLayer1.borderColor = _rippleColor.CGColor;
    _rippleLayer2.borderColor = _rippleColor.CGColor;
    _rippleLayer3.borderColor = _rippleColor.CGColor;
}

- (void)startAnimation {
    if (!_rippleLayer1) {
        [self addAnimationLayer];
    }
    _rippleLayer1.hidden = NO;
    _rippleLayer2.hidden = NO;
    _rippleLayer3.hidden = NO;
    [_rippleLayer1 addAnimation:[self rippleAnimationGroupWithIndex:0] forKey:@"ripple"];
    [_rippleLayer2 addAnimation:[self rippleAnimationGroupWithIndex:1] forKey:@"ripple"];
    [_rippleLayer3 addAnimation:[self rippleAnimationGroupWithIndex:2] forKey:@"ripple"];
}

- (void)startRipplrWithShowAnimation{
    self.hidden = NO;
    [self startAnimation];
//    [self show];
//    [self performSelector:@selector(startAnimation) withObject:nil afterDelay:0.4];
}

- (void)stopAnimation{
    _rippleLayer1.hidden = YES;
    _rippleLayer2.hidden = YES;
    _rippleLayer3.hidden = YES;
    [_rippleLayer1 removeAllAnimations];
    [_rippleLayer2 removeAllAnimations];
    [_rippleLayer3 removeAllAnimations];
}

- (void)stopRippleWithHiddenAnimation{
//    [self hiddenAnimation];
//    [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:0.3];
    [self stopAnimation];
    self.hidden = YES;
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
    animate.values = @[(__bridge id) [self.rippleColor colorWithAlphaComponent:0.5].CGColor ? (__bridge id) [self.rippleColor colorWithAlphaComponent:0.5].CGColor : (__bridge id)ColorWithAlpha(255, 216, 87, 0.5).CGColor,
                       (__bridge id) [self.rippleColor colorWithAlphaComponent:0.4].CGColor ? (__bridge id) [self.rippleColor colorWithAlphaComponent:0.4].CGColor : (__bridge id)ColorWithAlpha(255,231,152,0.4).CGColor,
                       (__bridge id) [self.rippleColor colorWithAlphaComponent:0.2].CGColor ? (__bridge id) [self.rippleColor colorWithAlphaComponent:0.2].CGColor : (__bridge id)ColorWithAlpha(255, 241, 197, 0.2).CGColor,
                       (__bridge id) [self.rippleColor colorWithAlphaComponent:0].CGColor ? (__bridge id) [self.rippleColor colorWithAlphaComponent:0].CGColor : (__bridge id)ColorWithAlpha(255, 241, 197, 0).CGColor
                       ];
    animate.keyTimes = @[@0.3,@0.6,@0.9,@1];
    return animate;
}

- (CAKeyframeAnimation *)borderColorAnimate{
    CAKeyframeAnimation * animate = [CAKeyframeAnimation animation];
    animate.keyPath = @"borderColor";
    animate.values = @[(__bridge id) [self.rippleColor colorWithAlphaComponent:0.5].CGColor ? (__bridge id) [self.rippleColor colorWithAlphaComponent:0.5].CGColor : (__bridge id)ColorWithAlpha(255, 216, 87, 0.5).CGColor,
                       (__bridge id) [self.rippleColor colorWithAlphaComponent:0.4].CGColor ? (__bridge id) [self.rippleColor colorWithAlphaComponent:0.4].CGColor : (__bridge id)ColorWithAlpha(255,231,152,0.4).CGColor,
                       (__bridge id) [self.rippleColor colorWithAlphaComponent:0.2].CGColor ? (__bridge id) [self.rippleColor colorWithAlphaComponent:0.2].CGColor : (__bridge id)ColorWithAlpha(255, 241, 197, 0.2).CGColor,
                       (__bridge id) [self.rippleColor colorWithAlphaComponent:0].CGColor ? (__bridge id) [self.rippleColor colorWithAlphaComponent:0].CGColor : (__bridge id)ColorWithAlpha(255, 241, 197, 0).CGColor
                       ];
    animate.keyTimes = @[@0.3,@0.6,@0.9,@1];
    return animate;
}

- (void)show{
    self.hidden = NO;
    CABasicAnimation * scaleAni = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAni.fromValue = @0.0;
    scaleAni.toValue = @1.0;
    
    CABasicAnimation * alphaAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAni.fromValue = @0.0;
    alphaAni.toValue = @1.0;
    
    CAAnimationGroup * group = [CAAnimationGroup animation];
    group.animations = @[scaleAni,alphaAni];
    group.beginTime = CACurrentMediaTime();
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.duration = 0.15;
    group.repeatCount = 0;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.delegate = self;
    [self.layer addAnimation:group forKey:@"ShowAnimation"];
}

- (void)hiddenAnimation{
    CABasicAnimation * scaleAni = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAni.fromValue = @1.0;
    scaleAni.toValue = @0.0;
    
    CABasicAnimation * alphaAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAni.fromValue = @1.0;
    alphaAni.toValue = @0.0;
    
    CAAnimationGroup * group = [CAAnimationGroup animation];
    group.animations = @[scaleAni,alphaAni];
    group.beginTime = CACurrentMediaTime();
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.duration = 0.15;
    group.repeatCount = 0;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.delegate = self;
    
    [self.layer addAnimation:group forKey:@"HiddenAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    CAAnimation * showAnimation = [self.layer animationForKey:@"ShowAnimation"];
    CAAnimation * hiddenAnimation = [self.layer animationForKey:@"HiddenAnimation"];
    
    if ([anim isEqual:showAnimation]) {
        [self.layer removeAnimationForKey:@"ShowAnimation"];
    }else if ([anim isEqual:hiddenAnimation]){
        self.hidden = YES;
        [self.layer removeAnimationForKey:@"HiddenAnimation"];
    }
}

@end
