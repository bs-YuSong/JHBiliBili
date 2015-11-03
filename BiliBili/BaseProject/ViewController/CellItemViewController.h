//
//  CellItemViewController.h
//  BiliBili
//
//  Created by apple-jd44 on 15/10/23.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendModel.h"
@interface CellItemViewController : UIViewController
- (void)setViewContentWithModel:(RecommendDataModel*)model;
@end
