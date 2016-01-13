//
//  CWMainViewController.swift
//  CustomWeather
//
//  Created by 蓦然回首love on 16/1/4.
//  Copyright © 2016年 蓦然回首love. All rights reserved.
//

import UIKit

class CWMainViewController: UIViewController,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate{
    var allDaysWeathers = [String: [CWCityDailyWeather]]()//每天的天气
    var allHoursWeathers = [String:[CWCityHourlyWeather]]()//每个小时的天气
    var suggestions = [String: CWSuggestion]()//建议
    var nowWeathers = [String:CWNowWeatherOfTheCity]()
    var localService = BMKLocationService()
    var allSelectedCities = [String]()//所有的选择了的城市
    var aCity =  String()//现在的城市
    var index = 0
    var changeButtonView: CWNaviView?
    var pageControl: UIPageControl?
    @IBOutlet weak var nowWeatherSituation: CWNowWeatherView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var suggestionScrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        suggestionScrollView.delegate = self
        changeButtonView =  CWNaviView.setTheBarItem("changeTheSelectedCity:", object: self)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: changeButtonView!)
//       backImageView.setImageToBlur(UIImage(named: "3473706f261a741a13358ee56163f104"), blurRadius: 2, completionBlock: nil)
        backImageView.alpha = 1
        localService.delegate = self
        localService.startUserLocationService()
        self.tabBarController?.hidesBottomBarWhenPushed = true
        collectionView.registerNib(UINib(nibName: "HourlyWeatherCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "item")
       self.tabBarController?.tabBar.opaque = true
        //注册一个接受选中城市的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "chooseACity:", name: "kChooceTheCity", object: nil)
       NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "updateTheScrollView", userInfo: nil, repeats: true)
        //设置一个pagecontroll吧
        setPageControll()
        // Do any additional setup after loading the view.
    }
   //MRRK:定时器方法
    func updateTheScrollView() {
       let contentOffset = suggestionScrollView.contentOffset
        let x = (contentOffset.x + 210)%770
        let y = contentOffset.y
        var count = pageControl!.currentPage
        count++
        if count == 7 {
         count == 0
        }
        suggestionScrollView.contentOffset = CGPointMake(x, y)
        pageControl!.currentPage++
    }
     func changeTheSelectedCity(sender: UIButton) {
        if allSelectedCities.count == 0 {  return }
        index++
        if index == allSelectedCities.count { index = 0 }
        self.navigationItem.title = allSelectedCities[index]
        aCity = allSelectedCities[index] + "市"
        aCity = getTheJSONCity(aCity)
        setInterFace()
    }
    func setPageControll() {
       pageControl = UIPageControl()
       pageControl!.numberOfPages = 7
       pageControl!.userInteractionEnabled = false
       view.addSubview(pageControl!)
       pageControl?.snp_makeConstraints(closure: { (make) -> Void in
        make.centerX.equalTo(0)
        make.bottom.equalTo(suggestionScrollView.snp_bottom)
       })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:
    //选中城市
    func chooseACity(notification:NSNotification) {
      var city = notification.userInfo!["city"] as! String
        self.navigationItem.title  = city
        allSelectedCities.append(city)
        city = city + "市"
        
       let string = getTheJSONCity(city)
        getTheJSONData(string)
    }
    //MARK:BMKLocationServiceDelegate
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        print("\(userLocation.location.coordinate.latitude),\(userLocation.location.coordinate.longitude)")
        reverseTheGeo(userLocation.location)
        localService.stopUserLocationService()
    }
    func didFailToLocateUserWithError(error: NSError!) {
        let hud = MBProgressHUD.showHUDAddedTo(self.navigationController!.view, animated: true)
        hud.mode = .Text
        hud.labelText = "由于网络原因，请手动选择城市"
        hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        hud.hide(true, afterDelay: 1)
    
    }
    //定位成功之后通过反编码获取地理信息
    func reverseTheGeo(location:CLLocation){
     let geoCoder = BMKGeoCodeSearch()
    geoCoder.delegate = self
        let option = BMKReverseGeoCodeOption()
        option.reverseGeoPoint = location.coordinate
        if geoCoder.reverseGeoCode(option) {
         print("反地理编码成功")
        }
    }
    //MARK:BMKGeoCodeSearchDelegate协议
    func onGetReverseGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if error == BMK_SEARCH_NO_ERROR {
         print("检索结果正常返回")

            let geoInfo = result.poiList.last
            if let geo = geoInfo as! BMKPoiInfo? {
                
                self.navigationItem.title = geo.city
                let string = getTheJSONCity(geo.city)
              
                getTheJSONData(string)
            }
        }
    }
    func getTheJSONCity(city:String) ->String {
        if city == "成都市" {
        return "chengdu"
        }
        let index = city.endIndex.advancedBy(-1)
        
        let c = city.substringToIndex(index)
       
        let str = NSMutableString(string: c) as CFMutableString
        var cityString : String = ""
        if CFStringTransform(str, nil, kCFStringTransformToLatin, false) {
            if CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false){
                let string: String = str as String
               
                var aString = String()
                for  cha in string.characters {
                    
                    if  cha != " " {
                     aString.append(cha)
                    }
                  
                }
//                print("\(aString)")
               cityString = aString
            }
        }
        print("\(cityString)")
        return cityString
    }//获取拼音
    //MARK:获取json数据 并解析
    func getTheJSONData(city: String) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let manager = AFHTTPSessionManager()
        var parameters = [String: String]()
        parameters["city"] = city
        aCity = city
        print("\(aCity)")
        let urlString = "http://apis.baidu.com/heweather/pro/weather"
        manager.requestSerializer.setValue("eee60690fce7fcea3c11328ba09f01d7", forHTTPHeaderField: "apikey")
        
        manager.GET(urlString, parameters: parameters, success: { (task:NSURLSessionDataTask?, response: AnyObject?) -> Void in
             UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            print("\(response)")
            let array = CWManager.parseTHeDailyWeaher(response!)
            self.allDaysWeathers[city] = array
            self.allHoursWeathers[city] = CWManager.parseTheHourlyWeather(response!)
            self.suggestions[city] = CWManager.parseTheSuggestion(response!)
            self.nowWeathers[city] = CWManager.parseTheNowWeather(response!)
//            NSNotificationCenter.defaultCenter().postNotificationName("kAllDailyWeatherArray", object: self, userInfo: ["allWeatherArray":CWManager.parseTHeDailyWeaher(response!),"city":city])
            let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appdelegate.allDaysWeather.append([city:array])
            self.setInterFace()
            }, failure: { (tasK:NSURLSessionDataTask?, error:NSError?)-> Void
                in
                   UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                print("\(error!.userInfo)")
        })
        
    }
    //MARK:重写segue 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if  segue.identifier == "ToChooceVC" {
          let VC = segue.destinationViewController as! CWChooseCityTableViewController
           VC.allCitiesGroups = CWManager.parseTheCityGrous()
        }
    }
    func setInterFace(){
        var string = "\(self.navigationItem.title!)" + "市";
        string = getTheJSONCity(string)
        self.nowWeatherSituation.nowWeatherSituations = self.nowWeathers[aCity]!
        setTheScrollView()
        collectionView.reloadData()
    }
    //MARK:集合视图的协议
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if navigationItem.title == nil {
        return 0
        }
        var string = "\(self.navigationItem.title!)" + "市";
        string = getTheJSONCity(string)
        return self.allHoursWeathers[aCity]!.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCellWithReuseIdentifier("item", forIndexPath: indexPath)
        let item1 = item as! HourlyWeatherCollectionViewCell
        var string = "\(self.navigationItem.title!)" + "市";
        string = getTheJSONCity(string)
        let allHourWeather = allHoursWeathers[aCity]
        item1.hourWeather = allHourWeather![indexPath.row]
        return item1
    }
    //MARK:设置滚动视图的内容
    func  setTheScrollView() {
        let views = suggestionScrollView.subviews
        for vs in views {
         vs.removeFromSuperview()
        }
       
        
        if suggestions[aCity] == nil {
        return
        }
        let theCitySuggestion = suggestions[aCity]!
        var dic = [String: [String:AnyObject]]()
        dic["舒适度指数"] = theCitySuggestion.comf
        dic["洗车指数"] = theCitySuggestion.cw
        dic["穿衣指数"] = theCitySuggestion.drsg
        dic["感冒指数"] = theCitySuggestion.flu
        dic["运动指数"] = theCitySuggestion.sport
        dic["旅游指数"] = theCitySuggestion.trav
        dic["紫外线指数"] = theCitySuggestion.uv
       var countNumber = 0
        var lastView = UIView()
        for aDic in dic {
          let theView = setTheSuggestionView(aDic.0, sug: aDic.1)
          suggestionScrollView.addSubview(theView)
            theView.snp_makeConstraints(closure: { (make) -> Void in
                if countNumber == 0 {
                 make.left.equalTo(10)
                make.top.bottom.equalTo(0)
                    make.width.equalTo(200)
                }else{
                  make.left.equalTo(lastView.snp_right).offset(10)
                    make.top.bottom.equalTo(0)
                    make.size.equalTo(lastView)
                    if countNumber == 6 {
                     make.right.equalTo(-10)
                    }
                }
                
            })
            lastView = theView
            countNumber++
        }
    }
    func setTheSuggestionView (tit:String, sug: [String:AnyObject]) -> UIView {
        let theView = UIView()
       let title = UILabel()
        title.text = tit + ":"
        theView.addSubview(title)
        title.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(5)
            make.top.equalTo(10)
            make.width.equalTo(90)
            make.height.equalTo(20)
        }
        let secondTitle = UILabel()
        secondTitle.text = sug["brf"] as? String
        theView.addSubview(secondTitle)
        secondTitle.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(10)
            make.left.equalTo(title.snp_right).offset(0)
            make.right.equalTo(-10)
            make.height.equalTo(20)
        }
        let contentLabel = UILabel()
        contentLabel.text = sug["txt"] as? String
        contentLabel.lineBreakMode = .ByTruncatingTail
        contentLabel.numberOfLines = 0
        theView.addSubview(contentLabel)
        contentLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(35)
            make.left.equalTo(10)
            make.right.bottom.equalTo(-10)
        }
        return theView
    }
    //MARK:UIScrollViewDelegate协议
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("\(scrollView.contentOffset)")
        let x = scrollView.contentOffset.x
        let n = (x - 10)/210
        print("\(n)")
        pageControl!.currentPage = (n as NSNumber).integerValue
        
    }
}
