//
//  WPMacros.h
//  photoDemo
//
//  Created by wangxinxu on 2017/6/2.
//  Copyright © 2017年 wangxinxu. All rights reserved.
//

#ifndef WPMacros_h
#define WPMacros_h

/**
 *  定义图片返回的类型枚举
 */
typedef NS_ENUM(NSInteger,XFImageType){
    XFImageTypeOfDefault,      //原图
    XFImageTypeOfThumb         //缩略图
};

#define navView_H 64

#define TabBar_H 49

/**
 *  控制器
 *
 *  @param self.view.frame.size.width 宽
 *
 *  @param self.view.frame.size.height 高
 */
#define SelfView_W [[UIScreen mainScreen] bounds].size.width
#define SelfView_H [[UIScreen mainScreen] bounds].size.height
#define phoneScale [UIScreen mainScreen].bounds.size.width/720.0

//手机系统版本
#define phoneVersion [[UIDevice currentDevice] systemVersion]

/*
 颜色
 */
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// 相册列表页面上端的颜色
#define WPhoto_TopView_Color UIColorFromRGB(0x000000)
// 相册列表页面上端文字的颜色
#define WPhoto_TopText_Color UIColorFromRGB(0xffffff)

/*
 图片
 */
//   相册列表页面左边返回箭头图片
#define WPhoto_Btn_Back      [UIImage imageNamed:@"wphoto_back@2x"]
//   图片选中状态图片
#define WPhoto_Btn_Selected       [UIImage imageNamed:@"wphoto_select_yes@2x"]
//   图片未选中状态图片
#define WPhoto_btn_UnSelected     [UIImage imageNamed:@"wphoto_select_no@2x"]

/*
 文字
 */
//   相册列表页面右边的文字
#define WPhoto_Center_Text @"所有照片"
#define WPhoto_Right_Text  @"取消选择"

#endif /* WPMacros_h */
