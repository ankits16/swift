//
//  Image.swift
//  FlickrSwift
//
//  Created by Akhand Pratap Singh on 19/04/15.
//  Copyright (c) 2015 Akhand Pratap Singh. All rights reserved.
//

import UIKit

class Image: NSObject {
    //let imageName: String
   //
    
    var imageUrlStr: NSString?
    var flickrImage: UIImage?
    var isInProgress: Bool
    var progress: Float
    
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
        progress = 0.0
    }
}
