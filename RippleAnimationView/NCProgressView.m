//
//  NCProgressView.m
//  RippleAnimationView
//
//  Created by fitloft on 2018/9/13.
//  Copyright © 2018年 Nick. All rights reserved.
//

#import "NCProgressView.h"

@interface NCProgressView ()
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIView * dotView;

@property (nonatomic, strong) UIView * rootBackView;

@property (nonatomic, strong) UIView * centerBackView;

@property (nonatomic, strong) CAShapeLayer * progressLayer;
@property (nonatomic, assign) CGFloat progress;
@end

@implementation NCProgressView

- (instancetype )initWithFrame:(CGRect)frame withProgressType:(ProgressType)progressType{
    if (self = [super initWithFrame:frame]) {
        self.width = frame.size.width;
        self.progressType = progressType;
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];

        [self rootBackView];
        [self centerBackView];
        [self centerIcon];
        [self timeLabel];
    }
    return self;
}

- (void)setCenterIcon:(UIImage *)centerIcon{
    _centerIcon = centerIcon;
    self.iconView.image = centerIcon;
}

- (UIView *)rootBackView{
    if (!_rootBackView) {
        _rootBackView = [[UIView alloc] initWithFrame:self.bounds];
        _rootBackView.layer.cornerRadius = self.frame.size.width/2;
        _rootBackView.layer.masksToBounds = YES;
        [self addSubview:_rootBackView];
    }
    return _rootBackView;
}

- (UIView *)centerBackView{
    if (!_centerBackView) {
        _centerBackView = [[UIView alloc] init];
        [self addSubview:_centerBackView];
    }
    return _centerBackView;
}

-(void)setProgressWidth:(CGFloat)progressWidth{
    _progressWidth = progressWidth;
    self.centerBackView.frame = CGRectMake(progressWidth, progressWidth, self.frame.size.width - progressWidth*2, self.frame.size.width - progressWidth*2);
    self.centerBackView.layer.cornerRadius = (self.frame.size.width - progressWidth*2)/2;
    self.centerBackView.layer.masksToBounds = YES;
}

- (void)setCenterColor:(UIColor *)centerColor{
    _centerColor = centerColor;
    self.centerBackView.backgroundColor = centerColor;
}

- (void)setProgressBackColor:(UIColor *)progressBackColor{
    _progressBackColor = progressBackColor;
    self.rootBackView.backgroundColor = progressBackColor;
}

- (void)updateProgress:(CGFloat )percent{
    self.progress = percent;
    [self.progressLayer removeFromSuperlayer];
    [self updateEndPoint];
    if (self.progressType == ProgressType_Percent) {
        self.timeLabel.text = [[NSString stringWithFormat:@"%.2f",percent * 100] stringByAppendingString:@"%"];
    }else{
        self.timeLabel.text = [NSString stringWithFormat:@"%d",(int)(percent * self.maxTimeInterval)] ;
    }
    [self setNeedsDisplay];
}

- (UIImageView *)iconView{
    if (!_iconView) {
        CGFloat imageWidth = self.centerIcon.size.width;
        CGFloat imageHeight = self.centerIcon.size.height;
        CGFloat centerWidth = self.frame.size.width - self.progressWidth;
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake((centerWidth - imageWidth)/2, self.progressWidth + centerWidth/3 -imageHeight/2 , imageWidth, imageHeight)];
        _iconView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        _iconView.layer.cornerRadius = (self.width - self.progressWidth)/2;
        _iconView.layer.masksToBounds = YES;
        _iconView.clipsToBounds = YES;
        [self addSubview:_iconView];
    }
    return _iconView;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.progressWidth, (self.width - self.progressWidth)*2/3 + self.progressWidth, self.width - self.progressWidth, 20)];
        self.timeFont = self.timeFont?self.timeFont:[UIFont systemFontOfSize:13];
        self.timeColor = self.timeColor?self.timeColor:[UIColor blackColor];
        _timeLabel.font = self.timeFont;
        _timeLabel.textColor = self.timeColor;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
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

- (void)drawRect:(CGRect)rect{
    [self drawCycleProgress];
}

- (void)drawCycleProgress{
    CGPoint center = CGPointMake(self.frame.size.width /2, self.frame.size.width /2);
    CGFloat radius = self.frame.size.width/2 - self.progressWidth/2;
    CGFloat startA = -M_PI_2;  //设置进度条起点位置
    CGFloat endA =  -M_PI_2 + M_PI * 2 * _progress;  //设置进度条终点位置
    
    
    //获取环形路径（画一个圆形，填充色透明，设置线框宽度为10，这样就获得了一个环形）
    _progressLayer = [CAShapeLayer layer];//创建一个track shape layer
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor = [[UIColor clearColor] CGColor];  //填充色为无色
    _progressLayer.strokeColor = [self.progressColor?self.progressColor:[UIColor redColor] CGColor]; //指定path的渲染颜色,这里可以设置任意不透明颜色
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
    float radius = self.frame.size.width/2 - self.progressWidth/2;;
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
