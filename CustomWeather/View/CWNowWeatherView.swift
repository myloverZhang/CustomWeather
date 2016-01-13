//
//  CWNowWeatherView.swift
//  CustomWeather
//
//  Created by hzxsdz0045 on 16/1/6.
//  Copyright © 2016年 SSF. All rights reserved.
//

import UIKit

class CWNowWeatherView: UIView {
    var tmp : Float = 0.0
    var txt: String = "晴"//天气状况
    var hum : Float = 0.0 //相对湿度
    var dir: String = "北风"//风向
    var vis: Int = 10//能见度
    var nowWeatherSituations: CWNowWeatherOfTheCity {
        set(myValue){
            tmp = myValue.tmp
            txt = myValue.cond["txt"]!
            hum = myValue.hum
            dir = myValue.wind["dir"]!
            vis = myValue.vis
           setNeedsDisplay()
        } get{
            let cw = CWNowWeatherOfTheCity()
            return cw;
         }
    }
        override func drawRect(rect: CGRect) {
            for view in subviews {
             view.removeFromSuperview()
            }
            print("...")
//            self.backgroundColor  = UIColor.orangeColor()
        self.frame  = CGRectMake(20, 70, 160, 200)
        let tmpLabel = UILabel()
            tmpLabel.text = "\(tmp)" + "°"
            tmpLabel.font = UIFont.systemFontOfSize(40)
            tmpLabel.textAlignment = .Center
            self.addSubview(tmpLabel)
            tmpLabel.snp_makeConstraints { (make) -> Void in
                make.left.top.equalTo(20)
                make.right.equalTo(-20)
                make.height.equalTo(100)
            }
            let image = UIImage(named: "\(txt)")
            let imageView = UIImageView(image: image)
//            imageView.backgroundColor = UIColor.orangeColor()
            self.addSubview(imageView)
            imageView.snp_makeConstraints { (make) -> Void in
                make.left.equalTo(20)
                make.top.equalTo(tmpLabel.snp_bottom).offset(5)
                make.width.equalTo(30)
                make.height.equalTo(30)
                
            }
            
            let condTxt = UILabel()
            condTxt.text = "\(txt)"
            condTxt.font = UIFont.systemFontOfSize(20)
            condTxt.textAlignment  = .Left
            self.addSubview(condTxt)
            condTxt.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(tmpLabel.snp_bottom).offset(5)
                make.left.equalTo(imageView.snp_right).offset(5)
                make.right.equalTo(-20)
                make.height.equalTo(30)
            }
            let humLabel = UILabel()
            humLabel.text = "\(hum)"
            humLabel.textAlignment = .Left
            self.addSubview(humLabel)
            humLabel.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(condTxt.snp_bottom).offset(7)
                make.left.equalTo(20)
                make.height.equalTo(20)
            }
            
            let winDLabel = UILabel()
            winDLabel.text = "\(dir)"
            winDLabel.textAlignment = .Left
            self.addSubview(winDLabel)
            winDLabel.snp_makeConstraints { (make) -> Void in
                make.left.equalTo(humLabel.snp_right).offset(5)
                make.top.equalTo(condTxt.snp_bottom).offset(7)
                make.right.equalTo(-20)
                make.size.equalTo(humLabel)
            }
     }
 

}
