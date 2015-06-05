//
//  CustomView.h
//  CustomControls
//
//  Created by Kunal Pandey on 18/05/15.
//  Copyright (c) 2015 Kunal Pandey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomLoaderView : UIView
@property(nonatomic,assign) CGFloat progress;
-(void)reveal;
@end
