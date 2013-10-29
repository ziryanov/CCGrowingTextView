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
    __weak UITextView *wself = self;
    _CCGrowingTextViewTextChangedNotification = [[NSNotificationCenter defaultCenter] addObserverForName:UITextViewTextDidChangeNotification object:self queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        double delayInSeconds = .001;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (wself.contentSize.height != wself.frame.size.height)
                [wself invalidateIntrinsicContentSize];
        });
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:_CCGrowingTextViewTextChangedNotification];
}

- (CGSize)intrinsicContentSize
{
    return self.contentSize;
}

@end
