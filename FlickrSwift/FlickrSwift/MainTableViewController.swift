//
//  MainTableViewController.swift
//  FlickrSwift
//
//  Created by Akhand Pratap Singh on 19/04/15.
//  Copyright (c) 2015 Akhand Pratap Singh. All rights reserved.
//

import UIKit


class MainTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, DataMangerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var images : NSMutableArray = []
    let opQueue = NSOperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()

        // make a network call fetch the imagges
//        for (var index: Int = 0; index<10; index++){
//            var anImage = Image(name: "Test \(index)", url: nil)
//            images.addObject(anImage)
//            
//        }
        
        
        tableView.registerNib(UINib(nibName: "MainTableViewCell", bundle: nil) , forCellReuseIdentifier: "MainTableViewCell")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- table view data source and delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.images.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:MainTableViewCell = tableView.dequeueReusableCellWithIdentifier("MainTableViewCell", forIndexPath: indexPath) as MainTableViewCell
        cell.activityIndicator.stopAnimating()
        let entry = self.images.objectAtIndex(indexPath.row) as Image
        cell.nameLabel?.text = entry.title
        cell.flickrImageView.image = entry.flickrImage
        if (!entry.isInProgress){
            entry.isInProgress = true
            cell.activityIndicator.startAnimating()
            let url = NSURL(string: entry.imageUrlStr!)
            let urlRequest =  NSURLRequest(URL: url!)
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: self.opQueue, completionHandler: { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
                let image = UIImage(data: data)
                cell.flickrImageView.image = image
                cell.activityIndicator.stopAnimating()
                entry.isInProgress = false
                entry.flickrImage = image
            })
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
   
    
    //MARK:- search bar delegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let searchStr = searchBar.text {
            //search
           self.search(searchStr)
        }else{
            let alert = UIAlertView(title: "Error", message: "Enter a search string.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        searchBar.resignFirstResponder()
    }

    
    //MARK:- search string
    func search(searchStr: String){
         let dm = DataManager.sharedInstance
        dm.dataManagerDelegate = self
        dm.searchFlicker(searchStr)
    }
    
    
    //MARK:- data manager call back
    func dataManagerdidFinishedSearchFor(searchKey: String, with photos: NSArray?, withSuccess status: Bool) {
        self.images = NSMutableArray(array: photos!)
        
        tableView.reloadData()
        
    }
     func test() {
        println("call back from data manager for test")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
