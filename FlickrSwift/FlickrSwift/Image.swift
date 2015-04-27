//
//  Image.swift
//  FlickrSwift
//
//  Created by Akhand Pratap Singh on 19/04/15.
//  Copyright (c) 2015 Akhand Pratap Singh. All rights reserved.
//

import UIKit

enum NetworkStatus{
    case NotStarted, InProgress, Completed, Failed
}

class Image: NSObject,NSURLConnectionDelegate, NSURLConnectionDataDelegate{
    //let imageName: String
   //
    
    var imageUrlStr: NSString?
    var flickrImage: UIImage?
    var isInProgress: Bool
    var  expectedLength : Int64?
    var currentNetworkStatus : NetworkStatus
   
    
    // for KVO----------------
    dynamic var progress: Double
    
    func updateProgress(currentProgress:Double){
        progress = currentProgress
    }
    // for KVO----------------

    var downloadedData:NSMutableData = NSMutableData();
    var con : NSURLConnection?
    var session : NSURLSession?
    var currentIndexpath : NSIndexPath?
    
    //let farm: NSString
    let id:NSString
    let secret:NSString
    let server:NSString
    let title:NSString
    
    init(farm:NSString?, id:NSString?, secret:NSString?, server:NSString?, title:NSString?) {
       // self.farm = farm!
        self.id  = id!
        self.secret = secret!
        self.server = server!
        self.title = title!
        isInProgress = false
        currentNetworkStatus = .NotStarted
        progress = 0.0
    }
    
    //MARK:- start image download
    
    func startImageDownload(){
        currentNetworkStatus = .InProgress
        let url = NSURL(string: self.imageUrlStr!)
        let urlRequest =  NSURLRequest(URL: url!)
//        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
//        session = NSURLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
//        
//        let imageDownloadTask = session!.downloadTaskWithRequest(urlRequest)
//        imageDownloadTask.resume()
//        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
//            println("done")
//        }
        
        con = NSURLConnection(request: urlRequest, delegate: self, startImmediately: false)
        con?.start()
        //con.
        
    }
    
    //MARK: - Url session delegate
    

//    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
//        self.downloadedData.appendData(data)
//    }
//    
//    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
//        NSLog("finished downloading");
//    }
//    
//    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//        
//        var cProgress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
//        self.updateProgress(cProgress)
//        println("progress is \(progress) ")
//
//    }
    
    //MARK:- Url Connection Delegate
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        self.downloadedData = NSMutableData()
        self.expectedLength = response.expectedContentLength
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        println("did received data");
        
        self.downloadedData.appendData(data)
        
        if self.expectedLength!>0{
            var cProgress = Double(self.downloadedData.length) / Double(self.expectedLength!)
            self.updateProgress(cProgress)
            println("progress is \(progress) ")
        }
       
        
        
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        currentNetworkStatus = .Completed
        self.progress = 1.0
        println("did finished data");
        self.updateProgress(1)
        self.flickrImage = UIImage(data: self.downloadedData)
    }
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        currentNetworkStatus = .Failed
        self.progress = 0.0
        println("did fail data")
        self.isInProgress = false
    }
    
    
//    func connection(connection: NSURLConnection, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, expectedTotalBytes: Int64) {
//        var cProgress = Double(totalBytesWritten) / Double(expectedTotalBytes)
//        self.updateProgress(cProgress)
//        println("progress is \(progress) ")
  //  }
////
//    func connectionDidFinishDownloading(connection: NSURLConnection, destinationURL: NSURL){
//        println("finished download")
//    }
}
