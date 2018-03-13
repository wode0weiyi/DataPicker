//
//  TQDatePickerView.swift
//  DatePicker
//
//  Created by apple-2 on 2017/12/25.
//  Copyright © 2017年 胡志辉. All rights reserved.


import UIKit

fileprivate let kSCREEN_WIDTH = UIScreen.main.bounds.size.width


fileprivate let mycommonEdge:CGFloat = 13//lable上下左右编剧
//常用字体大小
fileprivate let mylableSize = 15//设置常用字体大小为16

enum DatePickerStyle {
    case KDatePickerDate    //年月日
    case KDatePickerTime    //年月日时分
    case KDatePickerSecond  //秒
}

class TQDatePickerView: UIView {
    
    var canButtonReturnB: (() -> Void)? //取消按钮的回调
    
    var sucessReturnB: ((_ date:String) -> Void)?//选择的回调
    
    fileprivate var datePickerStyle:DatePickerStyle!
    
    fileprivate var unitFlags:Set<Calendar.Component>!
    
    fileprivate lazy var title:UILabel = {
        let title = UILabel()
        title.text = "选择时间"
        title.textColor = UIColor.gray
        return title
    }()
    
    fileprivate lazy var cancelButton:UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.titleLabel?.textColor = UIColor.gray
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(14))
        return cancelButton
    }()
    
    fileprivate lazy var confirmButton:UIButton = {
        let confirmButton = UIButton()
        confirmButton.setTitle("确定", for: .normal)
        confirmButton.titleLabel?.textColor = UIColor.gray
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(14))
        return confirmButton
    }()
    
    fileprivate var bottomView = UIView()
    
    fileprivate var pickerView = UIPickerView()
    
    fileprivate var lineView = UIView()//一条横线
    
    fileprivate var returnString:String  {
        get{
            let selectedMonthFormat = String(format:"%.2d",selectedMonth)
            
            let selectedDayFormat = String(format:"%.2d",selectedDay)
            
            let selectedHourFormat = String(format:"%.2d",selectedHour)
            
            let selectedMinuteFormat = String(format:"%.2d",selectedMinute)
            
            let selectedSecondFormat = String(format:"%.2d",selectedSecond)
            
            
            switch datePickerStyle {
            case .KDatePickerDate:
                return "\(selectedYear)-\(selectedMonthFormat)-\(selectedDayFormat) "
            case .KDatePickerTime:
                return "\(selectedYear)-\(selectedMonthFormat)-\(selectedDayFormat) \(selectedHourFormat):\(selectedMinuteFormat)"
            case .KDatePickerSecond:
                return "\(selectedYear)-\(selectedMonthFormat)-\(selectedDayFormat) \(selectedHourFormat):\(selectedMinuteFormat):\(selectedSecondFormat)"
            default:
                return "\(selectedYear)-\(selectedMonthFormat)-\(selectedDayFormat) \(selectedHourFormat):\(selectedMinuteFormat)"
            }
        }
    } //返回的时间字符串
    
    //数据相关
    fileprivate var yearRange = 30 + 1000//年的范围
    
    fileprivate var dayRange = 0 //
    
    fileprivate var startYear = 0
    
    fileprivate var selectedYear = 0;
    fileprivate var selectedMonth = 0;
    fileprivate var selectedDay = 0;
    fileprivate var selectedHour = 0;
    fileprivate var selectedMinute = 0;
    fileprivate var selectedSecond = 0;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setUpViews()
    }
    
    convenience init(type:DatePickerStyle) {
        self.init(frame: CGRect.zero)
        
        self.setUpViews()
        self.initDatePickerWithType(type: type)
    }
    
    convenience init() {
        self.init(type: .KDatePickerDate)
    }
    
    fileprivate func setUpViews(){
        
        self.backgroundColor = UIColor.init(white: 0.5, alpha: 0.5)
        
        self.addBottomView()
        self.addtitle()
        self.addcancelButton()
        self.addlineView()
        self.addconfirmButton()
        self.addPickerView()
        self.addTapGestureTo(view: self)
    }
    
    //MARK:底部白色背景区域
    fileprivate func addBottomView(){
        self.addSubview(bottomView)
        self.bottomViewP()
        self.bottomViewF()
    }
    
    fileprivate func bottomViewP(){
        bottomView.backgroundColor = UIColor.white
    }
    
    fileprivate func bottomViewF(){
        bottomView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self)
            make.height.equalTo(250)
        }
    }
    
    //MARK:设置标题
    fileprivate func addtitle(){
        
        self.bottomView.addSubview(title)
        
        self.titleP()
        self.titleF()
    }
    
    fileprivate func titleP(){
        title.textColor = UIColor.gray
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: CGFloat(14))
    }
    
    fileprivate func titleF(){
        title.snp.makeConstraints { (make) in
            make.top.equalTo(self.bottomView.snp.top).offset(mycommonEdge)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    
    fileprivate func titleD(title:String){
        self.title.text = title
    }
    
    //MARK:设置取消按钮
    fileprivate func addcancelButton(){
        self.bottomView.addSubview(cancelButton)
        self.cancelP()
        self.cancelF()
    }
    
    fileprivate func cancelP(){
        
        self.cancelButton.setTitleColor(UIColor.gray, for: .normal)
        self.cancelButton.tag = 101
        self.cancelButton.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
    }
    
    fileprivate func cancelF(){
        
        self.cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.bottomView.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.size.equalTo(CGSize(width: 90, height: 45))
        }
    }
    
    //MARK:设置确定按钮
    fileprivate func addconfirmButton(){
        self.bottomView.addSubview(confirmButton)
        self.confirmButtonP()
        self.confirmButtonF()
    }
    
    fileprivate func confirmButtonP(){
        
        self.confirmButton.setTitleColor(UIColor.gray, for: .normal)
        self.confirmButton.tag = 102
        self.confirmButton.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        
    }
    
    fileprivate func confirmButtonF(){
        
        self.confirmButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.bottomView.snp.top)
            make.trailing.equalTo(self.snp.trailing)
            make.height.equalTo(45)
            make.width.equalTo(90)
        }
    }
    
    //MARK:按钮的点击
    @objc
    fileprivate func buttonClick(_ sender:UIButton) {
//        debugPrint("======取消按钮被点击=====")
        
        switch sender.tag {
        case 101:
            //取消
            self.dismiss()
        case 102:
            //确定
            if self.sucessReturnB != nil {
                
                self.sucessReturnB!(self.returnString)
                self.dismiss()
            }
        default:
            break
        }
    }
    
    //MARK:设置横线
    fileprivate func addlineView(){
        
        self.addSubview(lineView)
        
        self.lineViewP()
        self.lineViewF()
    }
    
    fileprivate func lineViewP(){
        
        self.lineView.backgroundColor = UIColor.gray
    }
    
    fileprivate func lineViewF(){
        
        self.lineView.snp.makeConstraints { (make) in
            
            make.top.equalTo(self.cancelButton.snp.bottom)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(1)
        }
    }
    
    //MARK:设置空白处背景点击事件
    var tapGestureBlock:((_ tag: Int) -> ())?
    
    fileprivate func addTapGestureTo(view: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc fileprivate func tapGesture(_ sender: UIGestureRecognizer) {
        self.dismiss()
    }
    
    //设置日历
    fileprivate func addPickerView()  {
        
        self.bottomView.addSubview(self.pickerView)
        
        self.setPickerP()
        self.setPickerF()
    }
    
    fileprivate func setPickerP()  {
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
    }
    
    fileprivate func setPickerF()  {
        
        pickerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.lineView.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.bottomView)
        }
    }
    
    //MARK:计算每个月有多少天
    
    fileprivate func isAllDay(year:Int, month:Int) -> Int {
        
        var   day:Int = 0
        switch(month)
        {
        case 1,3,5,7,8,10,12:
            day = 31
        case 4,6,9,11:
            day = 30
        case 2:
            
            if(((year%4==0)&&(year%100==0))||(year%400==0))
            {
                day=29
            }
            else
            {
                day=28;
            }
            
        default:
            break;
        }
        return day;
    }
}

