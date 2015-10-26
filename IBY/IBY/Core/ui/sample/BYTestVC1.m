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
#import "BYThemeVC.h"
@interface BYTestVC1 ()

@end

@implementation BYTestVC1 {
    __weak IBOutlet BYTextField* txt1;
    __weak IBOutlet BYTextField* txt2;
    __weak IBOutlet BYTextField* txt3;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.

}


- (IBAction)onJump:(id)sender
{
    if (txt1.text.length > 1) {
        NSDictionary *params;
        if ([txt1.text rangeOfString:@"http://"].length == 0 &&
            [txt1.text rangeOfString:@"https://"].length == 0) {
            params = @{
                       @"JumpURL":[NSString stringWithFormat:@"http://%@",txt1.text]
                       };
        }else{
            params = @{
                       @"JumpURL":txt1.text
                       };
        }
        JumpToWebBlk(params[@"JumpURL"], nil);
    }else if (txt2.text.length > 1){
        BYThemeVC * themeVC = [BYThemeVC testThemeWithId:txt2.text.intValue];
        themeVC.url = [NSString stringWithFormat:@"http://m.biyao.fu.theme:%d/",txt2.text.intValue];
        [self.navigationController pushViewController:themeVC animated:YES];
    }else if (txt3.text.length > 1){
        NSString * str = [NSString stringWithFormat:@"http://m.biyao.com/product/show?designid=%@",txt3.text];
        JumpToWebBlk(str, nil);
    }else{
        [MBProgressHUD topShowTmpMessage:@"敢问路在何方"];
    }
//    [[BYPortalCenter sharedPortalCenter]portTo:BYPortalHome params:params];
    
}

@end
