//
//  CellItemViewController.h
//  BiliBili
//
//  Created by apple-jd44 on 15/10/23.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVModel.h"
typedef void(^block)();

@interface CellItemViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgv;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playIcon;
@property (weak, nonatomic) IBOutlet UILabel *playLabel;
@property (weak, nonatomic) IBOutlet UIImageView *replyIcon;
@property (weak, nonatomic) IBOutlet UILabel *danMuLabel;
@property (nonatomic, strong) NSString* section;
@property (nonatomic, assign) NSInteger ind;

- (void)setViewContentWithImgURL:(NSURL*)URL playNum:(NSString*)playNum replyNum:(NSString*)replyNum title:(NSString*)title section:(NSString*)section ind:(NSInteger)ind;
/**
 *  初始化一些属性
 *
 */
- (void)setUpProperty;
//回传下标
- (void)pushAVInfoViewController:(block) b;
@property (nonatomic, copy) block returnBlock;
@end
