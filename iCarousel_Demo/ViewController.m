//
//  ViewController.m
//  iCarousel_Demo
//
//  Created by admin on 16/6/1.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import "ViewController.h"
#import "iCarousel.h"
#import "UIImage+GIF.h"
#import "AVButton.h"
#import "ZFVideoModel.h"
#import "ZFVideoResolution.h"
#import <Masonry/Masonry.h>
#import <ZFDownload/ZFDownloadManager.h>
#import "ZFPlayer.h"

@interface ViewController ()<iCarouselDataSource, iCarouselDelegate, UIActionSheetDelegate, ZFPlayerDelegate>

@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, strong) UINavigationItem *navItem;
@property (nonatomic, assign) BOOL wrap;
@property (nonatomic, strong) NSMutableArray *items;
@property (strong, nonatomic) NSBundle *imageBundle;
//@property (nonatomic, strong) NSMutableArray      *dataSource;
@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@end

@implementation ViewController


- (void)dealloc
{
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    _carousel.delegate = nil;
    _carousel.dataSource = nil;
}
// 页面消失时候
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     [self.playerView pause];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.playerView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.playerView) {
        [self.playerView play];
    }
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _wrap = YES;
    
    
    //set up data
    //添加数据源
    [self requestData];
    //add background
    //添加背景
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backgroundView.image = [UIImage imageNamed:@"background.png"];
    [self.view addSubview:backgroundView];
    
    //create carousel
    //旋转木马初始化
    _carousel = [[iCarousel alloc] initWithFrame:self.view.bounds];
    _carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    /*
     iCarouselTypeLinear = 0,
     iCarouselTypeRotary,
     iCarouselTypeInvertedRotary,
     iCarouselTypeCylinder,
     iCarouselTypeInvertedCylinder,
     iCarouselTypeWheel,
     iCarouselTypeInvertedWheel,
     iCarouselTypeCoverFlow,
     iCarouselTypeCoverFlow2,
     iCarouselTypeTimeMachine,
     iCarouselTypeInvertedTimeMachine,
     iCarouselTypeCustom
     */
    _carousel.type = iCarouselTypeInvertedTimeMachine;//旋转类型
    _carousel.delegate = self;
    _carousel.dataSource = self;
    
    //add carousel to view
    //添加到view上
    [self.view addSubview:_carousel];
    
    //add top bar
//    //添加头
//    UINavigationBar *navbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
//    navbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    self.navItem = [[UINavigationItem alloc] initWithTitle:@"Coverflow2"];
//    _navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Switch Type" style:UIBarButtonItemStylePlain target:self action:@selector(switchCarouselType)];
//    _navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Wrap: ON" style:UIBarButtonItemStylePlain target:self action:@selector(toggleWrap)];
//    [navbar setItems:@[_navItem]];
//    [self.view addSubview:navbar];
    
    //add bottom bar
    //底部  添加和删除
