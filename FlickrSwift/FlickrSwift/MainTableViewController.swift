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
    var images : [Image] = []
    var observedImages: [Image] = []
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
        let entry = self.images[indexPath.row]
        entry.currentIndexpath = indexPath
        cell.nameLabel?.text = "\(entry.currentIndexpath!.row)"//entry.title
        cell.flickrImageView.image = entry.flickrImage
        cell.activityIndicator.stopAnimating()
        
        if (cell.progressview == nil){
            cell.progressview = ASCircularProgressView(frame: CGRectMake(cell.flickrImageView.center.x-20, cell.flickrImageView.center.y-20, 40, 40))
            cell.addSubview(cell.progressview)
        }
        if (entry.progress == 1){
            cell.progressview?.removeFromSuperview()
        }
        cell.progressLbl.text = "\(entry.progress*100)"
        cell.progressview?.showProgress(Int (entry.progress*100))

        if(entry.currentNetworkStatus != .Completed && entry.currentNetworkStatus != .InProgress){
            entry.addObserver(self, forKeyPath: "progress", options: .New, context: nil)
            cell.activityIndicator.startAnimating()
            entry.startImageDownload()
        }
        
        
//        if (!entry.isInProgress && (entry.flickrImage == nil)){
//            var label = UILabel()
//                        cell.progressview.showProgress(Int (entry.progress*100))
//            
//            //cell.progressview.frame =
//            //cell.progressview!.percent = 50
//            
//            entry.isInProgress = true
//            
//        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    //MARK:- observe images (scroll view delegate)

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        println("end dragging now start observing")
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        println("end decelertaing  now start observing")
        //clear previous observed cells
        
        for anEntry:Image in self.observedImages {
            self.removeObserver(anEntry, forKeyPath: "progress")
        }
        self.observedImages.removeAll(keepCapacity: false)
//        for aPath:NSIndexPath in self.tableView.indexPathsForVisibleRows() as [NSIndexPath]{
//            let anImg : Image = self.images[aPath.row]
//            
//            if (anImg.isInProgress && anImg.flickrImage == nil){
//                
//            }
//            
//        }
    }
    
//    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
//        
//    }
   
    
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
        self.images = photos! as NSArray as [Image]
        
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
    
    //MARK : - KVO
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if object.isKindOfClass(Image){
            if keyPath == "progress"{
                
                let currentImage: Image = object as Image
                let currentIndexpath = currentImage.currentIndexpath
                if (currentIndexpath != nil){
                    println("progress changed\(currentImage.currentIndexpath!.row): \(change[NSKeyValueChangeNewKey])")
                    let cell:MainTableViewCell? = self.tableView.cellForRowAtIndexPath(currentIndexpath!) as? MainTableViewCell
                    if ((cell) != nil) {
                        
                       
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                                cell!.progressLbl.text = "\(currentImage.progress*100)"
//                                cell!.progressview.showProgress(Int (currentImage.progress*100))
//                                 if (Int(currentImage.progress*100)>=100){
//                                cell!.flickrImageView.image = UIImage(data: currentImage.downloadedData)
//                                cell!.activityIndicator.stopAnimating()
                                self.tableView.reloadRowsAtIndexPaths([currentIndexpath!], withRowAnimation: .None)
                               // }
                                //UITableViewRowAnimation
                                //self.tableView.reloadRowsAtIndexPaths([currentIndexpath!], withRowAnimation: .None)
                            })
                        
                    }
                    
                }
                
            }
        }
    }

}
