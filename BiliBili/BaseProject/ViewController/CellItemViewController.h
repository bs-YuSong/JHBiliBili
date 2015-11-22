//
//  CellItemViewController.h
//  BiliBili
//
//  Created by apple-jd44 on 15/10/23.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVModel.h"
//typedef void(^block)();

@interface CellItemViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgv;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playIcon;
@property (weak, nonatomic) IBOutlet UILabel *playLabel;
@property (weak, nonatomic) IBOutlet UIImageView *replyIcon;
@property (weak, nonatomic) IBOutlet UILabel *danMuLabel;
@property (nonatomic, strong) NSString* section;
//@property (nonatomic, assign) NSInteger ind;
@property (nonatomic, strong) AVDataModel* dataModel;
@property (nonatomic, strong) UINavigationController* navController;
/**
 *  cell子项 存放每一个cell对应的四个视频
 *
 *  @param URL       视频跳转链接
 *  @param playNum   播放数
 *  @param danMuNum  弹幕数
 *  @param title     标题
 *  @param section   分区 用于判断是否为新番分区
 *  @param dataModel 视频模型
 */
//- (void)setViewContentWithImgURL:(NSURL*)URL playNum:(NSString*)playNum danMuNum:(NSString*)danMuNum title:(NSString*)title section:(NSString*)section dataModel:(AVDataModel*)dataModel;
/**
 *  初始化一些属性
 */
- (void)setUpProperty;
//回传下标
//- (void)pushAVInfoViewController:(block) b;
//@property (nonatomic, copy) block returnBlock;
@end
