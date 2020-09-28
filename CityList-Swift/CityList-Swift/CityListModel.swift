//
//  CityListModel.swift
//  CityList-Swift
//
//  Created by 苏沫离 on 2020/9/28.
//

import UIKit

class CityListModel: NSObject, NSCoding, NSCopying {
    
    var agencyId : String!
    var parentId : String!
    var regionId : String!
    var regionName : String!
    var regionType : String!
    var childArray : [CityListModel]!

    
    ///是否折叠：默认为 YES
    var isFold : Bool!

    ///是否选中
    var isSelected : Bool!

    weak var parentModel : CityListModel!


    init(fromDictionary dictionary: [String:Any]){
        isFold = true
        isSelected = false
        agencyId = dictionary["agency_id"] as? String
        parentId = dictionary["parent_id"] as? String
        regionId = dictionary["region_id"] as? String
        regionName = dictionary["region_name"] as? String
        regionType = dictionary["region_type"] as? String
        childArray = [CityListModel]()
        if let childArrayArray = dictionary["childArray"] as? [[String:Any]]{
            for dic in childArrayArray{
                let value = CityListModel(fromDictionary: dic)
//                value.parentModel = self
                childArray.append(value)
            }
        }
    }

    func dictionaryRepresentation() -> [String:Any]{
        var dictionary = [String:Any]()
        if agencyId != nil{
            dictionary["agency_id"] = agencyId
        }
        if parentId != nil{
            dictionary["parent_id"] = parentId
        }
        if regionId != nil{
            dictionary["region_id"] = regionId
        }
        if regionName != nil{
            dictionary["region_name"] = regionName
        }
        if regionType != nil{
            dictionary["region_type"] = regionType
        }
        if childArray != nil{
            var dictionaryElements = [[String:Any]]()
            for childArrayElement in childArray {
                dictionaryElements.append(childArrayElement.dictionaryRepresentation())
            }
            dictionary["childArray"] = dictionaryElements
        }
        return dictionary
    }
    
    override var description: String{
        return "\(dictionaryRepresentation())"
    }

    @objc required init(coder aDecoder: NSCoder){
         agencyId = aDecoder.decodeObject(forKey: "agency_id") as? String
         parentId = aDecoder.decodeObject(forKey: "parent_id") as? String
         regionId = aDecoder.decodeObject(forKey: "region_id") as? String
         regionName = aDecoder.decodeObject(forKey: "region_name") as? String
         regionType = aDecoder.decodeObject(forKey: "region_type") as? String
         childArray = aDecoder.decodeObject(forKey :"childArray") as? [CityListModel]
    }

    @objc func encode(with aCoder: NSCoder){
        if agencyId != nil{
            aCoder.encode(agencyId, forKey: "agency_id")
        }
        if parentId != nil{
            aCoder.encode(parentId, forKey: "parent_id")
        }
        if regionId != nil{
            aCoder.encode(regionId, forKey: "region_id")
        }
        if regionName != nil{
            aCoder.encode(regionName, forKey: "region_name")
        }
        if regionType != nil{
            aCoder.encode(regionType, forKey: "region_type")
        }
        if childArray != nil{
            aCoder.encode(childArray, forKey: "childArray")
        }
    }

    func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy() as! CityListModel
        copy.parentId = self.parentId
        copy.agencyId = self.agencyId
        copy.regionId = self.regionId
        copy.regionType = self.regionType
        copy.childArray = self.childArray
        copy.regionName = self.regionName
        return copy
    }
    
}




///分类里面不能存储属性，只能通过关联属性来达到目的
extension CityListModel{
    
    //加载本地的城市列表
    class func loadLocalCityListData() -> [NSDictionary] {
        let filePath : String = Bundle.main.path(forResource: "CityModelList", ofType: "json")!
        let data = NSData(contentsOfFile: filePath)
        do {
            let array : [NSDictionary] = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as! [NSDictionary]
            return array
        } catch {
           return [NSDictionary]()
        }
    }
    
    
    class func getCityListModel() -> [CityListModel] {
        let localData : [NSDictionary] = loadLocalCityListData()
        var resultArray = [CityListModel]()
        for item in localData {
            let model = CityListModel(fromDictionary: item as! [String : Any])
            resultArray.append(model)
        }
        return resultArray
    }
    
    /// @escaping 逃逸闭包
    class func asyncGetCityListModel(dataBlock: @escaping (_ array: [CityListModel]) -> Void ) {
        DispatchQueue.global().async {
            let resultArray = getCityListModel()
            DispatchQueue.main.async {
                dataBlock(resultArray)
            }
        }
    }

    
}





