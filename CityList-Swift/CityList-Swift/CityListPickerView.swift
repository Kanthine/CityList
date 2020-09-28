//
//  CityListPickerView.swift
//  CityList-Swift
//
//  Created by 苏沫离 on 2020/9/28.
//

import UIKit

class CityListPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var dataArray : [CityListModel]! {
        didSet{
            pickerView.reloadAllComponents()
        }
    }
    private var selectedHandle:((_ city : CityListModel) -> Void)?
    
    ///懒加载
    lazy var coverButton : UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.frame = UIScreen.main.bounds
        button.addTarget(self, action: #selector(dismissButtonClick), for: .touchUpInside)
        return button
    }()
    
    lazy var pickerView : UIPickerView = {
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.width, height: 216))
        pickerView.showsSelectionIndicator = true
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    lazy var contentView : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 500))
        view.backgroundColor = UIColor.white
        
        view.addSubview(topView())
        view.addSubview(pickerView)

        var bottomSpace : CGFloat = 0
        if #available(iOS 11.0, *) {
            let safeAreaInsets : UIEdgeInsets = UIApplication.shared.windows.first!.safeAreaInsets
            switch UIApplication.shared.statusBarOrientation {
            case UIInterfaceOrientation.portrait:
                bottomSpace = safeAreaInsets.bottom
            case UIInterfaceOrientation.landscapeLeft:
                bottomSpace = safeAreaInsets.right
            case UIInterfaceOrientation.landscapeRight:
                bottomSpace = safeAreaInsets.left
            case UIInterfaceOrientation.portraitUpsideDown:
                bottomSpace = safeAreaInsets.top
            default:
                bottomSpace = safeAreaInsets.bottom
            }
        }
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: pickerView.frame.maxY + bottomSpace)
        return view
    }()
    
    convenience init(handle : @escaping (_ city : CityListModel) -> Void ,datas : [CityListModel] ) {
        self.init(frame: UIScreen.main.bounds)
        dataArray = datas
        selectedHandle = handle
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(coverButton)
        addSubview(contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(){
        (UIApplication.shared.delegate?.window)!!.addSubview(self)
        contentView.frame = CGRect(x: contentView.frame.origin.x, y: UIScreen.main.bounds.height, width: contentView.frame.width, height: contentView.frame.height)
        coverButton.alpha = 0
        UIView.animate(withDuration: 0.2) { [self] in
            coverButton.alpha = 1.0
            contentView.frame = CGRect(x: contentView.frame.origin.x, y: UIScreen.main.bounds.height - contentView.frame.height, width: contentView.frame.width, height: contentView.frame.height)
        }
    }
    
    // MARK: - response click
    @objc func dismissButtonClick() {
        UIView.animate(withDuration: 0.2, animations: { [self] in
            coverButton.alpha = 0
            contentView.frame = CGRect(x: contentView.frame.origin.x, y: UIScreen.main.bounds.height, width: contentView.frame.width, height: contentView.frame.height)
        }) { (finished : Bool) in
            self.removeFromSuperview()
        }
    }
            
    @objc func confirmButtonClick() {
        let provinceModel = dataArray[pickerView.selectedRow(inComponent: 0)];
        let cityModel = provinceModel.childArray[pickerView.selectedRow(inComponent: 1)]
        cityModel.parentModel = provinceModel
        let areaModel = cityModel.childArray[pickerView.selectedRow(inComponent: 2)];
        areaModel.parentModel = cityModel
        selectedHandle!(areaModel)
        dismissButtonClick()
    }
        
    //MARK:- UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3///3 列
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return dataArray.count
        }else if component == 1 {
            return dataArray[pickerView.selectedRow(inComponent: 0)].childArray.count
        }else if (component == 2){
            return self.dataArray[pickerView.selectedRow(inComponent: 0)].childArray[pickerView.selectedRow(inComponent: 1)].childArray.count;
        }
        return 0;
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return bounds.width / 3.0;
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        // 设置分割线的颜色
        for singleLine in pickerView.subviews {
            if (singleLine.frame.height < 1){
                singleLine.backgroundColor = UIColor(red: 222/255.0, green: 222/255.0, blue: 222/255.0, alpha: 1)
            }
        }
        
        var label : UILabel!
        if view == nil {
            label = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.width / 3.0, height: 35.0))
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18)
            label.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
            label.backgroundColor = UIColor.clear
        }else{
            label = view as? UILabel
        }
        
        if (component == 0){
            label.text = self.dataArray[row].regionName
        }else if (component == 1){
            label.text = dataArray[pickerView.selectedRow(inComponent: 0)].childArray[row].regionName;
        }else if (component == 2){
            label.text = self.dataArray[pickerView.selectedRow(inComponent: 0)].childArray[pickerView.selectedRow(inComponent: 1)].childArray[row].regionName;
        }
        return label;
    }

    
    // 返回选中的行
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
        }else if component == 1 {
            pickerView.reloadComponent(2)
        }
    }

    
    func topView() -> UIView {
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        topView.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 248/255.0, alpha: 1)
        topView.layer.shadowColor = UIColor(red: 225/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1).cgColor
        topView.layer.shadowOffset = CGSize(width: 1, height: 1)
        topView.layer.shadowOpacity = 1
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
        titleLabel.text = "选择城市"
        topView.addSubview(titleLabel)

        let cancelbutton = UIButton(type: .custom)
        cancelbutton.frame = CGRect(x: 0, y: 0, width: 100, height: topView.bounds.height)
        cancelbutton.backgroundColor = UIColor.clear
        cancelbutton.addTarget(self, action: #selector(dismissButtonClick), for: .touchUpInside)
        cancelbutton.setTitle("取消", for: .normal)
        cancelbutton.setTitleColor(UIColor(red: 169/255.0, green: 169/255.0, blue: 169/255.0, alpha: 1), for: .normal)
        cancelbutton.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        cancelbutton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        cancelbutton.contentHorizontalAlignment = .left
        topView.addSubview(cancelbutton)

        let confirmButton = UIButton(type: .custom)
        confirmButton.frame = CGRect(x: topView.bounds.width - 100, y: 0, width: 100, height: topView.bounds.height)
        confirmButton.backgroundColor = UIColor.clear
        confirmButton.addTarget(self, action: #selector(confirmButtonClick), for: .touchUpInside)
        confirmButton.setTitle("完成", for: .normal)
        confirmButton.setTitleColor(UIColor(red: 255/255.0, green: 122/255.0, blue: 151/255.0, alpha: 1), for: .normal)
        confirmButton.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        confirmButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
        confirmButton.contentHorizontalAlignment = .right
        topView.addSubview(confirmButton)
        
        return topView
    }
}
