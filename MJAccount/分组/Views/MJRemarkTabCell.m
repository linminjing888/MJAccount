//
//  MJRemarkTabCell.m
//  MJAccount
//
//  Created by YXCZ on 17/8/9.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "MJRemarkTabCell.h"

@interface MJRemarkTabCell()

@property (strong, nonatomic) UILabel *titleLabel;

@end
@implementation MJRemarkTabCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"MJRemarkTabCellID";
    // 1.缓存中取
    MJRemarkTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[MJRemarkTabCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
        
    }
    return self;
}
-(void)setupViews
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = MJColorFromHex(0x555555);
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UITextView *textView = [UITextView new];
    textView.textColor = MJColorFromHex(0x555555);
    textView.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:textView];
    textView.text = @"写点什么吧";
    self.textView = textView;
    
    MJWeakSelf(ws)
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.contentView).offset(10);
        make.top.mas_equalTo(ws.contentView);
        make.right.mas_equalTo(ws.contentView).offset(-10);
        make.height.mas_equalTo(@40);
    }];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(titleLabel);
        make.top.mas_equalTo(titleLabel.mas_bottom);
        make.bottom.mas_equalTo(ws.contentView);
    }];
}
-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
    _title = title;
}
-(void)setDetailTitle:(NSString *)detailTitle{
    self.textView.text  =detailTitle;
    _detailTitle = detailTitle;
}
-(void)setEditEnabled:(BOOL)editEnabled{
    _editEnabled = editEnabled;
    self.textView.userInteractionEnabled = editEnabled;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
