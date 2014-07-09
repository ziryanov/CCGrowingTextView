//
//  CCGrowingTextView.m
//  GrowingTextViewExample
//
//  Created by ziryanov on 29/10/13.
//  Copyright (c) 2013 ziryanov. All rights reserved.
//

#import "CCGrowingTextView.h"

#define CCGrowingTextView_isIOS7 ( [[[UIDevice currentDevice] systemVersion] integerValue] >= 7 )

@interface CCGrowingTextView()

@property (nonatomic) id CCGrowingTextViewTextChangedNotification;

@property (nonatomic) UILabel *placeholderLabel;

@property (nonatomic) CGFloat maxHeight;

@end

@implementation CCGrowingTextView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self CCGrowingTextView_initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self CCGrowingTextView_initialize];
    }
    return self;
}

- (void)CCGrowingTextView_initialize
{
    __weak CCGrowingTextView *wself = self;
    _CCGrowingTextViewTextChangedNotification = [[NSNotificationCenter defaultCenter] addObserverForName:UITextViewTextDidChangeNotification object:self queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [wself CCGrowingTextView_updatePlaceholder];
        [wself CCGrowingTextView_updateHeight];
    }];
    
    _placeholderLabel = [UILabel new];
    [self CCGrowingTextView_updatePlaceholderLabelHeight];
    [self CCGrowingTextView_updatePlaceholderLabelHorizontalSize];

    _placeholderLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    _placeholderLabel.font = self.font;
    _placeholderLabel.textColor = [[self.class appearance] placeholderColor] ?: [UIColor lightGrayColor];
    [self addSubview:_placeholderLabel];
    [self CCGrowingTextView_updatePlaceholder];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.text.length)
        return;
    [self CCGrowingTextView_updateHeight];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:_CCGrowingTextViewTextChangedNotification];
}

- (CGSize)intrinsicContentSize
{
    return self.maxNumberOfLine ? CGSizeMake(self.contentSize.width, MAX(_placeholderLabel.frame.size.height, MIN(self.contentSize.height, self.maxHeight))) : self.contentSize;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    _placeholderLabel.hidden = text.length > 0;
    [self CCGrowingTextView_updateHeight];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    _placeholderLabel.hidden = attributedText.string.length > 0;
    [self CCGrowingTextView_updateHeight];
}

- (void)recalculateMaxHeight
{
    NSString* text = @"1";
    for (NSUInteger i = 1; i < _maxNumberOfLine; i++) {
        text = [text stringByAppendingString:@"\n1"];
    }
    NSString *originalText = self.text;
    self.text = text;
    self.maxHeight = [self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)].height;
    self.text = originalText;
}

- (void)setMaxNumberOfLine:(NSUInteger)maxNumberOfLine
{
    _maxNumberOfLine = maxNumberOfLine;
    [self recalculateMaxHeight];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self recalculateMaxHeight];
    _placeholderLabel.font = font;
    [self CCGrowingTextView_updatePlaceholderLabelHeight];
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    [super setContentInset:contentInset];
    [self recalculateMaxHeight];
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset
{
    [super setTextContainerInset:textContainerInset];
    [self CCGrowingTextView_updatePlaceholderLabelHorizontalSize];
}

- (void)CCGrowingTextView_updateHeight
{
    __weak CCGrowingTextView *wself = self;
    double delayInSeconds = .05;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (wself.contentSize.height != wself.frame.size.height)
            [wself invalidateIntrinsicContentSize];
    });
}

- (void)CCGrowingTextView_updatePlaceholderLabelHeight
{
    NSString *originalText = self.text;
    self.text = @"1";
    CGRect placeholderLabelFrame = _placeholderLabel.frame;
    placeholderLabelFrame.size.height = [self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)].height;
    _placeholderLabel.frame = placeholderLabelFrame;
    self.text = originalText;
}

- (void)CCGrowingTextView_updatePlaceholderLabelHorizontalSize
{
    CGFloat placeholderLabelXOrigin = CCGrowingTextView_isIOS7 ? 5 : 8;
    CGFloat placeholderLabelWidth = self.frame.size.width - placeholderLabelXOrigin * 2;
    if ([self respondsToSelector:@selector(textContainerInset)])
    {
        placeholderLabelXOrigin += self.textContainerInset.left;
        placeholderLabelWidth -= self.textContainerInset.left + self.textContainerInset.right;
    }
    CGRect placeholderLabelFrame = _placeholderLabel.frame;
    placeholderLabelFrame.origin.x = placeholderLabelXOrigin;
    placeholderLabelFrame.size.width = placeholderLabelWidth;
    _placeholderLabel.frame = placeholderLabelFrame;
}

- (void)CCGrowingTextView_updatePlaceholder
{
    _placeholderLabel.hidden = self.text.length > 0;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderLabel.textColor = placeholderColor;
}

- (UIColor *)placeholderColor
{
    return _placeholderLabel.textColor;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholderLabel.text = placeholder;
}

- (NSString *)placeholder
{
    return _placeholderLabel.text;
}

@end
