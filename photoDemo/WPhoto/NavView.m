//
//  NavView.m
//  photoDemo
//
//  Created by wangxinxu on 2017/6/6.
//  Copyright © 2017年 wangxinxu. All rights reserved.
//

#import "NavView.h"

@implementation NavView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createNavViewTitle:WPhoto_Center_Text];
        
    }
    return self;
}
#pragma mark 创建nav
-(void)createNavViewTitle:(NSString *)title {
    UIView *nav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SelfView_W, navView_H)];
    nav.backgroundColor = WPhoto_TopView_Color;
    [self addSubview:nav];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 80, navView_H-20)];
    titleLab.text = title;
    titleLab.font = [UIFont systemFontOfSize:36/2];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = WPhoto_TopText_Color;
    [nav addSubview:titleLab];
    
    titleLab.center = CGPointMake(nav.center.x, (navView_H-20)/2+20);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame= CGRectMake(10, 0, 25, 25);
    [btn addTarget:self action:@selector(btnClickBack) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[WPhoto_Btn_Back imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [nav addSubview:btn];
    btn.center = CGPointMake(25, titleLab.center.y);
    
    UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame= CGRectMake(SelfView_W-90, 0, 80, 25);
    rightItem.center = CGPointMake(SelfView_W-50, titleLab.center.y);
    [rightItem addTarget:self action:@selector(quitChoose)forControlEvents:UIControlEventTouchUpInside];
    rightItem.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightItem setTitle:WPhoto_Right_Text forState:UIControlStateNormal];
    [nav addSubview:rightItem];
}

-(void)btnClickBack
{
    _navViewBack();
}

-(void)quitChoose
{
    _quitChooseBack();
}


@end
