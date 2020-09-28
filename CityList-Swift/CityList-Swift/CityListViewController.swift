//
//  CityListViewController.swift
//  CityList-Swift
//
//  Created by 苏沫离 on 2020/9/28.
//

import UIKit

class CityListViewController: UIViewController, UITableViewDelegate ,UITableViewDataSource {

    var selectedCity : CityListModel!
    var rawDataArray : [CityListModel]!
    var dataArray = [CityListModel]()
    var tableView : UITableView!


    //MARK:- life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        navigationItem.title = "省市区列表"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "CityPicker", style: .plain, target: self, action: #selector(rightBarButtonItemClick))

        tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor(red: 221/255.0, green: 221/255.0, blue: 221/255.0, alpha: 1)
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = 48
        tableView.sectionFooterHeight = 0.1
        tableView.register(CityListTableCell.self, forCellReuseIdentifier: "cell")
        tableView.sectionIndexColor = UIColor.black
        view.addSubview(tableView)
        
        loadNetWorkRequest()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
    }

    @objc func rightBarButtonItemClick() {
        let pickerView = CityListPickerView(handle: { (city : CityListModel) in
            print("PickerView : \(city.parentModel.parentModel.regionName) - \(city.parentModel.regionName) - \(city.regionName)")
        }, datas: rawDataArray)
        pickerView.show()
    }
    
    //MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CityListTableCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CityListTableCell
        cell.model = dataArray[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArray[indexPath.row]
        if model.childArray.count > 0 {
            model.isFold = !model.isFold
            setShowData()
        }else{
            let cell : CityListTableCell = tableView.cellForRow(at: indexPath) as! CityListTableCell
            if (selectedCity != nil) {
                selectedCity.isSelected = false
                if self.selectedCity != model  {
                    if dataArray.contains(selectedCity) {
                        let oldIndexPath : NSIndexPath = NSIndexPath(row: Int(dataArray.firstIndex(of: selectedCity)!), section: 0)
                        let oldCell : CityListTableCell? = tableView.cellForRow(at:oldIndexPath as IndexPath) as? CityListTableCell
                        oldCell?.model = model
                    }
                    selectedCity = model
                    model.isSelected = true
                }
            }else{
                model.isSelected = true
                selectedCity = model
            }
            cell.model = model
        }
    }
    
    //MARK:- private methods
    ///设置展示的数据
    func setShowData() {
    
        DispatchQueue.global().async { [self] in
            dataArray.removeAll()
            for model in rawDataArray {
                dataArray.append(model)
                recursiveEnumerate(model: model)
            }
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
    }
    
    func recursiveEnumerate(model : CityListModel){
        if !model.isFold && model.childArray.count > 0 {
            for obj in model.childArray {
                dataArray.append(obj)
                recursiveEnumerate(model: obj)
            }
        }
    }
    
    func loadNetWorkRequest() {
        CityListModel.asyncGetCityListModel { [self] (modelArray : [CityListModel]) in
            rawDataArray = modelArray
            setShowData()
        }
    }
}
