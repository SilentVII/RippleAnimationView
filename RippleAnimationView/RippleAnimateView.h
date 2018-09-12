//
//  RippleAnimateView.h
//  RippleAnimationView
//
//  Created by fitloft on 2018/9/11.
//  Copyright © 2018年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RippleAnimateView : UIView

@property (nonatomic, strong) UIImage * centerIcon; // 中间的icon
@property (nonatomic, assign) CGFloat multiple;     //扩散倍数
@property (nonatomic, strong) UIColor * rippleColor;   //波纹颜色
@property (nonatomic, assign) CGFloat fixedWidth;      //中间固定圆的宽度 同时确定进度条内圆半径
@property (nonatomic, assign) CGFloat progressWidth;
@property (nonatomic, strong) UIColor * progressBackColor;
@property (nonatomic, strong) UIColor * progressColor;





- (instancetype )initWithFrame:(CGRect)frame;

- (void)updateProgress:(CGFloat )percent;

@end
