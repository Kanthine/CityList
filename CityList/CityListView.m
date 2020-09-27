//
//  CityListView.m
//  CityList
//
//  Created by 苏沫离 on 2020/9/27.
//

#import "CityListView.h"

@interface CityListTableCell ()

@property (nonatomic ,strong) UILabel *nameLabel;

@end

@implementation CityListTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameLabel];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(CGRectGetWidth(self.bounds) - 12 - 10, (CGRectGetHeight(self.bounds) - 12) / 2.0, 12, 12);
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    if (_model.childArray.count) {
        self.imageView.image = _model.isFold ? [UIImage imageNamed:@"list_right"] : [UIImage imageNamed:@"list_down"];
    }else{
        self.imageView.image = selected ? [UIImage imageNamed:@"list_select"] : [UIImage imageNamed:@"list_select_no"];
    }
}

- (void)setModel:(CityListModel *)model{
    _model = model;
    if ([model.regionType isEqualToString:@"1"]) {
        self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        self.nameLabel.frame = CGRectMake(10, 0, 100, CGRectGetHeight(self.bounds));
        self.nameLabel.textColor = UIColor.blackColor;
        self.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    }else if ([model.regionType isEqualToString:@"2"]) {
        self.separatorInset = UIEdgeInsetsMake(50, 10, 0, 0);
        self.nameLabel.frame = CGRectMake(50, 0, 100, CGRectGetHeight(self.bounds));
        self.nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    }else if ([model.regionType isEqualToString:@"3"]) {
        self.separatorInset = UIEdgeInsetsMake(90, 10, 0, 0);
        self.nameLabel.frame = CGRectMake(90, 0, 100, CGRectGetHeight(self.bounds));
        self.nameLabel.textColor = UIColor.grayColor;
        self.backgroundColor = UIColor.whiteColor;
    }
    
    if (model.childArray.count) {
        self.imageView.image = model.isFold ? [UIImage imageNamed:@"list_right"] : [UIImage imageNamed:@"list_down"];
    }else{
        self.imageView.image = self.isSelected ? [UIImage imageNamed:@"list_select"] : [UIImage imageNamed:@"list_select_no"];
    }
    
    self.nameLabel.text = model.regionName;
}

@end
