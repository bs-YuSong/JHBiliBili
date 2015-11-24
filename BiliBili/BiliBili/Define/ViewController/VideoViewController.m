//
//  VideoViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/13.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoViewModel.h"
#import "DanMuModel.h"
#import "BarrageDescriptor+Tools.h"
#import <AVFoundation/AVFoundation.h>
@interface VideoViewController ()
@property (nonatomic, strong) VideoViewModel* vm;
@property (nonatomic, strong) BarrageRenderer* rander;
@property (nonatomic, strong) NSTimer* timer;
@property(nonatomic,strong) AVPlayer *player;
@property(nonatomic,strong) AVPlayerLayer *layer;
@property (nonatomic, strong) UISlider* slide;
@property (nonatomic, strong) UIActivityIndicatorView* iv;
@property (nonatomic, strong) MBProgressHUD* hub;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) NSInteger touchDelayTime;
@property (nonatomic, assign, getter=isPause) BOOL pause;
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    UISlider* slider = [[UISlider alloc] init];
    
    self.slide = slider;
    [self.view addSubview:self.iv];
    [self.hub show:YES];
    
    [slider bk_addEventHandler:^(UISlider* sender) {
        CMTime time = [self.player currentTime];
        time.value = time.timescale * self.slide.value * [self.vm videoLength];
        [self.player seekToTime:time];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.vm refreshDataCompleteHandle:^(NSError *error) {
        self.player = [AVPlayer playerWithURL:[self.vm videoURL]];
        self.layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        [self.view.layer addSublayer: self.layer];
        [self.view addSubview:slider];
        [self.slide setHidden:YES];
        [slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.view.mas_width);
            make.height.mas_equalTo(30);
            make.bottom.mas_equalTo(self.view.mas_bottom);
            make.left.mas_equalTo(self.view.mas_left);
        }];
        [self.player play];
        
        [self.rander start];
        [self launchDanMu];
    }];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.layer.frame = self.view.bounds;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
}

- (instancetype)initWithAid:(NSString*)aid{
    if (self = [super init]) {
        self.vm = [[VideoViewModel alloc] initWithAid: aid];
    }
    return self;
}

- (void)launchDanMu{
    self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:1 block:^(NSTimer *timer) {
        //判断导航栏和进度条是否隐藏
        if (self.touchDelayTime > 0) {
            self.touchDelayTime--;
        }else if(self.touchDelayTime == 0 && !self.navigationController.isNavigationBarHidden){
            [UIView animateWithDuration:0.5 animations:^{
                self.slide.alpha = 0;
            } completion:^(BOOL finished) {
                [self.slide setHidden:YES];
                self.slide.alpha = 1;
            }];
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
        NSInteger ftime = CMTimeGetSeconds([self.player currentTime]);
        //判断弹幕是否应该播放
        if (ftime > self.num) {
            NSArray* model = [self.vm videoDanMu][@(self.num)];
            [model enumerateObjectsUsingBlock:^(DanMuModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.rander receive: [BarrageDescriptor descriptorWithText:obj.text fontSize:obj.fontSize color:obj.textColor style:obj.style]];
            }];
            self.num = ftime;
            self.slide.value = self.num / [self.vm videoLength];
            //缓冲到达指定时间自动播放
        }else{
            CMTimeRange r = self.player.currentItem.loadedTimeRanges.firstObject.CMTimeRangeValue;
            NSLog(@"%f",CMTimeGetSeconds(r.duration));
            
            //判断菊花是否应该出现
            if (self.isPause == YES) {
                self.hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                self.hub.mode = MBProgressHUDModeIndeterminate;
                [self.hub show: YES];
                self.pause = NO;
            }
            
            if (CMTimeGetSeconds(r.duration) > 2) {
                [self playerPlay];
            }
        }
    } repeats:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.navigationController setNavigationBarHidden:![self.navigationController isNavigationBarHidden] animated:YES];
    [self.slide setHidden:[self.navigationController isNavigationBarHidden]];
    self.touchDelayTime = 3;
    [self.player play];
}

#pragma mark - 懒加载

- (UIActivityIndicatorView *)iv{
    if (_iv == nil) {
        _iv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _iv.center = self.view.center;
    }
    return _iv;
}

- (BarrageRenderer *)rander{
    if (_rander == nil) {
        _rander = [[BarrageRenderer alloc] init];
        [_rander setSpeed:1];
        [self.view addSubview: _rander.view];
    }
    return _rander;
}

- (MBProgressHUD *)hub{
    if (_hub == nil) {
        _hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hub.mode = MBProgressHUDModeIndeterminate;
    }
    return _hub;
}

- (AVPlayerLayer *)layer{
    if (_layer == nil) {
        _layer = [[AVPlayerLayer alloc] init];
        _layer.frame = self.view.frame;
    }
    return _layer;
}

- (void)playerPlay{
    [self.player play];
    self.pause = YES;
    [self.hub hide: YES];
}

@end
