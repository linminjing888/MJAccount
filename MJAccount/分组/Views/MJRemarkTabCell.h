//
//  MJRemarkTabCell.h
//  MJAccount
//
//  Created by YXCZ on 17/8/9.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJRemarkTabCell : UITableViewCell

@property (copy,nonatomic)NSString * title;
@property (copy,nonatomic)NSString * detailTitle;
/// 详情textView
@property (strong,nonatomic)UITextView *textView;
/// 是否可编辑
@property (assign,nonatomic)BOOL editEnabled;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
