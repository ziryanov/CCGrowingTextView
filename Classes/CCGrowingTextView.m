//
//  CCGrowingTextView.m
//  GrowingTextViewExample
//
//  Created by ziryanov on 29/10/13.
//  Copyright (c) 2013 ziryanov. All rights reserved.
//

#import "CCGrowingTextView.h"

@interface CCGrowingTextView()

@property (nonatomic) id CCGrowingTextViewTextChangedNotification;
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
        [wself CCGrowingTextView_updateHeight];
    }];
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
    return self.maxNumberOfLine ? CGSizeMake(self.contentSize.width, MIN(self.contentSize.height, self.maxHeight)) : self.contentSize;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self CCGrowingTextView_updateHeight];
}

- (void)setMaxNumberOfLine:(NSUInteger)maxNumberOfLine
{
    _maxNumberOfLine = maxNumberOfLine;
    NSString* text = @"\n";
    for (NSUInteger i = 0; i < maxNumberOfLine; i++) {
        text = [text stringByAppendingString:@"\n"];
    }
    self.maxHeight = [text sizeWithAttributes:@{NSFontAttributeName: self.font}].height;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.maxNumberOfLine = self.maxNumberOfLine;
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    [super setContentInset:contentInset];
    self.maxNumberOfLine = self.maxNumberOfLine;
}

- (void)CCGrowingTextView_updateHeight {
    __weak CCGrowingTextView *wself = self;
    double delayInSeconds = .05;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (wself.contentSize.height != wself.frame.size.height)
            [wself invalidateIntrinsicContentSize];
    });
}

@end