//MARK: 展示与隐藏逻辑
extension TQDatePickerView {
    func show() {
        let window: UIWindow? = (UIApplication.shared.delegate?.window)!
        if window != nil {
            window?.addSubview(self)
            self.snp.makeConstraints({ (make) in
                make.edges.equalTo(window!)
            })
        }
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
}

//MARK:初始化数据
extension TQDatePickerView {
    
    fileprivate func initDatePickerWithType(type: DatePickerStyle)  {
        
        datePickerStyle = type
        let  calendar0 = Calendar.init(identifier: .gregorian)//公历
        
        var comps = DateComponents()//一个封装了具体年月日、时秒分、周、季度等的类
        
        unitFlags = [.year , .month , .day ]
        
        switch  datePickerStyle{
        case .KDatePickerDate:
            break
        case .KDatePickerTime:
            unitFlags = [.year , .month , .day , .hour , .minute ]
        case .KDatePickerSecond:
            unitFlags = [.year , .month , .day , .hour , .minute ,.second]
        default:
            break
        }
        
        comps = calendar0.dateComponents(unitFlags, from: Date())
        
        startYear = comps.year! - 100
        
        dayRange = self.isAllDay(year: startYear, month: 1)
        
        yearRange = 30 + 1000;
        selectedYear = comps.year!;
        selectedMonth = comps.month!;
        selectedDay = comps.day!;
        
        self.pickerView.selectRow(selectedYear - startYear, inComponent: 0, animated: true)
        self.pickerView.selectRow(selectedMonth - 1, inComponent: 1, animated: true)
        self.pickerView.selectRow(selectedDay - 1, inComponent: 2, animated: true)
        
        switch  datePickerStyle{
        case .KDatePickerDate:
            break
        case .KDatePickerTime:
            selectedHour = comps.hour!;
            selectedMinute = comps.minute!;
            
            self.pickerView.selectRow(selectedHour , inComponent: 3, animated: true)
            self.pickerView.selectRow(selectedMinute , inComponent: 4, animated: true)
        case .KDatePickerSecond:
            selectedHour = comps.hour!;
            selectedMinute = comps.minute!;
            selectedSecond = comps.second!;
            self.pickerView.selectRow(selectedHour , inComponent: 3, animated: true)
            self.pickerView.selectRow(selectedMinute , inComponent: 4, animated: true)
            self.pickerView.selectRow(selectedSecond, inComponent: 5, animated: true)
        default:
            break
        }
        self.pickerView.reloadAllComponents()
    }
}

//MARK:UIPickerViewDataSource, UIPickerViewDelegate

extension  TQDatePickerView:UIPickerViewDelegate,UIPickerViewDataSource{
    
