//
//  CricleView.m
//  CricleProgressView
//
//  Created by fitloft on 2019/1/11.
//  Copyright © 2019年 Nick. All rights reserved.
//

#import "CricleView.h"

@interface CricleView ()
@property (nonatomic, strong) CAShapeLayer * progressLayer;
@property (nonatomic, strong) UIView * dotView;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat oldProgress;

@end

@implementation CricleView

- (instancetype )initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];  
    }
    return self;
}

- (void)setProgressColor:(UIColor *)progressColor{
    _progressColor = progressColor;
    if (_dotView) {
        _dotView.backgroundColor = progressColor;
    }
    [self setNeedsDisplay];
}

- (UIView *)dotView{
    if (!_dotView) {
        CGFloat dotWidth = (self.progressWidth>0?self.progressWidth:4) * 2.5;
        _dotView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - dotWidth)/2 , -(dotWidth - self.progressWidth)/2 , dotWidth , dotWidth)];
        _dotView.layer.cornerRadius = dotWidth/2;
        _dotView.layer.masksToBounds = YES;
        _dotView.backgroundColor = self.progressColor?self.progressColor:[UIColor redColor];
        [self addSubview:_dotView];
        
    }
    return _dotView;
}

- (void)updateCricleProgress:(CGFloat )progress{
    self.oldProgress = self.progress;
    self.progress = progress;
    [self updateDotViewPosition];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    CGPoint center = CGPointMake(self.frame.size.width /2, self.frame.size.width /2);
    CGFloat radius = self.frame.size.width/2 - self.progressWidth/2;
    CGFloat startA = -M_PI_2;  //设置进度条起点位置
    CGFloat endA =  -M_PI_2 + M_PI * 2 * _progress;  //设置进度条终点位置

    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];//创建一个track shape layer
    }
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor = [[UIColor clearColor] CGColor];  //填充色为无色
    _progressLayer.strokeColor = [self.progressColor?self.progressColor:[UIColor redColor] CGColor]; //指定path的渲染颜色,这里可以设置任意不透明颜色
    _progressLayer.opacity = 1; //背景颜色的透明度
    _progressLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    _progressLayer.lineWidth = self.progressWidth;//线的宽度
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];//上面说明过了用来构建圆形
    _progressLayer.path =[path CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    
    [self.layer addSublayer:_progressLayer];
    [self bringSubviewToFront:self.dotView];
    
    
//    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    animation.fromValue = @(startA);
//    animation.toValue = @(endA);
//    _progressLayer.autoreverses = NO;
//    animation.duration = _progress * self.maxSeconds;
//    
//    [_progressLayer addAnimation:animation forKey:@"TimingAnimation"];
}

-(void)updateDotViewPosition
{
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.duration = (CGFloat)(self.progress - self.oldProgress)*self.maxSeconds;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = 0;
    animation.calculationMode = kCAAnimationCubicPaced;
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathAddArc(curvedPath, NULL, self.center.x, self.center.y, self.frame.size.width/2 - 2, -M_PI_2 + M_PI * 2 * self.oldProgress, -M_PI_2 + M_PI * 2 * self.progress, 0);
    animation.path = curvedPath;
    [self.dotView.layer addAnimation:animation forKey:nil];
    
    //移动到最前
    [self bringSubviewToFront:
    self.dotView];
}

@end
