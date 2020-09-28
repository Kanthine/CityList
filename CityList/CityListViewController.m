//
//  CityListViewController.m
//  CityList
//
//  Created by 苏沫离 on 2018/6/27.
//
#define CellIdentifer @"CityListTableCell"


#import "CityListViewController.h"
#import "CityListModel.h"
#import "CityListTableCell.h"
#import "CityListPickerView.h"

@interface CityListViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) CityListModel *selectedCity;
@property (nonatomic ,strong) NSMutableArray<CityListModel *> *rawDataArray;
@property (nonatomic ,strong) NSMutableArray<CityListModel *> *dataArray;
@property (nonatomic ,strong) UITableView *tableView;

@end

@implementation CityListViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"省市区列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"CityPicker" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.tableView];
    
    [self loadNetWorkRequest];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)rightBarButtonItemClick{
    [CityListPickerView showWithData:self.rawDataArray Handle:^(CityListModel * _Nonnull city) {
        NSLog(@"PickerView : %@ - %@ - %@",city.parentModel.parentModel.regionName,city.parentModel.regionName,city.regionName);
    }];
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
        self.selectedCity.isSelected = NO;
        if (self.selectedCity != model) {
            if ([self.dataArray containsObject:self.selectedCity]) {
                NSInteger index = [self.dataArray indexOfObject:self.selectedCity];
                CityListTableCell *oldCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                oldCell.model = self.selectedCity;
            }
            self.selectedCity = model;
            model.isSelected = YES;
        }
        cell.model = model;
    }
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
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.sectionIndexColor = UIColor.blackColor;//设置默认时索引值颜色
        tableView.allowsSelection = YES;
        _tableView = tableView;
    }
    return _tableView;
}

@end
