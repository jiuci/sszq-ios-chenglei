//
//  BYTheme.m
//  IBY
//
//  Created by forbertl on 15/9/10.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYTheme.h"
#import "UIViewController+analysis.h"
@interface BYTheme ()

@end

@implementation BYTheme

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * minisiteID = [NSString stringWithFormat:@"urlEncode(“mid=%@”)",self.cmsCategoryID];
    self.pageParameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:minisiteID,@"cmsCategoryID", nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
