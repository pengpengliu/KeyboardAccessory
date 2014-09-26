//
//  ViewController.m
//  Message
//
//  Created by LPP on 14-9-25.
//  Copyright (c) 2014年 上海世启信息科技有限公司. All rights reserved.
//

#import "MessageViewController.h"

NSString * const CNInputAccessoryViewKeyboardFrameDidChangeNotification = @"com.message.MessageViewController.TextInputbar.FrameDidChange";

@interface CNInputAccessoryView : UIView

@end

@implementation CNInputAccessoryView

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (self.superview) {
        [self.superview removeObserver:self forKeyPath:NSStringFromSelector(@selector(center))];
    }
    
    [newSuperview addObserver:self forKeyPath:NSStringFromSelector(@selector(center)) options:0 context:NULL];
    
    [super willMoveToSuperview:newSuperview];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isEqual:self.superview] && [keyPath isEqualToString:NSStringFromSelector(@selector(center))])
    {
        NSDictionary *userInfo = @{UIKeyboardFrameEndUserInfoKey:[NSValue valueWithCGRect:[object frame]]};
        [[NSNotificationCenter defaultCenter] postNotificationName:CNInputAccessoryViewKeyboardFrameDidChangeNotification object:nil userInfo:userInfo];
    }
}

- (void)dealloc
{
    if (self.superview) {
        [self.superview removeObserver:self forKeyPath:NSStringFromSelector(@selector(center))];
    }
}

@end

@interface MessageViewController ()

@property (strong, nonatomic) IBOutlet UIView *accessoryView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *textInputbar;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintToAdjust;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerNotifications];
    
    self.textField.inputAccessoryView = self.accessoryView;
}


#pragma mark - NSNotificationCenter register/unregister

- (void)registerNotifications
{
    // Keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeKeyboardFrame:)
                                                 name:CNInputAccessoryViewKeyboardFrameDidChangeNotification object:nil];
    
}

- (void)unregisterNotifications
{
    // Keyboard notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - Notification Events

- (void)adjustTextViewByKeyboardState:(BOOL)showKeyboard keyboardInfo:(NSDictionary *)info {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    // transform the UIViewAnimationCurve to a UIViewAnimationOptions mask
    UIViewAnimationCurve animationCurve = [info[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    UIViewAnimationOptions animationOptions = UIViewAnimationOptionBeginFromCurrentState;
    if (animationCurve == UIViewAnimationCurveEaseIn) {
        animationOptions |= UIViewAnimationOptionCurveEaseIn;
    }
    else if (animationCurve == UIViewAnimationCurveEaseInOut) {
        animationOptions |= UIViewAnimationOptionCurveEaseInOut;
    }
    else if (animationCurve == UIViewAnimationCurveEaseOut) {
        animationOptions |= UIViewAnimationOptionCurveEaseOut;
    }
    else if (animationCurve == UIViewAnimationCurveLinear) {
        animationOptions |= UIViewAnimationOptionCurveLinear;
    }

    
    if (showKeyboard) {
        
        NSValue *keyboardFrameVal = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = [keyboardFrameVal CGRectValue];
        CGFloat height = keyboardFrame.size.height;
        
        // adjust the constraint constant to include the keyboard's height
        self.constraintToAdjust.constant = height - self.accessoryView.bounds.size.height;
    }
    else {
        self.constraintToAdjust.constant = 0;
    }
    
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:([info[UIKeyboardAnimationCurveUserInfoKey] integerValue]<<16)|UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.view layoutIfNeeded];
                         
                     }
                     completion:NULL];
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    [self adjustTextViewByKeyboardState:YES keyboardInfo:userInfo];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    [self adjustTextViewByKeyboardState:NO keyboardInfo:userInfo];
}

- (void)didChangeKeyboardFrame:(NSNotification *)notification
{
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.constraintToAdjust.constant = CGRectGetHeight([UIScreen mainScreen].bounds)-endFrame.origin.y- self.accessoryView.bounds.size.height;
    
    [self.view layoutIfNeeded];
}

@end
