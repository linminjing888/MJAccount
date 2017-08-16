//
//  MJSearchViewController.m
//  MJAccount
//
//  Created by YXCZ on 17/8/7.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "MJSearchViewController.h"
#import "MJSearchHeaderView.h"
#import "MJSortTool.h"
#import "MJDetailViewController.h"
#import "MJResultViewController.h"

@interface MJSearchViewController ()<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic, strong)UITableView *tableView;
/// 数据数组
@property (nonatomic, strong)NSMutableArray *datas;
///// 索引条数组
//@property (nonatomic, strong)NSMutableArray *indexTitles;

@property (nonatomic, strong)UISearchController *searchController;

@end

@implementation MJSearchViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNaviBar];
    [self setupSearchBar];
    [self.tableView registerClass:[MJSearchHeaderView class] forHeaderFooterViewReuseIdentifier:@"MJSearchHeaderViewID"];
}
-(void)loadData{
    NSArray * arr = [MJSqliteTool MJSelectAllElementsFromTable:MJSqliteDataTableName];
    if (self.datas.count > 0) {
        [self.datas removeAllObjects];
    }
    NSArray * sortArr = [MJSortTool sortObjcs:arr byKey:@"title" withSortType:MJSortResultTypeDoubleValues];
    [self.datas addObjectsFromArray:sortArr];
    
//    if (self.indexTitles.count > 0) {
//        [self.indexTitles removeAllObjects];
//    }
//    for (NSDictionary * dic in sortArr) {
//        [self.indexTitles addObject:[dic objectForKey:MJSortToolKey]];
//    }
    [self.tableView reloadData];
}
-(void)setupNaviBar{
    [self MJSetNavigationTitle:@"搜索"];
}
-(void)setupSearchBar{
    
    MJResultViewController * result = [[MJResultViewController alloc]init];
    UISearchController * search = [[UISearchController alloc]initWithSearchResultsController:result];
    result.selectResult = ^(MJDataModel * model){
        MJDetailViewController * detail = [[MJDetailViewController alloc]init];
        detail.model = model;
        [self.navigationController pushViewController:detail animated:YES];
        search.searchBar.text = @"";
    };
    search.searchResultsUpdater = result;
    search.searchBar.delegate = self;
    self.tableView.tableHeaderView = search.searchBar;
    // 是否添加半透明覆盖层
    search.dimsBackgroundDuringPresentation = YES;
    // 是否隐藏导航栏
    search.hidesNavigationBarDuringPresentation = YES;
    [search.searchBar setTintColor:MJColorMain];
    
    // 哪个viewcontroller显示UISearchController
    self.definesPresentationContext = YES;
    self.searchController = search;
    
}

#pragma mark tableView 代理协议
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datas.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary * dic = [self.datas objectAtIndex:section];
    NSArray * dataArr =[dic objectForKey:MJSortToolValueKey];
    return dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = MJColorGray;
        cell.textLabel.font = MJFontDefaulte;
    }
    
    NSDictionary * dic = [self.datas objectAtIndex:indexPath.section];
    NSArray * dataArr =[dic objectForKey:MJSortToolValueKey];
    MJDataModel * model = dataArr[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
//-(NSArray<NSString*>*)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    return self.indexTitles;
//}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MJSearchHeaderView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MJSearchHeaderViewID"];
    NSDictionary * dic = [self.datas objectAtIndex:section];
    NSString * title = [dic objectForKey:MJSortToolKey];
    header.titleLabel.text = title;
    return header;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = [self.datas objectAtIndex:indexPath.section];
    NSArray * dataArr =[dic objectForKey:MJSortToolValueKey];
    MJDataModel * model = dataArr[indexPath.row];
    
    MJDetailViewController * detail = [[MJDetailViewController alloc]init];
    detail.model = model;
    [self.navigationController pushViewController:detail animated:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(20);
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [self.tableView layoutIfNeeded];
    }];
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(MJNavigationHeight);
    }];
    [UIView animateWithDuration:0.7 animations:^{
        [self.tableView layoutIfNeeded];
    }];
}

#pragma mark 懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
        
//        // 索引条文字颜色
//        _tableView.sectionIndexColor = [UIColor whiteColor];
//        // 索引条未点击状态下的背景色
//        _tableView.sectionIndexBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
//        // 索引条点击状态下的背景色
//        _tableView.sectionIndexTrackingBackgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        
        MJWeakSelf(ws)
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ws.view).offset(MJNavigationHeight);
            make.left.right.and.mas_equalTo(ws.view);
            make.bottom.mas_equalTo(ws.view).offset(-MJTabBarHeight);
        }];
    }
    return _tableView;
}

//-(NSMutableArray*)indexTitles{
//    if (_indexTitles == nil) {
//        _indexTitles =[NSMutableArray arrayWithCapacity:0];
//    }
//    return _indexTitles;
//}
- (NSMutableArray *)datas {
    if (_datas == nil) {
        _datas = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _datas;
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
