//
//  MJResultViewController.m
//  MJAccount
//
//  Created by YXCZ on 17/8/10.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "MJResultViewController.h"
#import "ChineseToPinyin.h"

@interface MJResultViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation MJResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.text = @"未匹配到结果";
    label.font = [UIFont systemFontOfSize:14];
    label.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    self.tableView.tableFooterView = label;
    
    [self loadData];
}
-(void)loadData{
    NSArray * array = [MJSqliteTool MJSelectAllElementsFromTable:MJSqliteDataTableName];
    if (self.datas.count > 0) {
        [self.datas removeAllObjects];
    }
    [self.datas addObjectsFromArray:array];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    //修改"Cancle"退出字眼,这样修改,按钮一开始就直接出现,而不是搜索的时候再出现
    searchController.searchBar.showsCancelButton = YES;
    for(id sousuo in [searchController.searchBar subviews]) {
        for (id view in [sousuo subviews]) {
            if([view isKindOfClass:[UIButton class]]){
                UIButton *btn = (UIButton *)view;
                [btn setTitle:@"取消" forState:UIControlStateNormal];
//                [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }
    }
    
    NSString *result = searchController.searchBar.text;
    if (self.results.count>0) {
        [self.results removeAllObjects];
    }
    for (MJDataModel * model in self.datas) {
        NSString * pinyin = [ChineseToPinyin pinyinFromChiniseString:model.title];
        if ([[pinyin lowercaseString]rangeOfString:[result lowercaseString]].location != NSNotFound) {
            [self.results addObject:model];
        }
    }
    UILabel * label = (UILabel*)self.tableView.tableFooterView;
    if (self.results.count > 0) {
        label.text = [NSString stringWithFormat:@"匹配到 %lu 个结果",self.results.count];
    }else{
        label.text = @"未匹配到结果";
    }
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.results.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"searchId"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchId"];
        cell.textLabel.textColor = MJColorGray;
        cell.textLabel.font = MJFontDefaulte;
    }
    MJDataModel * model = [self.results objectAtIndex:indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MJDataModel * model = [self.results objectAtIndex:indexPath.row];
    if (self.selectResult) {
        self.selectResult(model);
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (NSMutableArray *)results {
    if (_results == nil) {
        _results = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _results;
}

- (NSMutableArray *)datas {
    if (_datas == nil) {
        _datas = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _datas;
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(MJNavigationHeight);
            make.left.right.and.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view).offset(-MJTabBarHeight);
        }];
    }
    
    return _tableView;
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
