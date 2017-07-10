//
//  UIImage+GIF.h
//  Netease
//
//  Created by 刘璐璐 on 2017/6/8.
//  Copyright © 2017年 刘璐璐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GIF)
+ (UIImage *)sd_animatedGIFNamed:(NSString *)name;

+ (UIImage *)sd_animatedGIFWithData:(NSData *)data;

- (UIImage *)sd_animatedImageByScalingAndCroppingToSize:(CGSize)size;
@end
