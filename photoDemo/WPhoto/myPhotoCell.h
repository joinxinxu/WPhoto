//
//  myPhotoCell.h
//  photoDemo
//
//  Created by wangxinxu on 2017/6/1.
//  Copyright © 2017年 wangxinxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPMacros.h"

@interface myPhotoCell : UICollectionViewCell

@property(nonatomic, strong)UIImageView *photoView;

@property(nonatomic, assign)BOOL chooseStatus;

@property (nonatomic, copy) NSString *representedAssetIdentifier;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, assign) CGFloat progressFloat;

@property (nonatomic, strong) UIImageView *signImage;

@end
