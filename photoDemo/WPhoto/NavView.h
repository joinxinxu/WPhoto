//
//  NavView.h
//  photoDemo
//
//  Created by wangxinxu on 2017/6/6.
//  Copyright © 2017年 wangxinxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPMacros.h"


@interface NavView : UIView

@property (nonatomic, copy) void(^navViewBack)();
@property (nonatomic, copy) void(^quitChooseBack)();

// 创建nav
-(void)createNavViewTitle:(NSString *)title;

@end
