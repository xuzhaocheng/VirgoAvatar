//
//  NumberView.m
//  VirgoAvatar
//
//  Created by xuzhaocheng on 14-8-25.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "NumberView.h"

@interface NumberView ()
@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic) CGRect minFrame;
@property (nonatomic) CGRect maxFrame;

@end

@implementation NumberView

#define STANDARD_PADDING    10
- (CGFloat)padding { return [self sizeScale] * STANDARD_PADDING; }

- (void)setNumber:(NSString *)number
{
    _number = number;
    self.numberLabel.text = number;
    [self.numberLabel sizeToFit];

    CGRect numberFrame = self.numberLabel.frame;
    numberFrame.size.height = self.minFrame.size.height;
    if (numberFrame.size.width < self.minFrame.size.width) {
        
        if (numberFrame.size.width > self.minFrame.size.width - [self padding]) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.numberLabel.frame.size.width + [self padding], self.minFrame.size.height);
        } else {
            numberFrame.size.width = self.minFrame.size.width;
            self.numberLabel.frame = numberFrame;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.numberLabel.frame.size.width, self.minFrame.size.height);
        }
    } else {
        if (numberFrame.size.width > self.maxFrame.size.width - [self padding]) {
            numberFrame.size.width = self.maxFrame.size.width - [self padding];
            self.numberLabel.frame = numberFrame;
        }
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.numberLabel.frame.size.width + [self padding], self.minFrame.size.height);
    }
    self.numberLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [self setNeedsDisplay];
}

#define STANDARD_FONT_SIZE  18.f
#define STANDARD_HEIGHT     28.f

- (CGFloat)sizeScale { return self.minFrame.size.height / STANDARD_HEIGHT; }
- (CGFloat)fontSize { return [self sizeScale] * STANDARD_FONT_SIZE; };

- (id)initWithMinFrame:(CGRect)minFrame maxFrame:(CGRect)maxFrame cornerRadius:(CGFloat)cornerRadius
{
    self = [super init];
    if (self) {
        // Initialization code
        self.minFrame = minFrame;
        self.maxFrame = maxFrame;
        self.opaque = NO;
        self.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = cornerRadius;
        self.layer.masksToBounds = YES;
        self.numberLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.numberLabel.font = [UIFont systemFontOfSize:[self fontSize]];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        self.numberLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.numberLabel];
    }
    return self;
}


@end
