//
//  AVButton.m
//  iCarousel_Demo
//
//  Created by 刘璐璐 on 2017/6/22.
//  Copyright © 2017年 AlezJi. All rights reserved.
//

#import "AVButton.h"


@interface AVButton() <ZFPlayerDelegate>


@end

@implementation AVButton

- (void)addPlayer {
    self.bgimageV = [[UIImageView alloc] initWithFrame:self.bounds];
    self.bgimageV.tag = 200;
    [self addSubview:_bgimageV];
    
    }
- (void)setModel:(ZFVideoModel *)model {
    [self.bgimageV sd_setImageWithURL:[NSURL URLWithString:model.coverForFeed] placeholderImage:[UIImage imageNamed:@"loading_bgView"]];
    
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        
        // 当cell划出屏幕的时候停止播放
         _playerView.stopPlayWhileCellNotVisable = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        // _playerView.mute = YES;
    }
    return _playerView;
}

@end
