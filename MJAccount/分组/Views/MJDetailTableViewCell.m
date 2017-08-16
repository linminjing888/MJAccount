//
//  MJDetailTableViewCell.m
//  MJAccount
//
//  Created by YXCZ on 17/8/9.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "MJDetailTableViewCell.h"

@interface MJDetailTableViewCell()

@property (strong, nonatomic) UILabel *titleLabel;

@end
@implementation MJDetailTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // NSLog(@"cellForRowAtIndexPath");
    static NSString *identifier = @"MJDetailTableViewCellID";
    // 1.缓存中取
    MJDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[MJDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    
    UITextField *detailField = [UITextField new];
    detailField.textColor = MJColorFromHex(0x444444);
    detailField.font = [UIFont systemFontOfSize:14];
    detailField.borderStyle = UITextBorderStyleNone;
    [self.contentView addSubview:detailField];
    self.detailField = detailField;
    
    MJWeakSelf(ws)
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(ws.contentView);
        make.left.mas_equalTo(ws.contentView).offset(10);
        make.width.mas_equalTo(@60);
    }];
    
    [detailField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(ws.contentView);
        make.left.mas_equalTo(titleLabel.mas_right).offset(10);
        make.right.mas_equalTo(ws.contentView).offset(-10);
    }];
}
-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
    _title = title;
}
-(void)setDetailTitle:(NSString *)detailTitle{
    self.detailField.text  =detailTitle;
    _detailTitle = detailTitle;
}
-(void)setEditEnabled:(BOOL)editEnabled{
    _editEnabled = editEnabled;
    self.detailField.userInteractionEnabled = editEnabled;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
