//
//  MainTableViewCell.swift
//  FlickrSwift
//
//  Created by Akhand Pratap Singh on 19/04/15.
//  Copyright (c) 2015 Akhand Pratap Singh. All rights reserved.
//

import UIKit



class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var flickrImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressLbl: UILabel!
    
    var progressview: ASCircularProgressView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        progressview?.showProgress(0)
    }
    
}
