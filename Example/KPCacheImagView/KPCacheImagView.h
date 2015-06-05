//
//  CustomImageView.h
//  CustomControls
//
//  Created by Kunal Pandey on 18/05/15.
//  Copyright (c) 2015 Kunal Pandey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomLoaderView;
@interface CustomImageView : UIImageView
@property(nonatomic,strong) CustomLoaderView *progressIndicatorView;

-(void)setImageUrl:(NSString *)imageUrl;

@end
