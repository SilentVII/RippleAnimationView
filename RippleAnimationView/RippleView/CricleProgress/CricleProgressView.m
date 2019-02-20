//
//  CricleProgressView.m
//  CricleProgressView
//
//  Created by fitloft on 2019/1/11.
//  Copyright © 2019年 Nick. All rights reserved.
//

#import "CricleProgressView.h"
#import "CricleView.h"

#define UIColorFromHexWithAlpha(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a]

@interface CricleProgressView ()<CAAnimationDelegate>
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) CricleView * cricleView;
@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UIView * centerView;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, assign) BOOL isAutoRun;

@end

@implementation CricleProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.opacity = 0;
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        
        self.backView = [[UIView alloc] initWithFrame:self.bounds];
        self.backView.layer.cornerRadius = frame.size.width / 2;
        self.backView.layer.masksToBounds = YES;
        self.backView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        [self addSubview:self.backView];
        
        self.centerView = [[UIView alloc] initWithFrame:CGRectMake(4, 4, self.frame.size.width - 8, self.frame.size.width - 8)];
        self.centerView.backgroundColor = [UIColor whiteColor];
        self.centerView.layer.cornerRadius = self.frame.size.width/2 - 4;
        self.centerView.layer.masksToBounds = YES;
        [self addSubview:self.centerView];
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    self.backView.backgroundColor = backgroundColor;
}

- (void)setProgressColor:(UIColor *)progressColor{
    if (progressColor) {
        self.cricleView.progressColor = progressColor;
    }
}

- (void)setCenterIconName:(NSString *)centerIconName{
    _centerIconName = centerIconName;
    self.iconView.image = [UIImage imageNamed:centerIconName];
}

- (void)setCenterColor:(UIColor *)centerColor{
    _centerColor = centerColor;
    self.centerView.backgroundColor = _centerColor;
}

- (void)setStatus:(ProgressStatus)status{
    _status = status;
    !_statusChangedBlock?:_statusChangedBlock(_status);
}

- (void)setTextType:(ProgressTextType)textType{
    _textType = textType;
    if (_textType == ProgressTextType_uncarryTiming) {
        self.timeLabel.text = [NSString stringWithFormat:@"%ds",self.maxSeconds - (int)self.progress];
    }else{
        int seconds = self.progress;
        if (seconds > 60) {
            int minute = seconds / 60;
            seconds = seconds % 60;
            self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",minute,seconds];
        }else{
            self.timeLabel.text = [NSString stringWithFormat:@"00:%02d",(int)self.progress];
        }
    }
}

- (UIImageView *)iconView{
    if (!_iconView) {
        CGFloat maxSide = MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width);
        CGRect rect = CGRectMake((self.bounds.size.width - maxSide * 29 /667)/2, maxSide * 12 /667, maxSide * 29 /667, maxSide * 29 /667);
        _iconView = [[UIImageView alloc] initWithFrame:rect];
        [self addSubview:_iconView];
//        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self);
//            make.top.equalTo(self).offset(ScreenHeightRatio(12));
//            make.width.height.equalTo(@(ScreenHeightRatio(29)));
//        }];
    }
    return _iconView;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, self.frame.size.height*2/3 - 6, self.frame.size.width - 12, 15)];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_timeLabel];
    }
    [self bringSubviewToFront:_timeLabel];
    return _timeLabel;
}

- (void)run{
    if (!self.isShowing) {
        return;
    }
    
    if (self.status == ProgressStatus_unKnown || self.status == ProgressStatus_Canceld || self.status == ProgressStatus_Completed) {
        [self.timer setFireDate:[NSDate distantPast]];
        self.status = ProgressStatus_Timing;
    }
}

- (void)pause{
    if (!self.isShowing) {
        return;
    }
    
    if (self.status == ProgressStatus_Timing || self.status == ProgressStatus_unKnown) {
        [self.timer setFireDate:[NSDate distantFuture]];
        self.status = ProgressStatus_Paused;
    }
}

- (void)resume{
    if (!self.isShowing) {
        return;
    }
    
    if (self.status == ProgressStatus_Paused) {
        [self.timer setFireDate:[NSDate date]];
        self.status = ProgressStatus_Timing;
    }
}

- (void)cancel{
    if (!self.isShowing) {
        return;
    }
    if (self.status == ProgressStatus_Timing || self.status == ProgressStatus_Paused) {
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        self.status = ProgressStatus_Canceld;
        self.progress = 0;
        if (self.textType == ProgressTextType_carryTiming) {
            self.timeLabel.text = @"00:00";
        }else{
            self.timeLabel.text = [NSString stringWithFormat:@"%02ds",self.maxSeconds];
        }
    }
}

- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (CricleView *)cricleView{
    if (!_cricleView) {
        _cricleView = [[CricleView alloc] initWithFrame:self.bounds];
        _cricleView.progressColor = UIColorFromHexWithAlpha(0x2877FC,1);
        _cricleView.maxSeconds = self.maxSeconds;
        _cricleView.progressWidth = 4;
        [self addSubview:_cricleView];
        [self bringSubviewToFront:_cricleView];
    }
    return _cricleView;
}

- (void)timerRun{
    [self bringSubviewToFront:self.iconView];
    if (self.progress >= self.maxSeconds) {
        self.status = ProgressStatus_Completed;
        [_timer invalidate];
        _timer = nil;
        self.progress = 0;
        return;
    }
    self.progress += 0.05;
    [self.cricleView updateCricleProgress:self.progress/self.maxSeconds];
    if (_textType == ProgressTextType_uncarryTiming) {
        self.timeLabel.text = [NSString stringWithFormat:@"%ds",self.maxSeconds - (int)self.progress];
    }else{
        int seconds = self.progress;
        if (seconds > 60) {
            int minute = seconds / 60;
            seconds = seconds % 60;
            self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",minute,seconds];
        }else{
            self.timeLabel.text = [NSString stringWithFormat:@"00:%02d",(int)self.progress];
        }
    }
}

- (void)showWithScaleAnimationAndRun:(BOOL )isAutoRun{
    if (self.isShowing) {
        return;
    }
    _isAutoRun = isAutoRun;
    
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
    
    [self.layer addAnimation:group forKey:@"ScaleShow"];
}

- (void)hiddenWithScaleAnimation{
    if (!self.isShowing) {
        return;
    }
    
    if (_timer && (self.status == ProgressStatus_Timing || self.status == ProgressStatus_Paused)) {
        [self cancel];
        [self.cricleView updateCricleProgress:0];
        if (self.textType == ProgressTextType_carryTiming) {
            self.timeLabel.text = @"00:00";
        }else{
            self.timeLabel.text = [NSString stringWithFormat:@"%02ds",self.maxSeconds];
        }
    }
    
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
    
    [self.layer addAnimation:group forKey:@"ScaleHidden"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    CAAnimation * showAnimation = [self.layer animationForKey:@"ScaleShow"];
    CAAnimation * hiddenAnimation = [self.layer animationForKey:@"ScaleHidden"];
    
    if ([showAnimation isEqual:anim]) {
        self.isShowing = YES;
        !_isAutoRun? :[self run];
    }else if ([hiddenAnimation isEqual:anim]){
        self.isShowing = NO;
    }
}
@end
