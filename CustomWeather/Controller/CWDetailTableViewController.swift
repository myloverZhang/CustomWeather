//
//  CWDetailTableViewController.swift
//  CustomWeather
//
//  Created by 蓦然回首love on 16/1/4.
//  Copyright © 2016年 蓦然回首love. All rights reserved.
//

import UIKit

class CWDetailTableViewController: UITableViewController {
    var allDaiyWeather = [[String:[CWCityDailyWeather]]]() //数组
    var index = 0
    @IBOutlet weak var faewf: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getTheWeather:", name: "kAllDailyWeatherArray", object: nil)
       
        tableView.bounces = false
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: "swipeLeft")
        leftSwipe.direction  = .Left
        self.view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: "swipeRight")
        rightSwipe.direction = .Right
        self.view.addGestureRecognizer(rightSwipe)
        
        tableView.registerNib(UINib(nibName: "CWDailyWeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        let shareButton = UIBarButtonItem(title: "分享", style: .Done, target: self, action: "shareWeather:")
        navigationItem.rightBarButtonItem = shareButton
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        index = 0
         let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
         allDaiyWeather = appdelegate.allDaysWeather
         tableView.reloadData()
    }
    func shareWeather(sender:UIBarButtonItem) {
        print("分享")
            SSEShareHelper.screenCaptureShare({ (var image:SSDKImage!, sharedHandler:SSEShareHandler!) -> Void in
                if image == nil {
                    image = SSDKImage(image: UIImage(named: "Dennis Ritchie"), format: SSDKImageFormatJpeg, settings: nil)
                    
                }
                let sharedParams = NSMutableDictionary()
                sharedParams.SSDKSetupShareParamsByText("我只是在测试一个东西", images: [image], url: nil, title: nil, type: .Image)
                if sharedHandler != nil {
                    sharedHandler(SSDKPlatformType.TypeSinaWeibo,sharedParams)
                }
                } ,onStateChanged: { (state:SSDKResponseState, userData:[NSObject: AnyObject]!, contentEntity:SSDKContentEntity!, error:NSError!) -> Void in
                    switch state {
                    case .Success:
                        let alertViewController = UIAlertController(title: "分享成功", message: "", preferredStyle: .Alert)
                        let action =  UIAlertAction(title: "返回", style: .Cancel, handler: nil)
                        alertViewController.addAction(action)
                        self.presentViewController(alertViewController, animated: true, completion: nil)
                        
                    case .Fail:
                        print("分享失败")
                    default:
                        break
                    }
            })
        
        
    }
    func swipeLeft() {
         index++
        if   index == allDaiyWeather.count {
         index = 0
        }
         tableView.reloadData()
         let animation = CATransition()
        animation.duration = 1
        animation.type = "cube"
        animation.subtype = kCATransitionFromRight
        self.tableView.layer.addAnimation(animation, forKey: "animation")
    }//左滑
    func swipeRight() {
        index--
        if index < 0 {
        index = allDaiyWeather.count - 1
        }
        tableView.reloadData()
        let animation = CATransition()
        animation.duration = 1
        animation.type = "cube"
        animation.subtype = kCATransitionFromLeft
        self.tableView.layer.addAnimation(animation, forKey: "animation1")
    }//右滑
    func getTheWeather(notifiaction:NSNotification) {
        
        let city = notifiaction.userInfo!["city"] as! String
        let weathers = notifiaction.userInfo!["allWeatherArray"] as! [CWCityDailyWeather]
        let aCityAllWether = [city: weathers]
        allDaiyWeather.append(aCityAllWether)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if   allDaiyWeather.count == 0{
        return 0
        }
        else {
            let all = allDaiyWeather[index]//一个字典类型
            let alla = all.values.first!
            navigationItem.title = all.keys.first
            return alla.count
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let c = cell as! CWDailyWeatherTableViewCell
        let ACityDailyWeather =  allDaiyWeather[index]
        let values = ACityDailyWeather.values.first
        let imageView = UIImageView(image: UIImage(named: "cell1"))
        c.backgroundView = imageView
       c.dailyWeather = values![indexPath.row]
       return cell
        
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
   

}
