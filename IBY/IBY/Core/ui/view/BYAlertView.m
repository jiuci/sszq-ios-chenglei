//
//  BYAlertView.m
//  IBY
//
//  Created by panshiyu on 15/3/11.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYAlertView.h"

@interface BYAlertView ()

@property (nonatomic, retain) NSMutableDictionary* actionPairs;

@end

@implementation BYAlertView

- (NSMutableDictionary*)actionPairs
{
    if (_actionPairs == nil) {
        _actionPairs = [[NSMutableDictionary alloc] init];
    }
    return _actionPairs;
}

+ (instancetype)alertViewWithTitle:(NSString*)titile{
    return [self alertViewWithTitle:titile detail:nil];
}
+ (instancetype)alertViewWithTitle:(NSString*)titile detail:(NSString*)detail{
    return [self alertViewWithTitle:titile detail:detail cancelTips:@"知道了"];
}
+ (instancetype)alertViewWithTitle:(NSString*)titile detail:(NSString*)detail cancelTips:(NSString*)cancelTips{
    BYAlertView *alert = [[BYAlertView alloc] initWithTitle:titile message:detail delegate:nil cancelButtonTitle:cancelTips otherButtonTitles:nil, nil];
    return alert;
}


//- (void)addTarget:(id)target action:(SEL)selector forTitle:(NSString*)title
//{
//    self.delegate = self;
//    NSMethodSignature* sig = [target methodSignatureForSelector:selector];
//    if (sig) {
//        NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
//        [invo setTarget:target];
//        [invo setSelector:selector];
//        if (sig.numberOfArguments > 2) {
//            [invo setArgument:&title atIndex:2];
//        }
//
//        [self.actionPairs setObject:invo forKey:title];
//    }
//}

- (void)setTitle:(NSString*)title withBlock:(BYAlertBlock)block
{
    if (title && block) {
        self.delegate = self;
        [self.actionPairs setObject:[block copy] forKey:title];
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView*)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString* title = [self buttonTitleAtIndex:buttonIndex];
    //    NSInvocation* invo = [self.actionPairs objectForKey:title];
    //    [invo invoke];
    BYAlertBlock blk = self.actionPairs[title];
    if (blk) {
        blk();
    }
}

@end
