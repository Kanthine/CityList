//
//  CityListTableCell.h
//  CityList
//
//  Created by 苏沫离 on 2018/6/27.
//

#import <UIKit/UIKit.h>
#import "CityListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CityListTableCell : UITableViewCell
@property (nonatomic ,strong) CityListModel *model;
@end

NS_ASSUME_NONNULL_END
