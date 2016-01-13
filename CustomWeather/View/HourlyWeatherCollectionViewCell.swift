//
//  HourlyWeatherCollectionViewCell.swift
//  CustomWeather
//
//  Created by hzxsdz0045 on 16/1/7.
//  Copyright © 2016年 SSF. All rights reserved.
//

import UIKit

class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tmpLabel: UILabel!
    @IBOutlet weak var popLabel: UILabel!//降水概率
    @IBOutlet weak var presLabel: UILabel!
    @IBOutlet weak var humLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    var hourWeather: CWCityHourlyWeather {
        set(myValue){
            let index = myValue.date.startIndex.advancedBy(11)
            dateLabel.text = myValue.date.substringFromIndex(index)
            tmpLabel.text = "\(myValue.tmp)°"
            popLabel.text = "\(myValue.pop)"
            presLabel.text = "\(myValue.pres)"
            humLabel.text = "\(myValue.hum)"
            print("\(myValue.wind["dir"])")
            windLabel.text  = "\(myValue.wind["dir"]!)"
            
        }get{
            let hour = CWCityHourlyWeather()
            return hour;
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
