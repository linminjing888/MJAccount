//
//  MJSearchHeaderView.m
//  MJAccount
//
//  Created by YXCZ on 17/8/10.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "MJSearchHeaderView.h"

@implementation MJSearchHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    
    UILabel * label = [[UILabel alloc]init];
    label.textColor = MJColorFromRGB(142, 142, 142);
    label.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:label];
    self.titleLabel = label;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.top.mas_equalTo(self.contentView).offset(4);
        make.bottom.mas_equalTo(self.contentView).offset(-4);
        make.right.mas_equalTo(self.contentView).offset(-10);
    }];
}
@end
