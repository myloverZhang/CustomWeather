//
//  CWCityDailyWeather.swift
//  CustomWeather
//
//  Created by hzxsdz0045 on 16/1/4.
//  Copyright © 2016年 蓦然回首love. All rights reserved.
//

import UIKit

class CWCityDailyWeather: NSObject {
    var date = NSString()
    var astro = [String: AnyObject]()
    var cond =  [String: AnyObject]()
    var hum : NSNumber
    var pcpn : NSNumber
    var pop : NSNumber
    var pres : NSNumber
    var tmp = [String: AnyObject]()
    var vis : NSNumber
    var wind = [String: AnyObject]()
    override init() {
        hum = 0
        pcpn = 0
        pop = 0
        pres = 0
        vis = 0
    }
    func showInformation() {
     print("\(self.date),\(self.astro),\(self).cond),\(self.cond),\(self.hum),\(self.pcpn),\(self.pop),\(self.pres),\(self.tmp),\(self.vis),\(self.wind)\n\n")
    }
}
