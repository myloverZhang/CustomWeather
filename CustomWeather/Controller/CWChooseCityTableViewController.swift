//
//  CWChooseCityTableViewController.swift
//  CustomWeather
//
//  Created by hzxsdz0045 on 16/1/5.
//  Copyright © 2016年 SSF. All rights reserved.
//

import UIKit

class CWChooseCityTableViewController: UITableViewController,UISearchResultsUpdating,UISearchBarDelegate,CWSearchTableViewControllerDelegate {
    var allCitiesGroups = [AnyObject]()
    let reuseIdentifier = "cityCell"
    let resultVC = CWSearchTableViewController()
    var searchResult = [AnyObject]()
    var searchBarController: UISearchController?
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResult = allCitiesGroups
        resultVC.delegate = self
        searchBarController = UISearchController(searchResultsController: resultVC)
        searchBarController!.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchBarController!.searchBar
        searchBarController!.searchResultsUpdater = self
        definesPresentationContext = true
        searchBarController!.searchBar.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return allCitiesGroups.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let theSection = allCitiesGroups[section] as! CWCityGroups
        return theSection.cities!.count
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        let theCityGroups = allCitiesGroups[indexPath.section] as! CWCityGroups
        cell.textLabel?.text = theCityGroups.cities![indexPath.row] as? String
        return cell
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let c = allCitiesGroups[section] as! CWCityGroups
        return c.title as? String
    }
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        var allTitles = [String]()
        for  city in allCitiesGroups {
          let c = city as! CWCityGroups
         allTitles.append(c.title as! String)
            
    }
        return allTitles
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell!.sendTheNotificationWhenClicked(cell!.textLabel!.text!, object: self)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    //MARK:UISearchResultsUpdating协议
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let inputText = searchController.searchBar.text
        var resultArray = [String]()
        for cityGroups in allCitiesGroups {
            let cities = cityGroups as! CWCityGroups
            if cities.title as! String != "热门" {
            for city in cities.cities as! [String]{
                if city.componentsSeparatedByString(inputText!).count > 1 {
                    resultArray.append(city)
                 
                }
                
                }
            }
        }
       
        resultVC.allCities = resultArray
        resultVC.tableView.reloadData()

        
    }
    //MARK:UISearchBarDelegate协议

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        updateSearchResultsForSearchController(searchBarController!)
    }
    //MARK:CWSearchTableViewControllerDelegate 
    func backTheRootViewController() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
