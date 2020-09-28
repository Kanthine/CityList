//
//  CityListModel.m
//
//  Created by 沫离 苏 on 2018/6/27
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "CityListModel.h"

NSString *const kCityListModelParentId = @"parent_id";
NSString *const kCityListModelAgencyId = @"agency_id";
NSString *const kCityListModelRegionId = @"region_id";
NSString *const kCityListModelRegionType = @"region_type";
NSString *const kCityListModelChildArray = @"childArray";
NSString *const kCityListModelRegionName = @"region_name";


@interface CityListModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CityListModel

@synthesize parentId = _parentId;
@synthesize agencyId = _agencyId;
@synthesize regionId = _regionId;
@synthesize regionType = _regionType;
@synthesize childArray = _childArray;
@synthesize regionName = _regionName;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.isFold = YES;
            self.parentId = [self objectOrNilForKey:kCityListModelParentId fromDictionary:dict];
            self.agencyId = [self objectOrNilForKey:kCityListModelAgencyId fromDictionary:dict];
            self.regionId = [self objectOrNilForKey:kCityListModelRegionId fromDictionary:dict];
            self.regionType = [self objectOrNilForKey:kCityListModelRegionType fromDictionary:dict];
    NSObject *receivedChildArray = [dict objectForKey:kCityListModelChildArray];
    NSMutableArray *parsedChildArray = [NSMutableArray array];
    if ([receivedChildArray isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedChildArray) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                CityListModel *model = [CityListModel modelObjectWithDictionary:item];
                model.parentModel = self;
                [parsedChildArray addObject:model];
            }
       }
    } else if ([receivedChildArray isKindOfClass:[NSDictionary class]]) {
        CityListModel *model = [CityListModel modelObjectWithDictionary:(NSDictionary *)receivedChildArray];
        model.parentModel = self;
       [parsedChildArray addObject:model];
    }

    self.childArray = [NSArray arrayWithArray:parsedChildArray];
            self.regionName = [self objectOrNilForKey:kCityListModelRegionName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.parentId forKey:kCityListModelParentId];
    [mutableDict setValue:self.agencyId forKey:kCityListModelAgencyId];
    [mutableDict setValue:self.regionId forKey:kCityListModelRegionId];
    [mutableDict setValue:self.regionType forKey:kCityListModelRegionType];
    NSMutableArray *tempArrayForChildArray = [NSMutableArray array];
    for (NSObject *subArrayObject in self.childArray) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForChildArray addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForChildArray addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForChildArray] forKey:kCityListModelChildArray];
    [mutableDict setValue:self.regionName forKey:kCityListModelRegionName];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.parentId = [aDecoder decodeObjectForKey:kCityListModelParentId];
    self.agencyId = [aDecoder decodeObjectForKey:kCityListModelAgencyId];
    self.regionId = [aDecoder decodeObjectForKey:kCityListModelRegionId];
    self.regionType = [aDecoder decodeObjectForKey:kCityListModelRegionType];
    self.childArray = [aDecoder decodeObjectForKey:kCityListModelChildArray];
    self.regionName = [aDecoder decodeObjectForKey:kCityListModelRegionName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_parentId forKey:kCityListModelParentId];
    [aCoder encodeObject:_agencyId forKey:kCityListModelAgencyId];
    [aCoder encodeObject:_regionId forKey:kCityListModelRegionId];
    [aCoder encodeObject:_regionType forKey:kCityListModelRegionType];
    [aCoder encodeObject:_childArray forKey:kCityListModelChildArray];
    [aCoder encodeObject:_regionName forKey:kCityListModelRegionName];
}

- (id)copyWithZone:(NSZone *)zone
{
    CityListModel *copy = [[CityListModel alloc] init];
    
    if (copy) {

        copy.parentId = [self.parentId copyWithZone:zone];
        copy.agencyId = [self.agencyId copyWithZone:zone];
        copy.regionId = [self.regionId copyWithZone:zone];
        copy.regionType = [self.regionType copyWithZone:zone];
        copy.childArray = [self.childArray copyWithZone:zone];
        copy.regionName = [self.regionName copyWithZone:zone];
    }
    
    return copy;
}


@end





//数据加载
@implementation CityListModel (DataLoad)

//加载本地的城市列表
+ (NSArray<NSDictionary *> *)loadLocalCityListData{
    NSString *filePath = [NSBundle.mainBundle pathForResource:@"CityModelList" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray<NSDictionary *> *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return array;
}

+ (NSMutableArray<CityListModel *> *)getCityListModel{
    NSArray<NSDictionary *> *localData = [CityListModel loadLocalCityListData];
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:localData.count];
    [localData enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CityListModel *model = [CityListModel modelObjectWithDictionary:obj];
        [resultArray addObject:model];
    }];
    return resultArray;
}

+ (void)asyncGetCityListModel:(void (^)(NSMutableArray<CityListModel *> *modelArray))block{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *resultArray = [CityListModel getCityListModel];
        dispatch_async(dispatch_get_main_queue(), ^{
           block(resultArray);
        });
    });
}

@end
