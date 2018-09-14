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
 中间圆的颜色 默认为白色
 */
@property (nonatomic, strong) UIColor * centerColor;

/**
 扩散的倍数(放大的倍数)  默认为3
 */
@property (nonatomic, assign) CGFloat scaleTimes;


/**
 单次扩散的动画时常  默认2.5s
 */
@property (nonatomic, assign) CFTimeInterval singleRippleDuration;


- (instancetype)init NS_UNAVAILABLE;

- (instancetype )initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;

-(void)creatRippleAnimate;
@end
