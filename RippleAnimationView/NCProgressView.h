//
//  NCProgressView.h
//  RippleAnimationView
//
//  Created by fitloft on 2018/9/13.
//  Copyright © 2018年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ProgressType_Percent,   //百分比
    ProgressType_Timing,    //计时
} ProgressType;

@interface NCProgressView : UIView
/**
 中间的icon
 */
@property (nonatomic, strong) UIImage * centerIcon;

/**
 进度条宽度
 */
@property (nonatomic, assign) CGFloat progressWidth;

/**
 进度条背景颜色
 */
@property (nonatomic, strong) UIColor * progressBackColor;

/**
 进度条颜色 默认为红色
 */
@property (nonatomic, strong) UIColor * progressColor;

/**
 中间圆环的颜色
 */
@property (nonatomic, strong) UIColor * centerColor;


/**
 进度数值字体，默认为[UIFont systemFontOfSize:13];
 */
@property (nonatomic, strong) UIFont * timeFont;

/**
 进度字体颜色 默认为黑色
 */
@property (nonatomic, strong) UIColor * timeColor;

/**
 进度指示器类型
 */
@property (nonatomic, assign) ProgressType progressType;

/**
 当ProgressType 为 ProgressType_Percent时， 进度数值为百分比 ，此属性无用
 当ProgressType 为 ProgressType_Timing时，此属性用于确定计时器最大范围，同时设置进度数值为计时模式。
 单位 秒
 */
@property (nonatomic, assign) CGFloat maxTimeInterval;


- (instancetype )initWithFrame:(CGRect)frame withProgressType:(ProgressType)progressType;

- (void)updateProgress:(CGFloat )percent;



@end
