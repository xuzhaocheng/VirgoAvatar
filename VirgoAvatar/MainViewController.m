//
//  MainViewController.m
//  VirgoAvatar
//
//  Created by xuzhaocheng on 14-8-25.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "MainViewController.h"
#import "AvatarPicker.h"
#import "NumberView.h"
#import "MBProgressHUD.h"

#define STANDARD_WIDTH       28
#define PADDING              1

@interface MainViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate, AvatarPickerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *pickerButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;

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
    
    self.textField.placeholder = NSLocalizedString(@"😙Type somethings", @"点我输入内容");
    
    [self.pickerButton setTitle:NSLocalizedString(@"Select Photo", @"从相册选取图片") forState:UIControlStateNormal];
    self.pickerButton.layer.cornerRadius = 15.f;
    self.pickerButton.layer.masksToBounds = YES;
    self.pickerButton.layer.borderWidth = 0.2;
    self.pickerButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    self.saveButton =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
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
    if (self.imageView.image && self.imageView.hidden == YES) {
        self.saveButton.enabled = YES;
        self.imageView.hidden = NO;
        self.pickerButton.hidden = YES;
        if (!self.navigationItem.leftBarButtonItem) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reselect", @"重选")
                                                                                     style:UIBarButtonItemStylePlain
                                                                                    target:self
                                                                                    action:@selector(takePhotoFromLibraryAction)];
        }
    }
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
        self.HUD.labelText = NSLocalizedString(@"Done", @"保存成功");
    } else {
        self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        self.HUD.mode = MBProgressHUDModeCustomView;
        self.HUD.labelText = NSLocalizedString(@"Failed", @"保存失败");
    }
    
    [self.HUD hide:YES afterDelay:0.5];
    [self touchesBegan:nil withEvent:nil];
    
}

- (void)takePhotoFromLibraryAction
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:imagePickerController animated:YES completion:nil];
        });
    });
}

#pragma mark - UIImagePickerController delegate
//选择照片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (image == nil)
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        AvatarPicker *avatarPicker = [[AvatarPicker alloc] init];
        avatarPicker.delegate = self;
        avatarPicker.image = image;
        [self presentViewController:avatarPicker animated:YES completion:nil];
    }];
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
    self.HUD.labelText = NSLocalizedString(@"Saving...", @"保存中...");
    [self.HUD show:YES];
    UIImageWriteToSavedPhotosAlbum([self imageWithView:self.containerView], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
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

#pragma mark - AvatarPicker delegate
- (void)avatarPicker:(AvatarPicker *)avatarPicker didGetAvatar:(UIImage *)image
{
    self.imageView.image = image;
    [self updateUI];
    [self dismissViewController];
}

- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.imageView.image) {
        return YES;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Must select ONE photo", @"尚未选择图片")
                                                    message:NSLocalizedString(@"Please select a photo first", @"请先选取一张图片")
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"取消")
                                          otherButtonTitles:NSLocalizedString(@"Select", @"马上去选一张"), nil];
    alert.delegate = self;
    [alert show];
    return NO;
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self takePhotoFromLibraryAction];
    }
}




@end
