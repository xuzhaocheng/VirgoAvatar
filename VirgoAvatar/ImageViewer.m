//
//  ImageViewer.m
//  VirgoAvatar
//
//  Created by xuzhaocheng on 14-9-3.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "ImageViewer.h"

@interface ImageViewer () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ImageViewer

- (id)initWithFrame:(CGRect)frame image: (UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor blackColor];
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        self.scrollView.backgroundColor = [UIColor blackColor];
        self.scrollView.delegate = self;
        self.scrollView.maximumZoomScale = 1;
        self.scrollView.minimumZoomScale = 1;
        self.scrollView.zoomScale = 1;
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        self.imageView.image = image;
        [self.scrollView addSubview:self.imageView];
        [self addSubview:self.scrollView];
        
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.userInteractionEnabled = YES;
        self.scrollView.contentSize = self.imageView.frame.size;

        [self setMinMaxZoomScale];
        [self centeredFrame:self.imageView forScrollView:self.scrollView];
//        [self createLayer];
    }
    return self;
}


- (void)createLayer
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    UIBezierPath *rect = [UIBezierPath bezierPathWithRect:CGRectMake(0, 150, 320, 320)];
    [path appendPath:rect];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.5;
    [self.layer addSublayer:fillLayer];
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    [self centeredFrame:self.imageView forScrollView:self.scrollView];
//}


- (void)centeredFrame:(UIView *)view forScrollView:(UIScrollView *)scrollView
{
    CGSize boundsSize = scrollView.frame.size;
    CGRect frameToCenter = view.frame;
    
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = ((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = ((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    if (!CGRectEqualToRect(view.frame, frameToCenter))
        view.frame = frameToCenter;
}


- (void)setMinMaxZoomScale
{
    self.scrollView.maximumZoomScale = 1;
	self.scrollView.minimumZoomScale = 1;
	self.scrollView.zoomScale = 1;
    
    // Sizes
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = self.imageView.image.size;
    
    // Calculate Min
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    // Calculate Max
	CGFloat maxScale = 3;
    
    // Image is smaller than screen so no zooming!
	if (xScale >= 1 && yScale >= 1) {
		minScale = 1.0;
	}
    
    self.scrollView.maximumZoomScale = maxScale;
	self.scrollView.minimumZoomScale = minScale;
    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    
}

#pragma mark - UIScrollView delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    NSLog(@"content size: %f, %f", scrollView.contentSize.width, scrollView.contentSize.height);
    
//    CGRect rect = [self convertRect:self.bounds toView:self.imageView];
    [self centeredFrame:self.imageView forScrollView:self.scrollView];
//    NSLog(@"x: %f, y: %f, width: %f, height: %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
}

@end
