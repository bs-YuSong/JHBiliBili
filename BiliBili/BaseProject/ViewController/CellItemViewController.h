//
//  CellItemViewController.h
//  BiliBili
//
//  Created by apple-jd44 on 15/10/23.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AVModel.h"
typedef void(^block)();

@interface CellItemViewController : UIViewController
- (void)setViewContentWithImgURL:(NSURL*)URL playNum:(NSString*)playNum replyNum:(NSString*)replyNum title:(NSString*)title section:(NSString*)section ind:(NSInteger)ind;
//回传下标
- (void)pushAVInfoViewController:(block) b;
@property (nonatomic, copy) block returnBlock;
@end
