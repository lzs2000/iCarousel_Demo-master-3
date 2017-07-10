//
//  AVButton.h
//  iCarousel_Demo
//
//  Created by 刘璐璐 on 2017/6/22.
//  Copyright © 2017年 AlezJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFPlayer.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ZFDownloadManager.h"
#import "ZFVideoModel.h"
#import "UIImageView+WebCache.h"
@interface AVButton : UIButton


@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) UIImageView *bgimageV;
/** model */
@property (nonatomic, strong) ZFVideoModel                  *model;

- (void)addPlayer;

@end
