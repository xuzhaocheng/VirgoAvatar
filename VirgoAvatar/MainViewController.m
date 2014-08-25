//
//  MainViewController.m
//  VirgoAvatar
//
//  Created by xuzhaocheng on 14-8-25.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "MainViewController.h"
#import "NumberView.h"
#import "MBProgressHUD.h"

#define STANDARD_WIDTH       28
#define PADDING              1

@interface MainViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *pickerButton;

@property (nonatomic, strong) UIBarButtonItem *saveButton;
@property (nonatomic, strong) NumberView *numberView;
@property (nonatomic, strong) MBProgressHUD *HUD;
@end

@implementation MainViewController

- (CGFloat)scale { return self.containerView.frame.size.width / 100; }
- (CGFloat)numberViewHeight { return STANDARD_WIDTH * [self scale]; }

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Virgo Avatar";
    
    self.pickerButton.layer.cornerRadius = 15.f;
    self.pickerButton.layer.masksToBounds = YES;
    self.pickerButton.layer.borderWidth = 0.2;
    self.pickerButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    self.saveButton =  [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(saveToSameraRoll)];
    self.saveButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = self.saveButton;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)updateUI
{
    CGRect circleRect = CGRectMake(self.containerView.frame.size.width - PADDING - self.numberView.frame.size.width, PADDING, self.numberView.frame.size.width, [self numberViewHeight]);
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
    if (!error) {
        self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
        self.HUD.mode = MBProgressHUDModeCustomView;
        self.HUD.labelText = @"保存成功";
    } else {
        self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        self.HUD.mode = MBProgressHUDModeCustomView;
        self.HUD.labelText = @"保存失败";
    }
    
    [self.HUD hide:YES afterDelay:0.5];
    [self touchesBegan:nil withEvent:nil];
    
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
    
    if (self.imageView.hidden == YES) {
        self.saveButton.enabled = YES;
        self.imageView.hidden = NO;
        self.pickerButton.hidden = YES;
        if (!self.navigationItem.leftBarButtonItem) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重选"
                                                                                     style:UIBarButtonItemStylePlain
                                                                                    target:self
                                                                                    action:@selector(takePhotoFromLibraryAction)];
        }
        
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
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    self.HUD.labelText = @"保存中...";
    [self.HUD show:YES];
    UIImageWriteToSavedPhotosAlbum([self imageWithView:self.containerView], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}


- (void)takePhotoFromLibraryAction
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:^{
        if (self.numberView) {
            [self.numberView removeFromSuperview];
            self.numberView = nil;
        }
    }];
}

- (IBAction)pickrButtonClicked:(id)sender
{
    [self takePhotoFromLibraryAction];
}


- (IBAction)textContentChanged:(UITextField *)sender
{
    CGRect frame;
    if (sender.text.length == 0) {
        frame = self.numberView.frame;
        frame.origin.y = self.view.frame.size.height;
        frame.origin.x = self.view.frame.size.width;
        frame.size = CGSizeZero;
    } else {
        frame = CGRectMake(self.containerView.frame.size.width - PADDING - [self numberViewHeight], PADDING, [self numberViewHeight], [self numberViewHeight]);
    }
    
    if (!self.numberView) {
        self.numberView = [[NumberView alloc] initWithMinFrame:CGRectMake(self.containerView.frame.size.width - PADDING - [self numberViewHeight], PADDING, [self numberViewHeight], [self numberViewHeight])
                                                      maxFrame:CGRectMake(0, 0, self.imageView.frame.size.width, 20)
                                                  cornerRadius:[self numberViewHeight] / 2];
        [self.containerView addSubview:self.numberView];
    }

    if (!CGRectEqualToRect(frame, self.numberView.frame)) {
        [UIView animateWithDuration:0.3
                              delay:0
             usingSpringWithDamping:0.85
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.numberView.frame = frame;
                         } completion:nil];
    }
    
    if (sender.text && sender.text.length != 0) {
        self.numberView.number = sender.text;
        [self updateUI];
    }
}

#pragma mark - UITextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.imageView.image) {
        return YES;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"尚未选择图片"
                                                    message:@"请先选取一张图片"
                                                   delegate:nil
                                          cancelButtonTitle:@"马上去选一张" otherButtonTitles: nil];
    [alert show];
    return NO;
}




@end
