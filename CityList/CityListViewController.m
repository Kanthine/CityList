//
//  CityListViewController.m
//  CityList
//
//  Created by 苏沫离 on 2020/9/27.
//
#define CellIdentifer @"CityListTableCell"
#define HeaderIdentifer @"UITableViewHeaderFooterView"


#import "CityListViewController.h"
#import "CityListModel.h"
#import "CityListView.h"

@interface CityListViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) NSMutableArray<CityListModel *> *rawDataArray;
@property (nonatomic ,strong) NSMutableArray<CityListModel *> *dataArray;
@property (nonatomic ,strong) UITableView *tableView;

@end

@implementation CityListViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.tableView];
    
    [self loadNetWorkRequest];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CityListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CityListModel *model = self.dataArray[indexPath.row];
    if (model.childArray.count) {
        model.isFold = !model.isFold;
        [self setShowData];
    }else{
        
        CityListTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        NSIndexPath *selectedIndexPath = tableView.indexPathForSelectedRow;
//        if (selectedIndexPath &&
//            selectedIndexPath.row != indexPath.row) {
//            [tableView cellForRowAtIndexPath:selectedIndexPath].selected = NO;
//            cell.selected = YES;
//        }else{
//            cell.selected = NO;
//        }
    }
    
//    if (self.selectedCity) {
//        if ([getLocalizedLanguageType() isEqualToString:LocalizedLanguageZhHant]) {
//            self.selectedCity(model.zhHant);
//        }else if ([getLocalizedLanguageType() isEqualToString:LocalizedLanguageZhHans]){
//            self.selectedCity(model.zhHans);
//        }else if ([getLocalizedLanguageType() isEqualToString:LocalizedLanguageEnglish]){
//            self.selectedCity(model.english);
//        }
//        [self.searchView.searchBar resignFirstResponder];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

#pragma mark - private methods

///设置展示的数据
- (void)setShowData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.dataArray removeAllObjects];
        [self.rawDataArray enumerateObjectsUsingBlock:^(CityListModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.dataArray addObject:model];
            [self recursiveEnumerate:model];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (void)recursiveEnumerate:(CityListModel *)model{
    if (!model.isFold && model.childArray.count) {
        [model.childArray enumerateObjectsUsingBlock:^(CityListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.dataArray addObject:obj];
            [self recursiveEnumerate:obj];
        }];
    }
}

- (void)loadNetWorkRequest{
    [CityListModel asyncGetCityListModel:^(NSMutableArray<CityListModel *> *modelArray) {
        self.rawDataArray = modelArray;
        [self setShowData];
    }];
}

#pragma mark - setter and getters

- (NSMutableArray<CityListModel *> *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if (_tableView == nil){
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableFooterView = UIView.new;
        tableView.separatorColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.rowHeight = 48;
        tableView.sectionFooterHeight = 0.1f;
        [tableView registerClass:CityListTableCell.class forCellReuseIdentifier:CellIdentifer];
        [tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:HeaderIdentifer];
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.sectionIndexColor = UIColor.blackColor;//设置默认时索引值颜色
        tableView.allowsSelection = YES;
        _tableView = tableView;
    }
    return _tableView;
}

@end
