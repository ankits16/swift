//
//  ASCircularProgreeView.m
//  CircularProgress
//
//  Created by Ankit on 22/06/14.
//  Copyright (c) 2014 NExGenApps. All rights reserved.
//

#import "ASCircularProgressView.h"

@interface ASCircularProgressView (){
    CGFloat startAngle;
    CGFloat endAngle;
    NSString* textContent;
}
@end

@implementation ASCircularProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.backgroundColor = [UIColor redColor];
        
        // Determine our start and stop angles for the arc (in radians)
        startAngle = M_PI * 1.5;
        endAngle = startAngle + (M_PI * 2);
        [self setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.0]];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect
{
    // Display our percentage as a string
    //[self setAlpha:0.5];
    if (_percent>0) {
        textContent = [NSString stringWithFormat:@"%d", _percent];
    }
    
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    
    // Create our arc, with the correct angles
    [bezierPath addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                          radius:20
                      startAngle:startAngle
                        endAngle:(endAngle - startAngle) * (_percent/100.0) + startAngle
                       clockwise:YES];
    
    // Set the display for the path, and stroke it
    bezierPath.lineWidth = 2;
    [[UIColor redColor] setStroke];
    [bezierPath stroke];
    
    
    // Text Drawing
//    CGRect textRect = CGRectMake(self.bounds.size.width/2-35, self.bounds.size.height/2-10,  71, 60);
//    [[UIColor blackColor] setFill];
//    [textContent drawInRect: textRect withFont: [UIFont fontWithName: @"Helvetica-Bold" size: 15] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
}


-(void) showProgress:(NSInteger) progress{
   // NSLog(@"updating with %d", progress);
    //dispatch_async(dispatch_get_main_queue(), ^{
        if (self.percent < 100) {
            self.percent = (uint32_t)progress;
            [self setNeedsDisplay];
        }
   // });
    
 
}

//-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    if ([keyPath isEqualToString:@"percent"]) {
//        if (self.percent == 100) {
//            NSLog(@"completed");
//            [self removeFromSuperview];
//        }
//    }
//}

@end