    //返回UIPickerView当前的列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return unitFlags == nil ? 0 : unitFlags.count
    }
    
    //确定每一列返回的东西
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch component {
        case 0:
            return yearRange
        case 1:
            return 12
        case 2:
            return dayRange
        case 3:
            return 24
        case 4:
            return 60
        case 5:
            return 60
        default:
            return 0
        }
    }
    
    //返回一个视图，用来设置pickerView的每行显示的内容。
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        
        let label  = UILabel(frame: CGRect(x: kSCREEN_WIDTH * CGFloat(component) / 6 , y: 0, width: kSCREEN_WIDTH/6, height: 30))
        
        label.font = UIFont.systemFont(ofSize: CGFloat(14))
        
        label.tag = component*100+row
        
        label.textAlignment = .center
        
        switch component {
        case 0:
            
            label.frame=CGRect(x:5, y:0,width:kSCREEN_WIDTH/4.0, height:30);
            
            
            label.text="\(self.startYear + row)年";
            
        case 1:
            
            label.frame=CGRect(x:kSCREEN_WIDTH/4.0, y:0,width:kSCREEN_WIDTH/8.0, height:30);
            
            
            label.text="\(row + 1)月";
        case 2:
            
            label.frame=CGRect(x:kSCREEN_WIDTH*3/8, y:0,width:kSCREEN_WIDTH/8.0, height:30);
            
            
            label.text="\(row + 1)日";
        case 3:
            
            label.textAlignment = .right
            
            label.text="\(row )时";
        case 4:
            
            label.textAlignment = .right
            
            label.text="\(row )分";
        case 5:
            
            label.textAlignment = .right
            
            label.frame=CGRect(x:kSCREEN_WIDTH/6, y:0,width:kSCREEN_WIDTH/6.0 - 5, height:30);
            
            
            label.text="\(row )秒";
            
        default:
            label.text="\(row )秒";
        }
        
        return label
    }
    
    //当点击UIPickerView的某一列中某一行的时候，就会调用这个方法
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.selectedYear = self.startYear + row
            
            self.dayRange = self.isAllDay(year: self.startYear, month: self.selectedMonth)
            
            self.pickerView.reloadComponent(2)
        case 1:
            self.selectedMonth =  row + 1
            
            self.dayRange = self.isAllDay(year: self.startYear, month: self.selectedMonth)
            
            self.pickerView.reloadComponent(2)
        case 2:
            selectedDay = row + 1
        case 3:
            selectedHour = row
        case 4:
            selectedMinute = row
        case 5:
            selectedSecond = row
        default:
            selectedSecond = row
        }
    }
}

