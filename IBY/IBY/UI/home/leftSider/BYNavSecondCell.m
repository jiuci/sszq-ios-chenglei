

#import "BYNavSecondCell.h"
#import "BYHomeNavInfo.h"
#define BYNavGroupHeight 44
#define BYNavLineLeftMargin 50
#define BYNavLineLength 176
#define BYNavCellHeight 36
@implementation BYNavSecondCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"friend";
    BYNavSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
//        UIButton *cellBtn = [[UIButton alloc]initWithFrame:CGRectMake(BYNavLineLeftMargin + 16, 0, BYNavLineLength, 36)];
        cell = [[BYNavSecondCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}

- (void)setInfo:(BYHomeNavInfo *)info
{
    _info = info;
   // self.frame = CGRectMake(BYNavLineLeftMargin + 16, 0, BYNavLineLength, 36);
    self.textLabel.text = info.name;
   // [self.cellBtn setTitle:info.name forState:UIControlStateNormal];
}

@end
