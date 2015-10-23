

#import "BYNavSecondCell.h"
#import "BYHomeNavInfo.h"
#define BYNavGroupHeight 44
#define BYNavLineLeftMargin 50
#define BYNavLineLength 176
#define BYNavCellHeight 36
@implementation BYNavSecondCell

- (void)layoutSubviews{
    [super layoutSubviews];
    
}
- (void)setupUI
{
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:68]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(BYNavLineLeftMargin, BYNavCellHeight - 1, BYNavLineLength, 1)];
    _bottomLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.1);
    [self.contentView addSubview:_bottomLine];

    
}
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = ItalicFont(14);
    }
    return  _titleLabel;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"friend";
    BYNavSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[BYNavSecondCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        [cell setupUI];
    }
    
    return cell;
}

- (void)setInfo:(BYHomeNavInfo *)info
{
    _info = info;
    _titleLabel.text = info.name;
}
@end
