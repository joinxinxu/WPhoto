//
//  WPFunctionView.m
//  photoDemo
//
//  Created by wangxinxu on 2017/6/5.
//  Copyright © 2017年 wangxinxu. All rights reserved.
//

#import "WPFunctionView.h"

@implementation WPFunctionView

#pragma mark 所选择的图片数组
+(void)finishChoosePhotos:(finishChooseBlock)block chooseArray:(NSMutableArray *)_chooseArray
{
    //字典数组，字典中有image（图片）width（宽度）height（高度）
    NSMutableArray *myChoosePhotoArr = [[NSMutableArray alloc]init];
    WPFunctionView *WPFunc = [[WPFunctionView alloc] init];
    
    if ([phoneVersion integerValue]>=8) {
        
        for (NSInteger i = 0; i<_chooseArray.count; i++) {
            
            UIImage *image = _chooseArray[i];
            image = image.fixOrientation;
            
            [myChoosePhotoArr addObject:[WPFunc createDicImage:image]];
            if (myChoosePhotoArr.count == _chooseArray.count) {
                //传往上一页
                NSLog(@"-------%@", myChoosePhotoArr);
                block(myChoosePhotoArr);
            }
        }
    }
    else {
        
        for (NSInteger i = 0; i<_chooseArray.count; i++) {
            
            NSURL *url = _chooseArray[i];
            ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
            //产生原图
            [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
                
                CGImageRef ref = [[asset  defaultRepresentation]fullScreenImage];
                
                UIImage *image = [[UIImage alloc]initWithCGImage:ref];
                image = image.fixOrientation;
                
                [myChoosePhotoArr addObject:[WPFunc createDicImage:image]];
                if (myChoosePhotoArr.count == _chooseArray.count) {
                   block(myChoosePhotoArr);
                }
                
            }failureBlock:^(NSError *error) {
                NSLog(@"error=%@",error);
            }];
        }
    }
}

-(NSDictionary *)createDicImage:(UIImage *)image
{
    NSString*imgSize = NSStringFromCGSize(image.size);
    NSArray *allArr = [imgSize componentsSeparatedByString:@","];
    NSArray *firstArr = [allArr[0] componentsSeparatedByString:@"{"];
    NSArray *secondArr = [allArr[1] componentsSeparatedByString:@"}"];
    //宽
    CGFloat width = [firstArr[1] floatValue];
    //高
    CGFloat height = [secondArr[0] floatValue];
    if (width>720.0) {
        height = height*720.0/width;
        width = 720.0;
    }
    NSString *widthStr = [NSString stringWithFormat:@"%.2f",width];
    NSString *heightStr = [NSString stringWithFormat:@"%.2f",height];
    
    NSDictionary *dic = @{@"image":image,@"width":widthStr,@"height":heightStr};
    
    return dic;
}

#pragma mark 高版本使用PhotoKit框架获取图片
+(void)getHeightVersionAllPhotos:(PhotoKitBlock)photosBlock {
    
    WPFunctionView *WPFunc = [[WPFunctionView alloc] init];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusDenied) {
            NSLog(@"用户拒绝当前应用访问相册,我们需要提醒用户打开访问开关");
            [WPFunc showAlertView];
        }else if (status == PHAuthorizationStatusRestricted){
            NSLog(@"家长控制,不允许访问");
        }else if (status == PHAuthorizationStatusNotDetermined){
            NSLog(@"用户还没有做出选择");
            //            [[PHPhotoLibrary sharedPhotoLibrary]registerChangeObserver:self];
        }else if (status == PHAuthorizationStatusAuthorized){
            NSLog(@"用户允许当前应用访问相册");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 列出所有相册智能相册
                PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
                
                if (smartAlbums.count != 0) {
                    
                    //获取资源时的参数
                    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
                    //按时间排序
                    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
                    //所有照片
                    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
                    
                    photosBlock(allPhotos);
                }
            });
        }
    }];
}

#pragma mark 低版本使用ALAssetsLibrary框架获取图片
+(void)getLowVersionAllPhotos:(ALAssetsLibraryBlock)photoGroupBlock {
    WPFunctionView *WPFunc = [[WPFunctionView alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        //申请许可
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
            
            NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
            if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
                NSLog(@"无法访问相册.请将'设置->定位服务'设置为打开状态.");
                [WPFunc showAlertView];
            }else{
                
                NSLog(@"相册访问失败.");
            }
        };
        
        //获取相册分组
        ALAssetsLibraryGroupsEnumerationResultsBlock libraryGroupsEnumeration = ^(ALAssetsGroup* group,BOOL* stop){
            photoGroupBlock(group);
        };
        
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:libraryGroupsEnumeration
                             failureBlock:failureblock];
    });
    
}

-(void)showAlertView
{
    UIAlertView *alertVC = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"请将'设置->隐私->照片->'设置为允许." delegate:self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
    [alertVC show];
}

#pragma mark 高版本使用PhotoKit框架选择图片
+(void)getChoosePicPHImageManager:(HandlerBlock)handler manager:(ManagerBlock)manager asset:(PHAsset *)asset viewSize:(CGSize)viewSize

{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = true;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.networkAccessAllowed = YES;
    options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        /*
         Progress callbacks may not be on the main thread. Since we're updating
         the UI, dispatch to the main queue.
         */
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(progress);
        });
    };
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:viewSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        // Hide the progress view now the request has completed.
        
        // Check if the request was successful.
       
        manager(result);
        
    }];
}

#pragma mark 列表中按钮点击动画效果
+(void)shakeToShow:(UIImageView *)button{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [button.layer addAnimation:animation forKey:nil];
}

@end
