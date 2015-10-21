

#import <UIKit/UIKit.h>
#import "BYHomeInfo.h"
#import "BYHomeNavInfo.h"
@class BYNavHeaderView;


@protocol BYNavHeaderViewDelegate <NSObject>
@optional
- (void)headerViewDidClickedNameView:(BYNavHeaderView *)headerView;
@end

@interface BYNavHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) BYHomeNavInfo *group;
@property (nonatomic, assign) NSInteger myOpen;
@property (nonatomic, weak) id<BYNavHeaderViewDelegate> delegate;
@property (nonatomic, assign) NSInteger isLastSection;
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;
- (void)changeImageDirection;
@end
