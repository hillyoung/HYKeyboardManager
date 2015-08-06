//
//  HYKeyboardManger.h
//  UserFulResourceCollect
//
//  Created by yanghaha on 15/8/5.
//  Copyright (c) 2015年 yanghaha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HYKeyboardManager : NSObject

/**
 *@brief 页面window偏移量 例如：可以带appear,disappear的生命周期函数中进行设置
 **/

@property (nonatomic, assign) CGFloat offset;

+ (HYKeyboardManager *)defaultManager;

- (void)registerNotifications;

@end
