//
//  DEMOMenuViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "BYLeftMenuViewController.h"
#import "RESideMenu.h"
#import "UIImageView+WebCache.h"
#import "BYMacro.h"
#import "BYHomeInfo.h"
#import "BYHomeService.h"
#import "BYImageView.h"
#import "BYNavSecondCell.h"
#import "BYNavHeaderView.h"
#import "BYNavHeaderView.h"
#import "BYThemeVC.h"
#import "BYAppDelegate.h"
#import "BYHomeFloorInfo.h"
#define BYNavGroupHeight 44
#define BYNavLineLeftMargin 50
#define BYNavLineLength 176
#define BYNavCellHeight 36

@interface BYLeftMenuViewController () <BYNavHeaderViewDelegate>

@property (strong, readwrite, nonatomic) UITableView *tableView;
@property (strong,nonatomic)BYNavHeaderView *headView;
@property (nonatomic, strong) BYHomeService * service;
@property (nonatomic, assign) CGPoint contentoffset;
@property (nonatomic,assign) int sectionNum;
@property (strong, nonatomic) BYNavVC* homeNav;
@end

@implementation BYLeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTableView];
    
    self.reSideMenu = ((BYAppDelegate*)[UIApplication sharedApplication].delegate).reSideMenu;
    self.homeVC = ((BYAppDelegate*)[UIApplication sharedApplication].delegate).homeVC;
    self.sectionNum = -1;
}
- (UITableView*)tableView
{
    if (_tableView) {
        return _tableView;
    }
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,  20 + 44, self.view.frame.size.width, self.view.height - 64 - 40) style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.opaque = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView = nil;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.bounces = NO;
    // 每一行cell的高度
    tableView.rowHeight = BYNavCellHeight;
    // 每一组头部控件的高度
    tableView.sectionHeaderHeight = BYNavGroupHeight;
    
    _tableView = tableView;
    return tableView;
    
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == self.tableView)
//    {
//        CGFloat sectionHeaderHeight = BYNavCellHeight;
//        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//        }
//    }
//}
- (void)setupTableView
{
    
    [self.view addSubview:self.tableView];


}

- (void)setInfo:(BYHomeInfo *)info
{
    _info = info;
    [self.tableView reloadData];
}

- (void)updateTableView
{
//    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}




#pragma mark UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.info.barNodesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    NSArray *group = self.info.barNodesArray;
    BYHomeNavInfo *sectionInfo = group[sectionIndex];
    return  self.sectionNum == sectionIndex? sectionInfo.secondArray.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    BYNavSecondCell *cell = [BYNavSecondCell cellWithTableView:tableView];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    BYHomeNavInfo *cellInfo = self.info.barNodesArray[indexPath.section];
    NSArray *cellArray = cellInfo.secondArray;
    // 2.设置cell的数据
    cell.info = cellArray[indexPath.row];
    BOOL lastCell = (indexPath.row+1) == cellArray.count;
    cell.bottomLine.hidden = !lastCell;
    //    if (indexPath.row == 0 && indexPath.section != 4) {
//        UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(BYNavLineLeftMargin, 0, BYNavLineLength, 1)];
//        cellView.backgroundColor = nil;
//        cellView.backgroundColor = RGBACOLOR(0, 0, 0, 0.1);
//        [cell addSubview:cellView];
//        return  cell;
//    }

    return cell;
}


/**
 *  返回每一组需要显示的头部标题(字符出纳)
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    // 1.创建头部控件
    BYNavHeaderView *header = [BYNavHeaderView headerViewWithTableView:tableView];
    header.tag = section;
    header.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buddy_header_bg"]];
    header.backgroundView.alpha = 0;
    header.contentView.backgroundColor = [UIColor clearColor];
    header.delegate = self;
    NSArray *group = self.info.barNodesArray;
    BYHomeNavInfo *sectionInfo = group[section];
    header.canOpen = sectionInfo.secondArray.count > 0;
    header.isOpen = self.sectionNum == section;
    header.group = sectionInfo;
    return header;
}




#pragma mark - headerView的代理方法
/**
 *  点击了headerView上面的名字按钮时就会调用
 */
- (void)headerViewDidClickedNameView:(BYNavHeaderView *)headerView finish:(void (^)(void))finish
{
    if (!headerView.canOpen) {
        BYHomeNavInfo *headerInfo = headerView.group;
        //  [self.reSideMenu hideMenuViewControllerAnimated:YES finish:nil];
        [self.reSideMenu hideMenuViewControllerAnimated:YES finish:^{
            NSString *link = headerInfo.link;
            [self.homeVC onCelltap:link];
            if (finish) {
                finish();
            }
        }];
        return;
    }
    if (self.sectionNum == headerView.tag) {
        self.sectionNum = -1;
    }else{
         self.sectionNum = (int)headerView.tag;
    }
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak BYNavSecondCell * cell = (BYNavSecondCell*)[tableView cellForRowAtIndexPath:indexPath];
//    NSLog(@"%@",cell);
    [UIView animateWithDuration:.3 animations:^{
        cell.titleLabel.transform = CGAffineTransformMakeScale(1.15, 1.15);
        cell.titleLabel.alpha = .1;
    } completion:^(BOOL finish){
        
        
        BYHomeNavInfo * navinfo = self.info.barNodesArray[indexPath.section];
        BYHomeInfoSimple *cellInfo = navinfo.secondArray[indexPath.row];
        [self.reSideMenu hideMenuViewControllerAnimated:YES finish:^{
            NSString *link = cellInfo.link;
            [self.homeVC onCelltap:link];
            cell.titleLabel.transform = CGAffineTransformIdentity;
            cell.titleLabel.alpha = 1;
        }];
    }];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == self.tableView)
//    {
//        CGFloat sectionHeaderHeight = 44;
//        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//        }
//    }
//}



@end
