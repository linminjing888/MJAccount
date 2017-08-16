//
//  MJBaseViewController.m
//  MJAccount
//
//  Created by YXCZ on 17/8/7.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "MJBaseViewController.h"

@interface MJBaseViewController ()
@property (nonatomic,strong)UIView * customNavigationView;
@property (nonatomic,copy)MJButtonBlock leftButtonAction;
@property (nonatomic,copy)MJButtonBlock rightButtonAction;
@end

@implementation MJBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createCustomView];
}
-(void)createCustomView{
    UIView * bgView = [UIView new];
    bgView.backgroundColor = MJColorMain;
    [self.view addSubview:bgView];
    self.customNavigationView = bgView;
    
    MJWeakSelf(ws)
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.mas_equalTo(ws.view);
        make.height.mas_equalTo(MJNavigationHeight+10);
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLabel];
    self.customTitleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView.mas_centerX);
        make.centerY.mas_equalTo(bgView.mas_centerY).offset(5);
    }];
    [titleLabel sizeToFit];
}
- (void)MJSetNavigationTitle:(NSString*)title{
    self.customTitleLabel.text = title;
    [self.customTitleLabel sizeToFit];
}
- (void)MJSetLeftButtonWithTitle:(NSString*)title
                   selectedImage:(NSString*)selectImageName
                     normalImage:(NSString*)normalImage
                     actionBlock:(MJButtonBlock)block{
    if (self.leftButon == nil) {
        self.leftButon = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftButon.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.leftButon setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.leftButon addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.customNavigationView addSubview:self.leftButon];
        
        MJWeakSelf(ws)
        [self.leftButon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.customNavigationView).offset(5);
            make.top.mas_equalTo(ws.customNavigationView).offset(20);
            make.bottom.mas_equalTo(ws.customNavigationView);
            make.width.mas_equalTo(@44);
        }];
    }
    [self.leftButon setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [self.leftButon setImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
    [self.leftButon setTitle:title forState:UIControlStateNormal];
    self.leftButtonAction = block;
}
-(void)leftBtnClicked:(UIButton*)btn{
    btn.selected = !btn.selected;
    if (self.leftButtonAction != nil) {
        self.leftButtonAction(btn);
    }
}
- (void)MJSetRightButtonWithTitle:(NSString*)title
                    selectedImage:(NSString*)selectImageName
                      normalImage:(NSString*)normalImage
                      actionBlock:(MJButtonBlock)block{
    if (self.rightButton == nil) {
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.customNavigationView addSubview:self.rightButton];
        MJWeakSelf(ws)
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ws.customNavigationView).offset(-10);
            make.top.mas_equalTo(ws.customNavigationView).offset(20);
            make.bottom.mas_equalTo(ws.customNavigationView);
            make.width.mas_equalTo(@44);
        }];
    }
    [self.rightButton setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
    [self.rightButton setTitle:title forState:UIControlStateNormal];
    self.rightButtonAction = block;
}
-(void)rightButtonClick:(UIButton*)btn{
    if (self.rightButtonAction != nil) {
        self.rightButtonAction(btn);
    }
}
- (void)MJHiddenNavigationBar:(BOOL)hidden{
    self.customNavigationView.hidden = hidden;
}

- (void)dealloc {
    
    MJLog(@"%@--dealloc",NSStringFromClass([self class]));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
