//
//  CWDailyWeatherTableViewCell.swift
//  CustomWeather
//
//  Created by hzxsdz0045 on 16/1/8.
//  Copyright © 2016年 SSF. All rights reserved.
//

import UIKit

class CWDailyWeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var tmpLabel: UILabel!
    @IBOutlet weak var condLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var dailyWeather : CWCityDailyWeather {
        set{
            dateLabel.text = newValue.date as String
            dateLabel.textColor = UIColor.whiteColor()
            let string = newValue.cond["txt_d"] as! String
            if string.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 7 {
             weatherImageView.image = UIImage(named: "weather-mist")
            }else{
            weatherImageView.image = UIImage(named: "\(string)")
            }
            tmpLabel.text = "\(newValue.tmp["min"]!)°"+"/\(newValue.tmp["max"]!)°"
            tmpLabel.textColor = UIColor.whiteColor()
            condLabel.text = "\(newValue.cond["txt_d"]!)"
            condLabel.textColor = UIColor.whiteColor()
            windLabel.text = "\(newValue.wind["dir"]!)"
            windLabel.textColor = UIColor.whiteColor()
            
        }
        get{
         let tmp = CWCityDailyWeather()
            return tmp
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
