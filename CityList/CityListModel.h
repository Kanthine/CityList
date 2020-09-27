//
//  CityListModel.h
//
//  Created by 沫离 苏 on 2020/9/27
//  Copyright (c) 2020 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CityListModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *parentId;
@property (nonatomic, strong) NSString *agencyId;
@property (nonatomic, strong) NSString *regionId;
@property (nonatomic, strong) NSString *regionType;
@property (nonatomic, strong) NSString *regionName;
@property (nonatomic, strong) NSArray<CityListModel *> *childArray;
///是否折叠：默认为 YES
@property (nonatomic, assign) BOOL isFold;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end


//数据加载
@interface CityListModel (DataLoad)

//加载本地的美国城市列表
+ (NSArray<NSDictionary *> *)loadLocalCityListData;

//获取城市列表model
+ (NSMutableArray<CityListModel *> *)getCityListModel;
+ (void)asyncGetCityListModel:(void (^)(NSMutableArray<CityListModel *> *modelArray))block;


@end
