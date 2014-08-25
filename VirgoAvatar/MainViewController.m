//
//  MainViewController.m
//  VirgoAvatar
//
//  Created by xuzhaocheng on 14-8-25.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "MainViewController.h"
#import "NumberView.h"

#define CIRCLE_RADIUS   10
#define PADDING         1

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect circleRect = CGRectMake(self.imageView.frame.size.width - PADDING - CIRCLE_RADIUS * 2, PADDING, CIRCLE_RADIUS * 2, CIRCLE_RADIUS * 2);
    NumberView *numberView = [[NumberView alloc] initWithFrame:circleRect];
    [self.imageView addSubview:numberView];

}


- (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (UIImage *)drawNumner
{
    UIGraphicsBeginImageContextWithOptions(self.imageView.frame.size, NO, [UIScreen mainScreen].scale);
    NSLog(@"width: %f", self.imageView.frame.size.width);
    
    [self.imageView.image drawInRect:CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];

    CGRect circleRect = CGRectMake(self.imageView.frame.size.width - PADDING - CIRCLE_RADIUS * 2, PADDING, CIRCLE_RADIUS * 2, CIRCLE_RADIUS * 2);
    
    UIBezierPath *circl = [UIBezierPath bezierPathWithOvalInRect:circleRect];
    [[UIColor redColor] setFill];
    [circl fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}


- (IBAction)saveToSameraRoll:(id)sender
{
//    [self drawNumner];
//    self.imageView.hidden = YES;
//    UIImageView *imagev = [[UIImageView alloc] initWithFrame:self.imageView.frame];
//    imagev.image =  [self drawNumner];
//    [self.view addSubview:imagev];
//    
//    UIImageWriteToSavedPhotosAlbum(imagev.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//    
    UIImageWriteToSavedPhotosAlbum([self imageWithView:self.imageView], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image: (UIImage *)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo
{
    NSLog(@"save done");
}


@end
