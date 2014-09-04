//
//  ImageCropViewController.h
//  VirgoAvatar
//
//  Created by xuzhaocheng on 14-9-3.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageCropViewController;

@protocol ImageCropDelegate <NSObject>
- (void)dismissViewController;
- (void)imageCropViewController:(ImageCropViewController *)viewController didGetCroppedImage: (UIImage *)image;
@end

@interface ImageCropViewController : UIViewController

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) id <ImageCropDelegate> delegate;

@end
