//
//  CWSearchTableViewController.swift
//  CustomWeather
//
//  Created by hzxsdz0045 on 16/1/5.
//  Copyright © 2016年 SSF. All rights reserved.
//

import UIKit
protocol CWSearchTableViewControllerDelegate {
    
    func backTheRootViewController()-> Void
}
class CWSearchTableViewController: UITableViewController {
    var allCities = [AnyObject]()
    var delegate:CWSearchTableViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return allCities.count
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
         if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        }
        let cityname = allCities[indexPath.row] as! String
       
        cell!.textLabel!.text = cityname

        return cell!
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell!.sendTheNotificationWhenClicked(cell!.textLabel!.text!, object: self)
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let VC = storyBoard.instantiateViewControllerWithIdentifier("MainViewController")
          self.dismissViewControllerAnimated(true) { () -> Void in
            self.delegate!.backTheRootViewController()
        }
        
    }
}
