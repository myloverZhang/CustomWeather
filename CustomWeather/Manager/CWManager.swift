//
//  CWManager.swift
//  CustomWeather
//
//  Created by hzxsdz0045 on 16/1/4.
//  Copyright © 2016年 蓦然回首love. All rights reserved.
//

import UIKit
import Foundation
class CWManager: NSObject {
    class func parseTHeDailyWeaher(JSON:AnyObject) -> [CWCityDailyWeather] {
        var allDailyWeather = [CWCityDailyWeather]()
        let jsondata: AnyObject? = JSON.valueForKey("HeWeather data service 3.0")!.firstObject
        let daily_forecast = jsondata!.valueForKey("daily_forecast")
        let dailys = daily_forecast as! [AnyObject]
        for daily in dailys {
            let day = daily as! [String:AnyObject]
            let theDailyWeather = CWCityDailyWeather()
            theDailyWeather.setValuesForKeysWithDictionary(day)
            allDailyWeather.append(theDailyWeather)
            }
        return allDailyWeather
        }//解析每天的天气情况
    
    class func parseTheHourlyWeather(JSON:AnyObject) -> [CWCityHourlyWeather] {
        let HeWeather:AnyObject? = JSON.valueForKey("HeWeather data service 3.0")!.firstObject
        let hourly_forecast:AnyObject? = HeWeather!.valueForKey("hourly_forecast")
        let allHoursWeather = hourly_forecast as! [AnyObject]
        var allHoursParseResult = [CWCityHourlyWeather]()
        for anHourWeather in allHoursWeather {
            let theHourWeather = anHourWeather as! [String: AnyObject]
          let hour = CWCityHourlyWeather()
            hour.setValuesForKeysWithDictionary(theHourWeather)
            allHoursParseResult.append(hour)
        }
        return allHoursParseResult
    }//解析每天里面每小时的天气情况
    class func parseTheSuggestion(JSON:AnyObject) ->CWSuggestion {
        let HeWeather: AnyObject? = JSON.valueForKey("HeWeather data service 3.0")!.firstObject
        let suggesion: AnyObject? = HeWeather!.valueForKey("suggestion")
        let allSuggestions = CWSuggestion()
        let sug = suggesion as! [String: AnyObject]
        allSuggestions.setValuesForKeysWithDictionary(sug)
        return allSuggestions
    }//建议
    class func parseTheNowWeather(JSON:AnyObject) ->CWNowWeatherOfTheCity {
       let HeWeather: AnyObject? = JSON.valueForKey("HeWeather data service 3.0")!.firstObject
        let now: AnyObject? = HeWeather!.valueForKey("now")
        let nowWeather = now as! [String: AnyObject]
        let nowTimeWeatyher = CWNowWeatherOfTheCity()
        nowTimeWeatyher.setValuesForKeysWithDictionary(nowWeather)
        return nowTimeWeatyher
    }//解析现在的天气情况
    class func parseTheCityGrous()-> [CWCityGroups] {
        let cityPath = NSBundle.mainBundle().pathForResource("cityGroups", ofType: "plist")
       let allCities = NSArray(contentsOfFile: cityPath!)
        var result = [CWCityGroups]()
        for theCities in allCities! {
          let cityGroups = CWCityGroups()
            if let theCityDic = theCities as? [String: AnyObject]{
            cityGroups.title = theCityDic["title"]
            cityGroups.cities = theCityDic["cities"]
            }
            result.append(cityGroups)
        }
        return result
    }
}
     


