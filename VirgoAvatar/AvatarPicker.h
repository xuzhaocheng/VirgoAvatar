//
//  ImageCropViewController.h
//  VirgoAvatar
//
//  Created by xuzhaocheng on 14-9-3.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AvatarPicker;

@protocol AvatarPickerDelegate <NSObject>
- (void)dismissViewController;
- (void)avatarPicker:(AvatarPicker *)avatarPicker didGetAvatar: (UIImage *)image;
@end

@interface AvatarPicker : UIViewController

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) id <AvatarPickerDelegate> delegate;

@end
