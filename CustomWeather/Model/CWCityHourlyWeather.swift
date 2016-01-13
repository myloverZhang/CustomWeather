//
//  CWCityHourlyWeather.swift
//  CustomWeather
//
//  Created by hzxsdz0045 on 16/1/4.
//  Copyright © 2016年 蓦然回首love. All rights reserved.
//

import UIKit

class CWCityHourlyWeather: NSObject {
    var date : String//具体的时间
    var hum : NSNumber//相对湿度
    var pop : NSNumber//降水概率
    var pres: NSNumber//气压
    var tmp : NSNumber//温度
    var wind = [String: String]()
    override init() {
        date = ""
        hum = 0
        pop = 0
        pres = 0
        tmp = 0
    }
    
    
}
