//
//  DataManager.swift
//  FlickrSwift
//
//  Created by Akhand Pratap Singh on 19/04/15.
//  Copyright (c) 2015 Akhand Pratap Singh. All rights reserved.
//

import UIKit

@objc protocol DataMangerDelegate{
    optional func test()
    optional func dataManagerdidFinishedSearchFor(searchKey:String, with photos:NSArray?, withSuccess status:Bool)
}

class DataManager: NSObject {
   let apiKey = "103863b25dd24b77fb841a727e3503ed"
    let flickerUrl =  "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=103863b25dd24b77fb841a727e3503ed&format=json&nojsoncallback=1&text="
    
    var dataManagerDelegate: DataMangerDelegate?
    var dataManagerOperationQueue = NSOperationQueue()
    
    class var sharedInstance: DataManager {
    
        struct Static{
            static let instance:DataManager = DataManager()
        }
        
        return Static.instance
    }
//    
    func searchFlicker(searchStr: String){
//        NSLog("search %@", searchStr)
//        let isLookingForFlickrResponse: ()? = dataManagerDelegate?.dataManager?(self, didFinishedSearchFor: searchStr, withSuccess: true)
//        if (isLookingForFlickrResponse != nil){
//            //self.dataManagerDelegate?.test!()
//        }else{
//            println("its not looking for flickr response")
//        }
    
        //---------------------
        let completeUrl = flickerUrl + searchStr
        println(completeUrl)
        
        let url = NSURL(string: completeUrl)
        let urlRequest = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: dataManagerOperationQueue) { (con:NSURLResponse!, data:NSData!, error:NSError?) -> Void in
            if error != nil{
            }else{
                var parserError:NSError?
                let jsonResult: NSDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &parserError) as? NSDictionary
                if jsonResult != nil{
                    
                    let rawPhotosDict:NSDictionary? = jsonResult!.valueForKey("photos") as? NSDictionary
                    
                    if rawPhotosDict != nil{
                        let rawPhotos:NSArray? = rawPhotosDict!.valueForKey("photo") as? NSArray
                        var fetchedPhotos:NSMutableArray? = NSMutableArray()
                        for aPhotoDict in rawPhotos!{
                            let id = aPhotoDict["id"] as NSString
                            var farm: NSNumber = aPhotoDict.valueForKey("farm") as NSNumber
                            //var farm1 = NSString(format: "%@", aPhotoDict.valueForKey("farm") as NSNumber)
                            
                            let secret = aPhotoDict["secret"] as NSString
                            let server = aPhotoDict["server"] as NSString
                            let title = aPhotoDict["title"] as NSString
                            let aPhoto = Image(farm: farm.stringValue, id: id, secret: secret, server: server, title: title)
                            fetchedPhotos?.addObject(aPhoto)
                            let dict:NSDictionary? = aPhotoDict as? NSDictionary
                            
                          
                        }
                        weak var weakDataManagerDelegate = self.dataManagerDelegate
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                           //
                            weak var delegate = self.dataManagerDelegate
                            delegate?.dataManagerdidFinishedSearchFor!(searchStr, with: fetchedPhotos, withSuccess: true)
                        })
                       // weakDataManagerDelegate?.dataManagerdidFinishedSearchFor!(searchStr, with: fetchedPhotos, withSuccess: true)
                    }
                }else{
                    println("invalid json")
                }
            }
            
        }
    
    }
}


