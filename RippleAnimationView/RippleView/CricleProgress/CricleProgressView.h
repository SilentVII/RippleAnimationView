//
//  CricleProgressView.h
//  CricleProgressView
//
//  Created by fitloft on 2019/1/11.
//  Copyright © 2019年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ProgressStatus_unKnown,
    ProgressStatus_Timing,
    ProgressStatus_Paused,
    ProgressStatus_Completed,
    ProgressStatus_Canceld,
} ProgressStatus;

typedef enum : NSUInteger {
    ProgressTextType_uncarryTiming,   //不进位计时   1s，2s，·······
    ProgressTextType_carryTiming,    //进位计时   00:01 00:02 ······
} ProgressTextType;

typedef void(^CricleProgressStatusChanged)(ProgressStatus status);

@interface CricleProgressView : UIView
@property (nonatomic, assign) ProgressStatus status;
@property (nonatomic, assign) ProgressTextType textType;
@property (nonatomic, strong) NSString * centerIconName;
@property (nonatomic, strong) UIColor * centerColor;

@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, copy) CricleProgressStatusChanged statusChangedBlock;
@property (nonatomic, assign) int maxSeconds;


/**
 开启懂定时器
 */
- (void)run;

/**
 暂停计时器
 */
- (void)pause;

/**
 恢复定时器
 定时器在暂停状态下执行
 */
- (void)resume;

/**
 取消定时器，释放定时器
 */
- (void)cancel;

/**
 设置进度指示器颜色

 @param progressColor 颜色
 */
- (void)setProgressColor:(UIColor *)progressColor;

/**
 缩放动画，定时器出现

 @param isAutoRun 定时器出现后是否自动开启
 */
- (void)showWithScaleAnimationAndRun:(BOOL )isAutoRun;

/**
 缩放动画
 定时器消失，并自动释放定时器，重置定时器文字显示
 */
- (void)hiddenWithScaleAnimation;


@end


