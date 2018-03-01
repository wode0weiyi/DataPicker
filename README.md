# DataPicker
# 示例图片

 1.年月日
 
 ![Image text](https://raw.githubusercontent.com/wode0weiyi/Image_Folder/master/时间选择器年月日.png)
 
 
 2.年月日时分
 
 ![Image text](https://raw.githubusercontent.com/wode0weiyi/Image_Folder/master/时间选择器时分.png)
 
 3.年月日时分秒
 
 ![Image text](https://raw.githubusercontent.com/wode0weiyi/Image_Folder/master/时间选择器时分秒.png)


# 使用方法（注意：如果项目中有snpkit，则可以把本项目中的snpkit删除掉）

 
 @IBAction func chooseTimeBtnClick(_ sender: UIButton) {
        
        //创建时间选择器。
       
       let pickView = TQDatePickerView(type: .KDatePickerSecond)
       
       pickView.sucessReturnB = {[weak self] (date: String) in
           
           self?.timeLabel.text = date
        
        }
       
       pickView.show()
    
    }
    
    
 不理解的或者有什么问题欢迎咨询
