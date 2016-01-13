//
//  CWNowWeatherOfTheCity.swift
//  CustomWeather
//
//  Created by hzxsdz0045 on 16/1/4.
//  Copyright © 2016年 蓦然回首love. All rights reserved.
//

import UIKit

class CWNowWeatherOfTheCity: NSObject {
    var cond = [String: String]()
    var fl: NSNumber//体感温度
    var hum : Float//相对湿度
    var pcpn : Float//降水量
    var pres : NSNumber//气压
    var tmp : Float//温度
    var vis: Int //能见度
    var wind = [String: String]()
    override init() {
        fl = 0
        hum = 0.0
       pcpn = 0.0
       pres = 0
    tmp = 0.0
     vis = 0
    }
    
}
