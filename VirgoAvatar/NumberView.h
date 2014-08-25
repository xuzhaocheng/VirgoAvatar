//
//  NumberView.h
//  VirgoAvatar
//
//  Created by xuzhaocheng on 14-8-25.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumberView : UIView

@property (nonatomic, strong) NSString *number;

- (id)initWithMinFrame:(CGRect)minFrame maxFrame:(CGRect)maxFrame;
@end
