//
//  MJMainViewController.m
//  MJAccount
//
//  Created by YXCZ on 17/8/7.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "MJMainViewController.h"
#import "MJGroupSingleController.h"
#import "MJGroupManagerController.h"

@interface MJMainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView * myTableView;
@property(strong,nonatomic)NSMutableArray * groupArr;
@end

@implementation MJMainViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNaviBar];
    [self myTableView];
}

-(void)loadData{
    NSArray * arr = [MJSqliteTool MJSelectAllGroupsFromTable:MJSqliteGroupTableName];
    if (self.groupArr.count > 0) {
        [self.groupArr removeAllObjects];
    }
    [self.groupArr addObjectsFromArray:arr];
    [self.myTableView reloadData];
}

-(void)setupNaviBar{
    [self MJSetNavigationTitle:@"分组列表"];
    
    MJWeakSelf(ws)
    [self MJSetRightButtonWithTitle:nil selectedImage:@"groupManager" normalImage:@"groupManager" actionBlock:^(UIButton *button) {
        
        MJGroupManagerController * manger =[[MJGroupManagerController alloc]init];
        manger.hidesBottomBarWhenPushed = YES;
        [ws.navigationController pushViewController:manger animated:YES];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groupArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"CellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.textColor = MJColorGray;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    MJGroupModel * model = [self.groupArr objectAtIndex:indexPath.row];
    cell.textLabel.text = model.groupName;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MJGroupSingleController * single = [[MJGroupSingleController alloc]init];
    single.groupModel = [self.groupArr objectAtIndex:indexPath.row];
    single.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:single animated:single];
}

- (NSMutableArray *)groupArr {
    if (_groupArr == nil) {
        _groupArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _groupArr;
}
-(UITableView*)myTableView{
    if (_myTableView == nil) {
        UITableView * table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        table.rowHeight = 60;
        table.tableFooterView = [UIView new];
        [self.view addSubview:table];
        _myTableView = table;
        
        MJWeakSelf(ws)
        [table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ws.view).offset(MJNavigationHeight);
            make.left.right.and.mas_equalTo(ws.view);
            make.bottom.mas_equalTo(ws.view).offset(MJTabBarHeight);
        }];
    }
    return _myTableView;
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
