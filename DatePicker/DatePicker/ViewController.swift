//
//  ViewController.swift
//  DatePicker
//
//  Created by 胡志辉 on 2018/3/1.
//  Copyright © 2018年 胡志辉. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //获取现在的时间
        let date = self.getCurrentTime()
        timeLabel.text = date
        
    }

    @IBAction func chooseTimeBtnClick(_ sender: UIButton) {
        //创建时间选择器。
        let pickView = TQDatePickerView(type: .KDatePickerSecond)
        pickView.sucessReturnB = {[weak self] (date: String) in
            self?.timeLabel.text = date
        }
        pickView.show()
    }
    
    //获取当前时间
    fileprivate func getCurrentTime()->String{
        //获取当前时间
        let now = Date()
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //当前时间转为字符串
        let timeStr = dformatter.string(from: now)
        return timeStr
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

