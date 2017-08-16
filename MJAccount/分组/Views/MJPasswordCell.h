//
//  MJPasswordCell.h
//  MJAccount
//
//  Created by YXCZ on 17/8/9.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

///密码显示通知key值
static NSString * passwordShowNotificationKey = @"passwordShowNotificationKey";
typedef void (^showPasswordBlock) (BOOL show);
@interface MJPasswordCell : UITableViewCell

@property (copy,nonatomic)NSString * title;
@property (copy,nonatomic)NSString * detailTitle;
/// 详情textField
@property (strong,nonatomic)UITextField *detailField;
/// 是否可编辑
@property (assign,nonatomic)BOOL editEnabled;
/// 是否展示密码
@property (assign,nonatomic)BOOL showPSW;

@property (copy,nonatomic)showPasswordBlock showBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
