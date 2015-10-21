
#import "BYNavHeaderView.h"
#import "UIImageView+WebCache.h"
#define BYNavGroupLeftImgHeight 20
#define BYNavGroupImgLeftMargin 24
#define BYNavGroupImgTopMargin 12
#define BYNavGroupLblLeftMargin 56
#define BYNavGroupImgTopMargin 12


#define BYNavGroupHeight 44
#define BYNavLineLeftMargin 50
#define BYNavLineLength 176
#define BYNavCellHeight 36
/**
 某个控件出不来:
 1.frame的尺寸和位置对不对
 
 2.hidden是否为YES
 
 3.有没有添加到父控件中
 
 4.alpha 是否 < 0.01
 
 5.被其他控件挡住了
 
 6.父控件的前面5个情况
 */

@interface BYNavHeaderView()
@property (nonatomic, weak) UILabel *countView;
@property (nonatomic, weak) UIButton *nameView;
@property (nonatomic, weak) UIView *groupView;
@property (nonatomic, weak) UILabel *groupLbl;
@property (nonatomic, weak) UIImageView *indicateImg;

@end

@implementation BYNavHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"header";
    BYNavHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[BYNavHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

/**
 *  在这个初始化方法中,BYNavHeaderView的frame\bounds没有值
 */
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        // 添加子控件
        // 1.添加按钮
        
        UIView *groupView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 400, BYNavGroupHeight)];
        groupView.backgroundColor = [UIColor clearColor];
        
        
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(BYNavLineLeftMargin, 0, BYNavLineLength, 1)];
        topView.backgroundColor = RGBACOLOR(0, 0, 0, 0.1);
        [groupView addSubview:topView];
        
        
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(BYNavLineLeftMargin, BYNavGroupHeight, BYNavLineLength, 1)];
        bottomView.backgroundColor = RGBACOLOR(0, 0, 0, 0.1);
        [groupView addSubview:bottomView];
       
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(BYNavGroupImgLeftMargin, BYNavGroupImgTopMargin, BYNavGroupLeftImgHeight, BYNavGroupLeftImgHeight)];
        img.backgroundColor = [UIColor clearColor];
        
        [groupView addSubview:img];
        
        // 设置按钮内部的左边箭头图片
       // NSURL *link = [NSURL URLWithString:@"http://www.vivo.com.cn/vivo/y18l/picture/s3-title-ico.jpg"];
        
        //[img sd_setImageWithURL:link placeholderImage:[UIImage imageNamed:@"btn_arrow_packup"]];
        img.image = [UIImage imageNamed:@"icon_menu_galasses"];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(BYNavGroupLblLeftMargin, BYNavGroupImgTopMargin, 150, 20)];
        lbl.tintColor = [UIColor whiteColor];
        [lbl setTextColor:[UIColor whiteColor]];
        [groupView addSubview:lbl];
        self.groupLbl = lbl;
        
        UIImageView *indicateImg = [[UIImageView alloc]initWithFrame:CGRectMake(194, 14, 16, 16)];
        indicateImg.backgroundColor = [UIColor clearColor];
        self.indicateImg = indicateImg;

        [groupView addSubview:indicateImg];
        indicateImg.image = [UIImage imageNamed:@"btn_arrow_pulldown"];
        
        
        UIButton *nameView = [[UIButton alloc]initWithFrame:groupView.frame];
        nameView.backgroundColor = [UIColor clearColor];

        [groupView addSubview:nameView];
        
        
        [nameView addTarget:self action:@selector(nameViewClick) forControlEvents:UIControlEventTouchUpInside];
     
        
        
        [self.contentView addSubview:groupView];
      
        self.groupView = groupView;
 
    }
    return self;
}

/**
 *  当一个控件的frame发生改变的时候就会调用
 *
 *  一般在这里布局内部的子控件(设置子控件的frame)
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 1.设置按钮的frame
    self.nameView.frame = self.bounds;
}

- (void)setGroup:(BYHomeNavInfo *)group
{
    _group = group;
    // [self.nameView setTitle:group.link forState:UIControlStateNormal];
    //  [self.nameView setTitle:@"测试" forState:UIControlStateNormal];
    //[self.groupLbl setText:@"测试" ];
    self.groupLbl.text = group.name;

}

/**
 *  监听组名按钮的点击
 */
- (void)nameViewClick
{
    
    // 1.修改组模型的标记(状态取反)
    //  self.group.opened = !self.group.opened;
    //  NSLog(@"%d",self.group.opened? 1: 2);
    
    
    // 2.刷新表格
    if ([self.delegate respondsToSelector:@selector(headerViewDidClickedNameView:)]) {
        [self.delegate headerViewDidClickedNameView:self];
    }
}


/**
 *  当一个控件被添加到父控件中就会调用
 */
- (void)didMoveToSuperview
{
    [self changeImageDirection];
}

- (void)changeImageDirection{
  
    if (self.myOpen == 1) {
        // self.indicateImg.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.indicateImg.image = nil;
        self.indicateImg.image = [UIImage imageNamed:@"btn_arrow_packup"];
    }else if (self.myOpen == -2){
        self.indicateImg.image = [UIImage imageNamed:@"btn_arrow_pulldown"];
    }
}

/**
 *  当一个控件即将被添加到父控件中会调用
 */
//- (void)willMoveToSuperview:(UIView *)newSuperview
//{
//    
//}
@end
