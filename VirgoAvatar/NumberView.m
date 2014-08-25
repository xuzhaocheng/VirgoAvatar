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

- (void)setNumber:(NSString *)number
{
    _number = number;
    self.numberLabel.text = number;
    [self.numberLabel sizeToFit];

    CGRect numberFrame = self.numberLabel.frame;
    numberFrame.size.height = self.minFrame.size.height;
    if (numberFrame.size.width < self.minFrame.size.width) {
        
        if (numberFrame.size.width > self.minFrame.size.width - 10) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.numberLabel.frame.size.width + 10, self.minFrame.size.height);
        } else {
            numberFrame.size.width = self.minFrame.size.width;
            self.numberLabel.frame = numberFrame;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.numberLabel.frame.size.width, self.minFrame.size.height);
        }
    } else {
        if (numberFrame.size.width > self.maxFrame.size.width - 10) {
            numberFrame.size.width = self.maxFrame.size.width - 10;
            self.numberLabel.frame = numberFrame;
        }
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.numberLabel.frame.size.width + 10, self.minFrame.size.height);
    }
    self.numberLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [self setNeedsDisplay];
}

- (id)initWithMinFrame:(CGRect)minFrame maxFrame:(CGRect)maxFrame
{
    self = [super initWithFrame:minFrame];
    if (self) {
        // Initialization code
        self.minFrame = minFrame;
        self.maxFrame = maxFrame;
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.numberLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.numberLabel.font = [UIFont systemFontOfSize:20.f];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        self.numberLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.numberLabel];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10.f];
    [roundRect addClip];
    [[UIColor redColor] setFill];
    [roundRect fill];
}


@end
