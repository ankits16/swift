//
//  ASCircularProgreeView.h
//  CircularProgress
//
//  Created by Ankit on 22/06/14.
//  Copyright (c) 2014 NExGenApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASCircularProgressView : UIView

@property (nonatomic, assign) int percent;

- (id)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;
-(void) showProgress:(NSInteger) progress;

@end
