//
//  ViewController.m
//  GrowingTextViewExample
//
//  Created by ziryanov on 29/10/13.
//  Copyright (c) 2013 ziryanov. All rights reserved.
//

#import "ViewController.h"

@interface UIView (keyboardAnimation)

+ (void)animateWithKeyboardNotification:(NSNotification *)noti animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

@end

@implementation UIView (keyboardAnimation)

+ (void)animateWithKeyboardNotification:(NSNotification *)note animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
{
    UIViewAnimationOptions curveOptions = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] integerValue] delay:0 options:curveOptions animations:animations completion:completion];
}

@end

@interface ViewController ()

@property (nonatomic) IBOutlet UITextView *textView;
@property (nonatomic) IBOutlet NSLayoutConstraint *bottomConstrait;

@property (nonatomic) NSMutableArray *notifications;

- (IBAction)viewTapped;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _notifications = [NSMutableArray new];
    
    __weak ViewController *wself = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:0 queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        wself.bottomConstrait.constant = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        [UIView animateWithKeyboardNotification:note animations:^{
            [wself.view layoutIfNeeded];
        } completion:0];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:0 queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        wself.bottomConstrait.constant = 0;
        [UIView animateWithKeyboardNotification:note animations:^{
            [wself.view layoutIfNeeded];
        } completion:0];
    }];
}

- (void)dealloc
{
    for (id noti in _notifications)
        [[NSNotificationCenter defaultCenter] removeObserver:noti];
}

- (IBAction)viewTapped
{
    [_textView resignFirstResponder];
}

@end
