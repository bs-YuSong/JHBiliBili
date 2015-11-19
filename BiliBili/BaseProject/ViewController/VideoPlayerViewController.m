//
//  VideoPlayerViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/13.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface VideoPlayerViewController ()
@property (nonatomic, strong) VideoViewModel* vm;
@end

@implementation VideoPlayerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    __block typeof(self) weakObj = self;
    [self.vm refreshDataCompleteHandle:^(NSError *error) {
        NSLog(@"%@", [weakObj.vm videoURL]);
//        weakObj.player = [AVPlayer playerWithURL:[weakObj.vm videoURL]];
//        [weakObj.player play];
    }];

    // Do any additional setup after loading the view.
}

- (instancetype)initWithAid:(NSString*)aid{
    if (self = [super init]) {
        self.vm = [[VideoViewModel alloc] initWithAid: aid];
    }
    return self;
}

@end
