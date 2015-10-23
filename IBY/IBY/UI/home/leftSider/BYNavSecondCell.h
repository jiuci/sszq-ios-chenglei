

#import <UIKit/UIKit.h>
@class BYHomeInfo,BYHomeNavInfo;

@interface BYNavSecondCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
// friend是C++的关键字,不能用friend作为属性名
@property (nonatomic, strong) BYHomeNavInfo *info;
@property (nonatomic, strong) UILabel *titleLabel;
@property (strong, nonatomic) UIView *bottomLine;
@end
