//
//  CWNaviView.swift
//  CustomWeather
//
//  Created by 蓦然回首love on 16/1/7.
//  Copyright © 2016年 SSF. All rights reserved.
//

import UIKit

class CWNaviView: UIView {
    class func setTheBarItem(sel:Selector,object: AnyObject)->CWNaviView {
        
        let nview = CWNaviView()
        nview.bounds = CGRectMake(0, 0, 80, 40)
        let button = UIButton(type: .Custom)
        button.setTitle("切换城市", forState: .Normal)
        nview.addSubview(button)
        button.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(0)
        }
        button.addTarget(object, action: sel, forControlEvents: .TouchUpInside)
    return nview
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
