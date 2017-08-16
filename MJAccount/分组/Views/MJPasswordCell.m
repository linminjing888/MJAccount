//
//  MJPasswordCell.m
//  MJAccount
//
//  Created by YXCZ on 17/8/9.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "MJPasswordCell.h"

@interface MJPasswordCell()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *button;

@end
@implementation MJPasswordCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"MJPasswordCellID";
    // 1.缓存中取
    MJPasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[MJPasswordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    detailField.secureTextEntry = YES;
    [self.contentView addSubview:detailField];
    self.detailField = detailField;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"show_password"] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:@"hidden_password"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    self.button = button;
    
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
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.width.mas_equalTo(button.mas_height);
    }];
    
    //接收来自编辑页和详情页的通知,是否显示密码
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showPassword:) name:passwordShowNotificationKey object:nil];
}

-(void)buttonClick:(UIButton*)button{
    if (self.showBlock) {
        self.showBlock(button.selected);
    }
    ///测试
//    self.detailField.secureTextEntry = button.selected;
//    button.selected = !button.selected;
}
-(void)showPassword:(NSNotification*)noti{
    NSNumber * showNum = noti.object;
    BOOL showPSW = [showNum boolValue];
    
    self.detailField.secureTextEntry = !showPSW;
    self.button.selected = showPSW;
    _showPSW = showPSW;
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)setShowPSW:(BOOL)showPSW{
    self.detailField.secureTextEntry = !showPSW;
    self.button.selected = showPSW;
    _showPSW = showPSW;
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
