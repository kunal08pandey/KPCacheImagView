//
//  CustomImageView.m
//  CustomControls
//
//  Created by Kunal Pandey on 18/05/15.
//  Copyright (c) 2015 Kunal Pandey. All rights reserved.
//

#import "CustomImageView.h"
#import "UIImageView+WebCache.h"
#import "CustomLoaderView.h"

@implementation CustomImageView

-(id)initWithCoder:(NSCoder *)aDecoder {
  if(self = [super initWithCoder:aDecoder]) {
    self.progressIndicatorView = [[CustomLoaderView alloc] initWithFrame:CGRectZero];
    [self  addSubview:self.progressIndicatorView];
    self.progressIndicatorView.frame = self.bounds;
    self.progressIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
  return self;
}

-(void)setImageUrl:(NSString *)imageUrl {
  NSURL *url = [NSURL URLWithString:imageUrl];
  __weak CustomImageView *weakRef = self;
  [self sd_setImageWithURL:url placeholderImage:nil options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    weakRef.progressIndicatorView.progress = (CGFloat)(receivedSize)/(CGFloat)(expectedSize);
    
  } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    [weakRef.progressIndicatorView reveal];
    NSLog(@"%@",NSStringFromCGRect(weakRef.frame));
  }];

}


@end
