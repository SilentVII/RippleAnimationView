//
//  MainViewController.m
//  RippleAnimationView
//
//  Created by fitloft on 2018/9/11.
//  Copyright © 2018年 Nick. All rights reserved.
//

#import "MainViewController.h"
#import "RippleAnimateView.h"
#import "RippleView.h"

@interface MainViewController ()
{
    dispatch_source_t timer;
}
@property (nonatomic, strong) RippleAnimateView * animateView;
@property (nonatomic, strong) RippleView * rippleView;

@property (nonatomic, assign) CGFloat progress;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.animateView = [[RippleAnimateView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 108)/2, (self.view.frame.size.height - 108)/2, 108, 108)];
    self.animateView.progressColor = [UIColor colorWithRed:254/255.0 green:155/255.0 blue:51/255.0 alpha:1];
    self.animateView.progressBackColor = [UIColor whiteColor];
    [self.view addSubview:self.animateView];
    
    self.animateView.centerIcon = [UIImage imageNamed:@"playGame_IP"];
    
    

    UISlider * slider = [[UISlider alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(_animateView.frame) + 150, self.view.bounds.size.width - 2*50, 30)];
    [slider addTarget:self action:@selector(sliderMethod:) forControlEvents:UIControlEventValueChanged];
    [slider setMaximumValue:1];
    [slider setMinimumValue:0];
    [slider setMinimumTrackTintColor:[UIColor colorWithRed:255.0f/255.0f green:151.0f/255.0f blue:0/255.0f alpha:1]];
    [self.view addSubview:slider];
    
}

-(void)sliderMethod:(UISlider*)slider
{
    [self.animateView updateProgress:slider.value];;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