//    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
//    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//    [toolbar setItems:@[[[UIBarButtonItem alloc] initWithTitle:@"Insert Item" style:UIBarButtonItemStylePlain target:self action:@selector(insertItem)],
//                        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL],
//                        [[UIBarButtonItem alloc] initWithTitle:@"Delete Item" style:UIBarButtonItemStylePlain target:self action:@selector(removeItem)]]];
//    [self.view addSubview:toolbar];
    
}
- (void)requestData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"videoData" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    self.items = @[].mutableCopy;
    NSArray *videoList = [rootDict objectForKey:@"videoList"];
    for (NSDictionary *dataDic in videoList) {
        ZFVideoModel *model = [[ZFVideoModel alloc] init];
        [model setValuesForKeysWithDictionary:dataDic];
        if (self.items.count > 10) {
            break;
        }
        [self.items addObject:model];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.carousel = nil;
    self.navItem = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

//- (void)switchCarouselType
//{
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select Carousel Type"
//                                                       delegate:self
//                                              cancelButtonTitle:nil
//                                         destructiveButtonTitle:nil
//                                              otherButtonTitles:@"Linear", @"Rotary", @"Inverted Rotary", @"Cylinder", @"Inverted Cylinder", @"Wheel", @"Inverted Wheel",  @"CoverFlow", @"CoverFlow2", @"Time Machine", @"Inverted Time Machine", @"Custom", nil];
//    [sheet showInView:self.view];
//}
//
//- (void)toggleWrap
//{
//    _wrap = !_wrap;
//    _navItem.rightBarButtonItem.title = _wrap? @"Wrap: ON": @"Wrap: OFF";
//    [_carousel reloadData];
//}

//- (void)insertItem
//{
//    NSInteger index = _carousel.currentItemIndex;
//    [_items insertObject:@(_carousel.numberOfItems) atIndex:index];
//    [_carousel insertItemAtIndex:index animated:YES];
//}
//
//- (void)removeItem
//{
//    if (_carousel.numberOfItems > 0)
//    {
//        NSInteger index = _carousel.currentItemIndex;
//        [_carousel removeItemAtIndex:index animated:YES];
//        [_items removeObjectAtIndex:index];
//    }
//}

#pragma mark -
#pragma mark UIActionSheet methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0)
    {
        //map button index to carousel type
        iCarouselType type = buttonIndex;
        
        //carousel can smoothly animate between types
        [UIView beginAnimations:nil context:nil];
        _carousel.type = type;
        [UIView commitAnimations];
        
        //update title
        _navItem.title = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [_items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    NSLog(@"carousel viewForItemAtIndex:");
     AVButton *button = (AVButton *)view;
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    
     if (button == nil)
     {
         NSLog(@"carousel viewForItemAtIndex:---new");
         button = [AVButton buttonWithType:UIButtonTypeCustom];
         button.frame = CGRectMake(0.0f, 0.0f, 280 * width / 375,  380 * height / 667);
         [button addPlayer];
         button.backgroundColor = [UIColor colorWithRed:200 / 256.0 green:200 / 256.0 blue:200 / 256.0 alpha:0.8];
         [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
         
     }
       [button setTitle:[NSString stringWithFormat:@"%ld", (long)index] forState:UIControlStateNormal];
   
    
     return button;
     /**/
}


#pragma mark Button tap event

- (void)buttonTapped:(UIButton *)sender
{
    //get item index for button
    NSInteger index = [_carousel indexOfItemViewOrSubview:sender];
    
    [[[UIAlertView alloc] initWithTitle:@"Button Tapped"
                                message:[NSString stringWithFormat:@"You tapped button number %ld", index]
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return _wrap;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 0.75f;
        }
        case iCarouselOptionFadeMax:
        {
            if (carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        default:
        {
            return value;
        }
    }
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
         _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspectFill;
        // 静音
        // _playerView.mute = YES;
    }
    return _playerView;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [[ZFPlayerControlView alloc] init];
    }
    return _controlView;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
   
    AVButton *button = (AVButton *)[carousel currentItemView];
    // 取到对应cell的model
     ZFVideoModel *model        = self.items[[carousel currentItemIndex]];
    //button.model = model;
    // 分辨率字典（key:分辨率名称，value：分辨率url)
    NSMutableDictionary *dic = @{}.mutableCopy;
    for (ZFVideoResolution * resolution in model.playInfo) {
        [dic setValue:resolution.url forKey:resolution.name];
    }
    // 取出字典中的第一视频URL
    NSURL *videoURL = [NSURL URLWithString:dic.allValues.firstObject];
    
    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
    playerModel.title            = model.title;
    playerModel.videoURL         = videoURL;
    playerModel.placeholderImageURLString = model.coverForFeed;
    playerModel.fatherView = button.bgimageV;
    playerModel.fatherViewTag = button.bgimageV.tag;
    
    
    // 赋值分辨率字典
    playerModel.resolutionDic    = dic;
    // NSIndexPath *tempIndex = [NSIndexPath indexPathWithIndex:index];
    // playerModel.indexPath = tempIndex;
    
    
    // 设置播放控制层和model
    [self.playerView playerControlView:nil playerModel:playerModel];
    // 下载功能
    self.playerView.hasDownload = YES;
    // 自动播放
    [self.playerView resetToPlayNewVideo:playerModel];
}
#pragma mark - ZFPlayerDelegate

- (void)zf_playerDownload:(NSString *)url {
    // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
    NSString *name = [url lastPathComponent];
    [[ZFDownloadManager sharedDownloadManager] downFileUrl:url filename:name fileimage:nil];
    // 设置最多同时下载个数（默认是3）
    [ZFDownloadManager sharedDownloadManager].maxCount = 4;
}

@end
