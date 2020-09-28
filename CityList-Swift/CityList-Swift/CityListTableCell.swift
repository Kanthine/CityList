//
//  CityListTableCell.swift
//  CityList-Swift
//
//  Created by 苏沫离 on 2020/9/28.
//

import UIKit

class CityListTableCell: UITableViewCell {

   public var nameLable : UILabel!

    var model : CityListModel! {
        didSet{
            if model.regionType == "1" {
                self.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
                nameLable.frame = CGRect(x: 10, y: 0, width: 100, height: bounds.height)
                nameLable.textColor = UIColor.black
                backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1)
            }else if model.regionType == "2" {
                self.separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)
                backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
                nameLable.frame = CGRect(x: 50, y: 0, width: 100, height: bounds.height)
                nameLable.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
            }else if model.regionType == "3" {
                self.separatorInset = UIEdgeInsets(top: 0, left: 90, bottom: 0, right: 0)
                backgroundColor = UIColor.white
                nameLable.frame = CGRect(x: 90, y: 0, width: 100, height: bounds.height)
                nameLable.textColor = UIColor.gray
            }
            
            if model.childArray.count > 0 {
                imageView?.image = model.isFold ? UIImage(named: "list_right") : UIImage(named: "list_down")
            }else{
                imageView?.image = model.isSelected ? UIImage(named: "list_select") : UIImage(named: "list_select_no")
            }
            nameLable.text = model.regionName;
        }
    }

        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        imageView?.contentMode = .scaleAspectFit
        nameLable =  UILabel()
        nameLable.font = UIFont(name: "Helvetica-Bold", size: 15)
        contentView.addSubview(nameLable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = CGRect(x: bounds.width - 12 - 10, y: (bounds.height - 12) / 2.0, width: 12, height: 12)
    }
}


