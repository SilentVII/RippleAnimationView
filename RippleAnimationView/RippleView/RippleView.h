//
//  RippleView.h
//  RippleAnimationView
//
//  Created by fitloft on 2018/9/12.
//  Copyright © 2018年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RippleView : UIView

/**
 扩散波纹的颜色，自动渐变淡化  默认为黄色
 */
@property (nonatomic, strong) UIColor * rippleColor;

/**
 扩散的倍数(放大的倍数)  默认为3
 */
@property (nonatomic, assign) CGFloat scaleTimes;


/**
 单次扩散的动画时长  默认2.5s
 */
@property (nonatomic, assign) CFTimeInterval singleRippleDuration;

- (instancetype )initWithFrame:(CGRect)frame;

- (void)startAnimation;

- (void)stopAnimation;

/**
 出现动画
 */
- (void)startRipplrWithShowAnimation;

/**
 消失动画
 */
- (void)stopRippleWithHiddenAnimation;
@end
