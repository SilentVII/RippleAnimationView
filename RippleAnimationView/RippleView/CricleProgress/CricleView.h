//
//  CricleView.h
//  CricleProgressView
//
//  Created by fitloft on 2019/1/11.
//  Copyright © 2019年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CricleView : UIView

@property (nonatomic, strong) UIColor * progressColor;

@property (nonatomic, assign) CGFloat progressWidth;

@property (nonatomic, assign) int maxSeconds;



- (void)updateCricleProgress:(CGFloat )progress;

@end


