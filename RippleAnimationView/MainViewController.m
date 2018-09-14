//
//  MainViewController.m
//  RippleAnimationView
//
//  Created by fitloft on 2018/9/11.
//  Copyright © 2018年 Nick. All rights reserved.
//

#import "MainViewController.h"
#import "RippleView.h"
#import "NCProgressView.h"

@interface MainViewController ()
{
    dispatch_source_t timer;
}

@property (nonatomic, strong) NCProgressView * progressView1;
@property (nonatomic, strong) NCProgressView * progressView2;



@property (nonatomic, assign) CGFloat progress;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];

    UISlider * slider = [[UISlider alloc] initWithFrame:CGRectMake(50, (self.view.frame.size.height - 30)/2, self.view.bounds.size.width - 2*50, 30)];
    [slider addTarget:self action:@selector(sliderMethod:) forControlEvents:UIControlEventValueChanged];
    [slider setMaximumValue:1];
    [slider setMinimumValue:0];
    [slider setMinimumTrackTintColor:[UIColor colorWithRed:255.0f/255.0f green:151.0f/255.0f blue:0/255.0f alpha:1]];
    [self.view addSubview:slider];
    
    
    self.progressView1 = [[NCProgressView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 100)/2, 50, 100, 100) withProgressType:ProgressType_Percent];
//    self.progressView1.centerIcon = [UIImage imageNamed:@"playGame_IP"];
    self.progressView1.centerColor = [UIColor lightGrayColor];
    self.progressView1.progressColor = [UIColor blueColor];
    self.progressView1.progressBackColor = [UIColor whiteColor];
    self.progressView1.progressWidth = 4;
    [self.view addSubview:self.progressView1];
    
    
    self.progressView2 = [[NCProgressView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 100)/2, 200, 100, 100) withProgressType:ProgressType_Timing];
    self.progressView2.maxTimeInterval = 100;
    //    self.progressView2.centerIcon = [UIImage imageNamed:@"playGame_IP"];
    self.progressView2.centerColor = [UIColor lightGrayColor];
    self.progressView2.progressColor = [UIColor blueColor];
    self.progressView2.progressBackColor = [UIColor whiteColor];
    self.progressView2.progressWidth = 4;
    [self.view addSubview:self.progressView2];
    
    
    RippleView * rippleView = [[RippleView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 50)/2, slider.frame.origin.y + 80, 50, 50)];
    [rippleView creatRippleAnimate];
    [self.view addSubview:rippleView];
    

    
}

-(void)sliderMethod:(UISlider*)slider
{
    [self.progressView1 updateProgress:slider.value];
    [self.progressView2 updateProgress:slider.value];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
