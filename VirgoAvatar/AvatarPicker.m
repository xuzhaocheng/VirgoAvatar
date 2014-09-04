//
//  ImageCropViewController.m
//  VirgoAvatar
//
//  Created by xuzhaocheng on 14-9-3.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "AvatarPicker.h"

#define kMaskLayerSideLength        ([UIScreen mainScreen].bounds.size.width)

@interface AvatarPicker () <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation AvatarPicker
{
    BOOL _shouldStatusBarHidden;
}
- (BOOL)prefersStatusBarHidden
{
    return _shouldStatusBarHidden;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _shouldStatusBarHidden = NO;
    [self.toolbar setBackgroundImage:[UIImage new]
                  forToolbarPosition:UIBarPositionAny
                          barMetrics:UIBarMetricsDefault];
    
    
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.alwaysBounceVertical = YES;
}

- (void)viewDidLayoutSubviews
{
    self.imageView.frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    self.imageView.image = self.image;
    [self.scrollView addSubview:self.imageView];
    [self.view addSubview:self.scrollView];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self setMinMaxZoomScale];
    [self centeredFrame:self.imageView forScrollView:self.scrollView];
    [self updateContentSize];
    [self updateContentInsets];
    [self createLayer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _shouldStatusBarHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _shouldStatusBarHidden = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - Private

- (CGFloat)verticalPaddingOfMaskLayer
{
    return (self.view.frame.size.height - self.toolbar.frame.size.height - kMaskLayerSideLength) / 2;
}

- (CGFloat)horizontalPaddingOfMaskLayer
{
    return (self.view.frame.size.width - kMaskLayerSideLength) / 2;
}

- (void)createLayer
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.view.bounds];
    UIBezierPath *avatarFrame = [UIBezierPath bezierPathWithRect:CGRectMake([self horizontalPaddingOfMaskLayer], [self verticalPaddingOfMaskLayer], kMaskLayerSideLength, kMaskLayerSideLength)];
    [path appendPath:avatarFrame];
    
    UIBezierPath *toolbarFrame = [UIBezierPath bezierPathWithRect:self.toolbar.frame];
    [path appendPath:toolbarFrame];
    
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.5;
    [self.view.layer addSublayer:fillLayer];
    
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    
    [linePath moveToPoint:CGPointMake([self horizontalPaddingOfMaskLayer], [self verticalPaddingOfMaskLayer])];
    [linePath addLineToPoint:CGPointMake([self horizontalPaddingOfMaskLayer] + kMaskLayerSideLength, [self verticalPaddingOfMaskLayer])];
    [linePath addLineToPoint:CGPointMake([self horizontalPaddingOfMaskLayer] + kMaskLayerSideLength, [self verticalPaddingOfMaskLayer] + kMaskLayerSideLength)];
    [linePath addLineToPoint:CGPointMake([self horizontalPaddingOfMaskLayer], [self verticalPaddingOfMaskLayer] + kMaskLayerSideLength)];
    [linePath addLineToPoint:CGPointMake([self horizontalPaddingOfMaskLayer], [self verticalPaddingOfMaskLayer])];

    CAShapeLayer *lineRect = [CAShapeLayer layer];
    lineRect.path = linePath.CGPath;
    lineRect.strokeColor = [UIColor whiteColor].CGColor;
    lineRect.fillColor = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:lineRect];
}

- (void)setMinMaxZoomScale
{
    self.scrollView.maximumZoomScale = 1;
	self.scrollView.minimumZoomScale = 1;
	self.scrollView.zoomScale = 1;
    
    // Sizes
    CGSize boundsSize = self.scrollView.bounds.size;
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

- (void)centeredFrame:(UIView *)view forScrollView:(UIScrollView *)scrollView
{
    CGSize boundsSize = scrollView.frame.size;
    CGRect frameToCenter = view.frame;
    
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    if (!CGRectEqualToRect(view.frame, frameToCenter))
        view.frame = frameToCenter;
}

- (void)updateContentSize
{
    CGFloat contentHeight, contentWidth;
    if (self.imageView.frame.size.height > self.scrollView.frame.size.height) {
        contentHeight = self.imageView.frame.size.height;
    } else {
        contentHeight = self.scrollView.bounds.size.height;
    }
    if (self.imageView.frame.size.width > self.scrollView.frame.size.width) {
        contentWidth = self.imageView.frame.size.width;
    } else {
        contentWidth = self.scrollView.bounds.size.width;
    }
    self.scrollView.contentSize = CGSizeMake(contentWidth, contentHeight);
}

- (void)updateContentInsets
{
    CGFloat insetTop, insetLeft, insetBottom, insetRight;
   
    if (self.imageView.frame.size.height - kMaskLayerSideLength >= [self verticalPaddingOfMaskLayer] * 2 ) {
        insetTop = insetBottom = [self verticalPaddingOfMaskLayer];
    } else if (self.imageView.frame.size.height <= kMaskLayerSideLength) {
        insetTop = insetBottom = 0;
    } else {
        insetTop = insetBottom = (self.imageView.frame.size.height - kMaskLayerSideLength) / 2;
    }
    
    if (self.imageView.frame.size.width - kMaskLayerSideLength >= [self horizontalPaddingOfMaskLayer]) {
        insetLeft = insetRight = [self horizontalPaddingOfMaskLayer];
    } else if (self.imageView.frame.size.width <= kMaskLayerSideLength) {
        insetLeft = insetRight = 0;
    } else {
        insetLeft = insetRight = (self.imageView.frame.size.width - kMaskLayerSideLength) / 2;
    }
    
    self.scrollView.contentInset = UIEdgeInsetsMake(insetTop, insetLeft, insetBottom, insetRight);
}


#pragma mark - UIScrollView delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centeredFrame:self.imageView forScrollView:self.scrollView];
    [self updateContentSize];
    [self updateContentInsets];
}


- (IBAction)cropAction:(id)sender
{
    CGRect cropRect = CGRectMake([self horizontalPaddingOfMaskLayer], [self verticalPaddingOfMaskLayer], kMaskLayerSideLength, kMaskLayerSideLength);
    CGRect cropRectInImageView = [self.view convertRect:cropRect toView:self.imageView];
    cropRectInImageView.origin.x /= self.imageView.image.scale;
    cropRectInImageView.origin.y /= self.imageView.image.scale;
    cropRectInImageView.size.height /= self.imageView.image.scale;
    cropRectInImageView.size.width /= self.imageView.image.scale;
    
    CGImageRef croppedImageRef = CGImageCreateWithImageInRect(self.image.CGImage, cropRectInImageView);
	UIImage* cropped = [UIImage imageWithCGImage:croppedImageRef scale:self.imageView.image.scale orientation:UIImageOrientationUp];
	CGImageRelease(croppedImageRef);

    if ([_delegate respondsToSelector:@selector(avatarPicker:didGetAvatar:)]) {
        [_delegate avatarPicker:self didGetAvatar:cropped];
    }
}

- (IBAction)cancelAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(dismissViewController)]) {
        [_delegate dismissViewController];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
