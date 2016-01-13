//
//  tableViewCell.swift
//  CustomWeather
//
//  Created by 蓦然回首love on 16/1/5.
//  Copyright © 2016年 SSF. All rights reserved.
//

import Foundation
extension UITableViewCell {
    func sendTheNotificationWhenClicked(city:String,object:AnyObject) {
      NSNotificationCenter.defaultCenter().postNotificationName("kChooceTheCity", object: object, userInfo: ["city":city])
    }
}