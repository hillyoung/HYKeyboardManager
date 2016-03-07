//
//  HYKeyboardManger.m
//  UserFulResourceCollect
//
//  Created by yanghaha on 15/8/5.
//  Copyright (c) 2015年 yanghaha. All rights reserved.
//

#import "HYKeyboardManager.h"
#import <UIKit/UIKit.h>

@implementation HYKeyboardManager

#pragma mark - LifeCycle

+ (HYKeyboardManager *)defaultManager {
    static HYKeyboardManager *manager;
    static dispatch_once_t one_t;
    dispatch_once(&one_t, ^{
        manager = [[self alloc] init];
    });

    return manager;
}

-(void)dealloc {
    [self resignNotifications];
}

#pragma mark - SET && GET

- (void)setOffset:(CGFloat)offset {
    _offset = fabs(offset);
}


#pragma mark - Notification
//注册键盘通知
- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//通知中心注销掉观察
- (void)resignNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];

    NSValue *beginValue = userInfo[UIKeyboardFrameBeginUserInfoKey];
    NSValue *value = userInfo[UIKeyboardFrameEndUserInfoKey];

    CGRect beginRect = beginValue.CGRectValue;
    CGRect endRect = value.CGRectValue;

    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGRect rect = window.frame;

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        if (endRect.origin.y > 0)rect.origin.y = self.offset? -self.offset:-endRect.size.height;
    } else {
        switch ([UIApplication sharedApplication].statusBarOrientation) {
            case UIInterfaceOrientationPortrait:
                if (endRect.origin.y > 0)rect.origin.y = self.offset? -self.offset:-endRect.size.height;
                break;

            case UIInterfaceOrientationLandscapeLeft:
                if (endRect.origin.x > 0)rect.origin.x = self.offset? -self.offset:-endRect.size.width;
                break;

            case UIInterfaceOrientationPortraitUpsideDown:
                if (endRect.origin.y == 0)rect.origin.y = self.offset? self.offset:endRect.size.height;
                break;

            case UIInterfaceOrientationLandscapeRight:
                if (endRect.origin.x == 0)rect.origin.x = self.offset? self.offset:endRect.size.width;
                break;

            default:
                break;
        }
    }

    BOOL noAnimation = beginRect.size.width != endRect.size.width || beginRect.size.height != endRect.size.height;
    [UIView animateWithDuration:noAnimation? 0:0.5 animations:^{
        window.frame = rect;
    }];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {

}

- (void)keyboardWillHide:(NSNotification *)notification {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];

    CGRect rect = window.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    
    window.frame = rect;
}


@end
