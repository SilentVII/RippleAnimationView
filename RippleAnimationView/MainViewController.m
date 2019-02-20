//
//  MainViewController.m
//  RippleAnimationView
//
//  Created by fitloft on 2018/9/11.
//  Copyright © 2018年 Nick. All rights reserved.
//

#import "MainViewController.h"
#import "RippleView.h"
#import "CricleProgressView.h"

#define UIColorFromHexWithAlpha(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a]
#define UIColorFromHex(hexValue)            UIColorFromHexWithAlpha(hexValue,1.0)

@interface MainViewController ()
@property (nonatomic, strong) RippleView * rippleView;
@property (nonatomic, strong) CricleProgressView * progressView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    _rippleView = [[RippleView alloc] initWithFrame:CGRectMake((width - 85)/2, (height - 85)/2, 85, 85)];
    [self.view addSubview:_rippleView];
    
    _progressView = [[CricleProgressView alloc] initWithFrame:CGRectMake((width - 85)/2, (height - 85)/2, 85, 85)];
    _progressView.maxSeconds = 100;
    _progressView.textType = ProgressTextType_uncarryTiming;
    [_progressView setProgressColor:[UIColor redColor]];
    _progressView.backgroundColor = [UIColor whiteColor];
    _progressView.centerIconName = @"alarm";
    _progressView.centerColor = UIColorFromHex(0x67b5fd);
    [_progressView setProgressColor:UIColorFromHex(0x2877FC)];
    [self.view addSubview:_progressView];
    
    _progressView.statusChangedBlock = ^(ProgressStatus status) {
        NSLog(@"%lu",(unsigned long)status);
    };
    
    [_rippleView startRipplrWithShowAnimation];
    [_progressView showWithScaleAnimationAndRun:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
