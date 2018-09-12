//
//  RippleAnimateView.m
//  RippleAnimationView
//
//  Created by fitloft on 2018/9/11.
//  Copyright © 2018年 Nick. All rights reserved.
//

#import "RippleAnimateView.h"
#import <QuartzCore/QuartzCore.h>
#import "RippleView.h"

@interface RippleAnimateView ()<CAAnimationDelegate>
@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) CAShapeLayer * progressLayer;
@property (nonatomic, strong) CAShapeLayer * dotLayer;
@property (nonatomic, strong) UIView * dotView;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) RippleView * rippleView;


@end

@implementation RippleAnimateView

- (instancetype )initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initParam];
        [self creatBackView];
    }
    return self;
}

- (void)updateProgress:(CGFloat )percent{
    self.progress = percent;
    [self.progressLayer removeFromSuperlayer];
    [self updateEndPoint];
    [self setNeedsDisplay];
}

- (void)setCenterIcon:(UIImage *)centerIcon{
    self.iconView.image = centerIcon;
    [self bringSubviewToFront:self.iconView];
}

- (void)initParam{
    self.rippleColor = [UIColor yellowColor];
    self.fixedWidth = 100;
    self.progressWidth = 4;
    self.progressBackColor = [UIColor lightGrayColor];
    self.progressColor = [UIColor colorWithRed:254/255.0 green:155/255.0 blue:51/255.0 alpha:1];
}

- (void)creatBackView{
    
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    self.clipsToBounds = NO;
    
    
    CGFloat width = self.fixedWidth + self.progressWidth * 2;
    _backView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - width)/2, (self.frame.size.width - width)/2, width, width)];
    _backView.backgroundColor = self.progressBackColor;
    _backView.layer.cornerRadius = width/2;
    _backView.layer.masksToBounds = YES;
    [self addSubview:_backView];
    
    self.rippleView = [[RippleView alloc] initWithFrame:CGRectMake((self.frame.size.width - width)/2, (self.frame.size.width - width)/2, width, width)];
    [self addSubview:self.rippleView];
    [self.rippleView creatRippleAnimate];
}

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - self.fixedWidth)/2, (self.frame.size.width - self.fixedWidth)/2, self.fixedWidth, self.fixedWidth)];
        _iconView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        _iconView.layer.cornerRadius = self.fixedWidth/2;
        _iconView.layer.masksToBounds = YES;
        _iconView.clipsToBounds = YES;
        [self addSubview:_iconView];
    }
    return _iconView;
}

- (UIView *)dotView{
    if (!_dotView) {
        CGFloat radius = self.fixedWidth/2 + self.progressWidth/2;
        CGFloat x = radius + sinf(0)*radius;
        CGFloat y = radius - cosf(0)*radius;
        _dotView = [[UIView alloc] initWithFrame:CGRectMake(x -3, y - 3, 10, 10)];
        _dotView.layer.cornerRadius = 5;
        _dotView.layer.masksToBounds = YES;
        _dotView.backgroundColor = self.progressColor;
        [self addSubview:_dotView];
    }
    return _dotView;
}

- (void)drawRect:(CGRect)rect{
    [self drawCycleProgress];

}


- (void)drawCycleProgress{
    CGPoint center = CGPointMake(self.frame.size.width /2, self.frame.size.width /2);
    CGFloat radius = self.fixedWidth/2 + self.progressWidth/2;
    CGFloat startA = -M_PI_2;  //设置进度条起点位置
    CGFloat endA =  -M_PI_2 + M_PI * 2 * _progress;  //设置进度条终点位置
    
    
    //获取环形路径（画一个圆形，填充色透明，设置线框宽度为10，这样就获得了一个环形）
    _progressLayer = [CAShapeLayer layer];//创建一个track shape layer
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor = [[UIColor clearColor] CGColor];  //填充色为无色
    _progressLayer.strokeColor = [self.progressColor CGColor]; //指定path的渲染颜色,这里可以设置任意不透明颜色
    _progressLayer.opacity = 1; //背景颜色的透明度
    _progressLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    _progressLayer.lineWidth = self.progressWidth;//线的宽度
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];//上面说明过了用来构建圆形
    _progressLayer.path =[path CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    
    [self.layer addSublayer:_progressLayer];
    [self bringSubviewToFront:self.dotView];
    
}

//更新小点的位置
-(void)updateEndPoint
{
    //转成弧度
    CGFloat angle =  M_PI*2*_progress;
    float radius = self.fixedWidth/2 + self.progressWidth/2;
    int index = _progress / 0.25;//用户区分在第几象限内
    float needAngle = 0;
    float x = 0,y = 0;//用于保存_dotView的frame
    switch (index) {
        case 0:
            NSLog(@"第一象限");
            x = radius + sinf(angle)*radius;
            y = radius - cosf(angle)*radius;
            break;
        case 1:
            NSLog(@"第四象限");
            needAngle = M_PI  - angle + M_PI_2;
            x = radius - cosf(needAngle)*radius;
            y = radius + sinf(needAngle)*radius;
            break;
        case 2:
            NSLog(@"第三象限");
            needAngle = M_PI_2 * 3 - angle + M_PI_2;
            x = radius - sinf(needAngle)*radius;
            y = radius - cosf(needAngle)*radius;
            break;
        case 3:
            NSLog(@"第二象限");
            needAngle = M_PI * 2 - angle + M_PI_2;
            x = radius + cosf(needAngle)*radius;
            y = radius - sinf(needAngle)*radius;
            break;
        case 4:
            NSLog(@"第二象限");
            needAngle = M_PI * 2 - angle + M_PI_2;
            x = radius + cosf(needAngle)*radius;
            y = radius - sinf(needAngle)*radius;
            break;
            
        default:
            break;
    }
    
    //更新圆环的frame
    CGRect rect = self.dotView.frame;
    rect.origin.x = x - 3;
    rect.origin.y = y - 3;
    self.dotView.frame = rect;
    //移动到最前
    
    [self bringSubviewToFront:self.dotView];

}

@end
