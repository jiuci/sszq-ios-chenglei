//
//  BYTestVC1.m
//  IBY
//
//  Created by panshiyu on 15/1/1.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYTestVC1.h"
#import "BYTextField.h"
#import "BYPortalCenter.h"
#import "BYCommonWebVC.h"
@interface BYTestVC1 ()

@end

@implementation BYTestVC1 {
    __weak IBOutlet BYTextField* txt1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.

}


- (IBAction)onJump:(id)sender {
    if (txt1.text.length < 2) {
        [MBProgressHUD topShowTmpMessage:@"敢问路在何方"];
        return;
    }
    NSDictionary *params;
    if ([txt1.text rangeOfString:@"http://"].length == 0) {
        params = @{
                   @"JumpURL":[NSString stringWithFormat:@"http://%@",txt1.text]
                   };
    }else{
        params = @{
                   @"JumpURL":txt1.text
                   };
    }
    JumpToWebBlk(params[@"JumpURL"], nil);
//    [[BYPortalCenter sharedPortalCenter]portTo:BYPortalHome params:params];
    
}

@end
