//
//  CityListPickerView.m
//  CityList
//
//  Created by 苏沫离 on 2018/6/27.
//

#import "CityListPickerView.h"

@interface CityListPickerView ()
<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic ,strong) UIButton *coverButton;
@property (nonatomic ,strong) UIView *contentView;
@property (nonatomic ,strong) UIPickerView *pickerView;

@end

@implementation CityListPickerView

- (instancetype)initWithData:(NSMutableArray<CityListModel *> *)dataArray{
    self = [super init];
    if (self){
        self.dataArray = dataArray;
        self.frame = UIScreen.mainScreen.bounds;
        [self addSubview:self.coverButton];
        [self addSubview:self.contentView];
    }
    return self;
}

#pragma mark - public method

+ (void)showWithData:(NSMutableArray<CityListModel *> *)dataArray Handle:(void(^)(CityListModel *city))selectedHandle{
    CityListPickerView *view = [[CityListPickerView alloc] initWithData:dataArray];
    view.selectedHandle = selectedHandle;
    [view show];
}

- (void)show{
    [UIApplication.sharedApplication.delegate.window addSubview:self];
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, CGRectGetHeight(UIScreen.mainScreen.bounds), CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
    self.coverButton.alpha = 0;
    [UIView animateWithDuration:0.20 animations:^{
        self.coverButton.alpha = 1.0;
        CGFloat height = CGRectGetHeight(self.contentView.frame);
        self.contentView.frame = CGRectMake(0, CGRectGetHeight(UIScreen.mainScreen.bounds) - height, CGRectGetWidth(self.contentView.frame), height);
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - response click

- (void)confirmButtonClick{
    [self dismissButtonClick];
    if (self.selectedHandle) {
        CityListModel *provinceModel = self.dataArray[[self.pickerView selectedRowInComponent:0]];
        CityListModel *cityModel = provinceModel.childArray[[self.pickerView selectedRowInComponent:1]];
        CityListModel *areaModel = cityModel.childArray[[self.pickerView selectedRowInComponent:2]];
        self.selectedHandle(areaModel);
    }
}

- (void)dismissButtonClick{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.coverButton.alpha = 0;
        weakSelf.contentView.frame = CGRectMake(weakSelf.contentView.frame.origin.x, CGRectGetHeight(UIScreen.mainScreen.bounds), CGRectGetWidth(weakSelf.contentView.frame), CGRectGetHeight(weakSelf.contentView.frame));
    } completion:^(BOOL finished) {
        [weakSelf.coverButton removeFromSuperview];
        weakSelf.coverButton = nil;
        [weakSelf.contentView removeFromSuperview];
        weakSelf.contentView = nil;
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;///3 列
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0){
        return self.dataArray.count;
    }else if (component == 1){
        return self.dataArray[[pickerView selectedRowInComponent:0]].childArray.count;
    }else if (component == 2){
        return self.dataArray[[pickerView selectedRowInComponent:0]].childArray[[pickerView selectedRowInComponent:1]].childArray.count;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return CGRectGetWidth(self.bounds) / 3.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 36.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    // 设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews){
        if (singleLine.frame.size.height < 1){
            singleLine.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
        }
    }

    
    UILabel *label = (UILabel *)view;
    if(label == nil){
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds) / 3.0, 35.0)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        label.backgroundColor = [UIColor clearColor];
    }
    
    if (component == 0){
        label.text = self.dataArray[row].regionName;
    }else if (component == 1){
        label.text = self.dataArray[[pickerView selectedRowInComponent:0]].childArray[row].regionName;
    }else if (component == 2){
        label.text = self.dataArray[[pickerView selectedRowInComponent:0]].childArray[[pickerView selectedRowInComponent:1]].childArray[row].regionName;
    }
    return label;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(component == 0){
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
    }else if (component == 1){
        [pickerView reloadComponent:2];
    }
}



#pragma mark - getter and setter

- (void)setDataArray:(NSMutableArray<CityListModel *> *)dataArray{
    _dataArray = dataArray;
    [self.pickerView reloadAllComponents];
}

- (UIButton *)coverButton{
    if (_coverButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [button addTarget:self action:@selector(dismissButtonClick) forControlEvents:UIControlEventTouchUpInside];
        button.frame = UIScreen.mainScreen.bounds;
        _coverButton = button;
    }
    return _coverButton;
}

- (UIView *)topView{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 44)];
    topView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:248/255.0 alpha:1];
    topView.layer.shadowColor = [UIColor colorWithRed:225/255.0 green:224/255.0 blue:224/255.0 alpha:1].CGColor;
    topView.layer.shadowOffset = CGSizeMake(0,1);
    topView.layer.shadowOpacity = 1;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    titleLabel.text = @"选择城市";
    [topView addSubview:titleLabel];
    
    
    UIButton *cancelbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelbutton.frame = CGRectMake(0, 0,100,CGRectGetHeight(topView.frame));
    cancelbutton.backgroundColor = [UIColor clearColor];
    cancelbutton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelbutton addTarget:self action:@selector(dismissButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
    cancelbutton.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    cancelbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cancelbutton setTitleColor:[UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1] forState:UIControlStateNormal];
    [topView addSubview:cancelbutton];

    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(CGRectGetWidth(topView.frame) - 100 ,0,100,CGRectGetHeight(topView.frame));
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    confirmButton.backgroundColor = [UIColor clearColor];
    confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setTitle:@"完成" forState:UIControlStateNormal];
    confirmButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
    [confirmButton setTitleColor:[UIColor colorWithRed:255/255.0 green:122/255.0 blue:151/255.0 alpha:1] forState:UIControlStateNormal];
    [topView addSubview:confirmButton];
    
    return topView;
    
}

- (UIPickerView *)pickerView{
    if (_pickerView == nil){
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(UIScreen.mainScreen.bounds), 216)];
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (UIView *)contentView{
    if (_contentView == nil) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 50 + 600)];
        view.backgroundColor = UIColor.whiteColor;
        
        [view addSubview:self.topView];
        [view addSubview:self.pickerView];

        if (@available(iOS 11.0, *)) {
            UIEdgeInsets safeAreaInsets = UIApplication.sharedApplication.windows.firstObject.safeAreaInsets;
            
            CGFloat bottomSpace = 0;
            switch (UIApplication.sharedApplication.statusBarOrientation) {
                case UIInterfaceOrientationPortrait:{
                    bottomSpace = safeAreaInsets.bottom;
                }break;
                case UIInterfaceOrientationLandscapeLeft:{
                    bottomSpace = safeAreaInsets.right;
                }break;
                case UIInterfaceOrientationLandscapeRight:{
                    bottomSpace = safeAreaInsets.left;
                } break;
                case UIInterfaceOrientationPortraitUpsideDown:{
                    bottomSpace = safeAreaInsets.top;
                }break;
                default:
                    bottomSpace = safeAreaInsets.bottom;
                    break;
            }
            view.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetMaxY(self.pickerView.frame) + bottomSpace);
        } else {
            view.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetMaxY(self.pickerView.frame));
        }
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = view.bounds;
        maskLayer.path = maskPath.CGPath;
        view.layer.mask = maskLayer;
        _contentView = view;
    }
    return _contentView;
}

@end
