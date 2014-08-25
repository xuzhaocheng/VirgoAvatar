//
//  MainViewController.m
//  VirgoAvatar
//
//  Created by xuzhaocheng on 14-8-25.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "MainViewController.h"
#import "NumberView.h"

#define MIN_WIDTH       28
#define PADDING         1

@interface MainViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
//@property (weak, nonatomic) IBOutlet UIButton *pickerButton;

@property (nonatomic, strong) NumberView *numberView;
@end

@implementation MainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Virgo Avatar";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选取图片"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(takePhotoFromLibraryAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(saveToSameraRoll)];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)updateUI
{
    CGRect circleRect = CGRectMake(self.containerView.frame.size.width - PADDING - self.numberView.frame.size.width, PADDING, self.numberView.frame.size.width, MIN_WIDTH);
    self.numberView.frame = circleRect;
}

#pragma mark - Helpers
- (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)image:(UIImage *)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"保存到相册成功！"
                                                   delegate:nil cancelButtonTitle:@"好的"
                                          otherButtonTitles:nil];
    [alert show];
    
}

#pragma mark - UIImagePickerController delegate
//选择照片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil)
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    
    self.imageView.image = image;
    
    NSLog(@"imager: %@", image);
    
    if (!self.numberView) {
        self.numberView = [[NumberView alloc] initWithMinFrame:CGRectMake(self.containerView.frame.size.width - PADDING - MIN_WIDTH, PADDING, MIN_WIDTH, MIN_WIDTH)
                                                      maxFrame:CGRectMake(0, 0, self.imageView.frame.size.width, 20)];
        [self.containerView addSubview:self.numberView];
    }
}

//取消选择
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Handle Actions
- (void)saveToSameraRoll
{
    UIImageWriteToSavedPhotosAlbum([self imageWithView:self.containerView], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}


- (void)takePhotoFromLibraryAction
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


- (IBAction)textContentChanged:(UITextField *)sender
{
    if (self.numberView) {
        self.numberView.number = sender.text;
        [self updateUI];
    }
}




@end
