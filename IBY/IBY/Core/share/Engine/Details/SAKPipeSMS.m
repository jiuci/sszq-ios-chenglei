//
//  PipeSMS.m
//  SAKShareKit
//
//  Created by psy on 14-1-6.
//  Copyright (c) 2014年 psy. All rights reserved.
//

#import "SAKPipeSMS.h"

@implementation SAKPipeSMS

- (SAKShareMediaAvailability)isAvailable
{
    if (!NSClassFromString(@"MFMessageComposeViewController")) {
        return SAKShareMediaNotAvailable;
    }
    if (![MFMessageComposeViewController canSendText]) {
        return SAKShareMediaCanNotShare;
    }
    return SAKShareMediaAvailable;
}

- (void)share:(id<SAKSharerProcotol>)sharer from:(UIViewController*)fromVC willShare:(SAKWillShareBlock)willBlock didShare:(SAKDidShareBlock)finishBlock
{
    self.finishBlock = finishBlock;
    if ([self isAvailable]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"设备没有短信功能" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    MFMessageComposeViewController* messageComposeViewController = [[MFMessageComposeViewController alloc] init];
    messageComposeViewController.messageComposeDelegate = self;

    // content + url
    messageComposeViewController.body = [[sharer content] append:[sharer detailURLString]];
    [fromVC presentViewController:messageComposeViewController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController*)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    NSError* aError = nil;
    if (result == MessageComposeResultCancelled) {
        aError = [NSError errorWithDomain:kSAKShareErrorDomain code:SAKShareErrorCancelled userInfo:nil];
    }
    else if (result == MessageComposeResultFailed) {
        aError = [NSError errorWithDomain:kSAKShareErrorDomain code:SAKShareErrorUnknown userInfo:nil];
    }

    self.finishBlock(aError);
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
