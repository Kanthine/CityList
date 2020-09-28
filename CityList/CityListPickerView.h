//
//  CityListPickerView.h
//  CityList
//
//  Created by 苏沫离 on 2018/6/27.
//

#import <UIKit/UIKit.h>
#import "CityListModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface CityListPickerView : UIView
@property (nonatomic ,strong) NSMutableArray<CityListModel *> *dataArray;
@property (nonatomic ,copy) void(^selectedHandle)(CityListModel *city);
+ (void)showWithData:(NSMutableArray<CityListModel *> *)dataArray Handle:(void(^)(CityListModel *city))selectedHandle;
@end


NS_ASSUME_NONNULL_END
