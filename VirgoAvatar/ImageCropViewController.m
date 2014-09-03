//
//  ImageCropViewController.m
//  VirgoAvatar
//
//  Created by xuzhaocheng on 14-9-3.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "ImageCropViewController.h"
#import "ImageViewer.h"

#define kMaskLayerSideLength    (self.view.frame.size.width)

@interface ImageCropViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation ImageCropViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.alwaysBounceVertical = YES;
    
    self.imageView.frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    self.imageView.image = self.image;
    [self.scrollView addSubview:self.imageView];
    [self.view addSubview:self.scrollView];
    
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    self.scrollView.contentSize = self.image.size;
    self.scrollView.contentSize = self.scrollView.bounds.size;

    
    [self setMinMaxZoomScale];
    [self centeredFrame:self.imageView forScrollView:self.scrollView];
    [self updateContentInsets];
    
    [self createLayer];
    
}



- (CGFloat)topPaddingOfMaskLayer
{
    return (self.view.frame.size.height - self.toolbar.frame.size.height - kMaskLayerSideLength) / 2;
}

- (void)createLayer
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.view.bounds];
    UIBezierPath *rect = [UIBezierPath bezierPathWithRect:CGRectMake(0, [self topPaddingOfMaskLayer], 320, 320)];
    [path appendPath:rect];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.5;
    [self.view.layer addSublayer:fillLayer];
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

- (void)updateContentInsets
{
    if (self.imageView.frame.size.height - kMaskLayerSideLength >= [self topPaddingOfMaskLayer] * 2 ) {
        self.scrollView.contentInset = UIEdgeInsetsMake([self topPaddingOfMaskLayer], 0, [self topPaddingOfMaskLayer], 0);
        
    } else if (self.imageView.frame.size.height <= kMaskLayerSideLength) {
        self.scrollView.contentInset = UIEdgeInsetsZero;
    } else {
        self.scrollView.contentSize = self.scrollView.bounds.size;
        self.scrollView.contentInset = UIEdgeInsetsMake((self.imageView.frame.size.height - kMaskLayerSideLength) / 2, 0, (self.imageView.frame.size.height - kMaskLayerSideLength) / 2, 0);
    }
}


#pragma mark - UIScrollView delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    NSLog(@"content size: %f, %f", scrollView.contentSize.width, scrollView.contentSize.height);
    NSLog(@"image view size: %f, %f", self.imageView.frame.size.width, self.imageView.frame.size.height);
    
    [self centeredFrame:self.imageView forScrollView:self.scrollView];
    [self updateContentInsets];
}

//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
//{
//    [self updateContentInsets];
//	
//}


@end
