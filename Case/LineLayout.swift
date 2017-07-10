//
//  LineLayout.swift
//  LineLayout
//
//  Created by wl on 15/11/6.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit

class LineLayout: UICollectionViewFlowLayout {

    var itemW: CGFloat = 150
    var itemH: CGFloat = 200
    var WIDTH: CGFloat = UIScreen.main.bounds.size.width
    
    lazy var inset: CGFloat = {
        //这样设置，inset就只会被计算一次，减少了prepareLayout的计算步骤
        return  (self.collectionView?.bounds.width ?? 0)  * 0.5 - self.itemSize.width * 0.5
        }()
    
    override init() {
        super.init()
        
        //设置每一个元素的大小
        self.itemSize = CGSize(width: itemW, height: itemH)
        //设置滚动方向
        self.scrollDirection = .horizontal
//        设置间距
        self.minimumLineSpacing = 0.5 * itemW
    }
    
    //苹果推荐，对一些布局的准备操作放在这里
    override func prepare() {
//        //设置边距(让第一张图片与最后一张图片出现在最中央)
//        self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset)
        // scrollRate
        collectionView?.decelerationRate = UIScrollViewDecelerationRateNormal
        collectionView?.contentInset = UIEdgeInsets.init(top: 0, left: collectionView!.bounds.width / 2 - (WIDTH - 84) / 2, bottom: 0, right: collectionView!.bounds.width / 2 - (WIDTH - 84) / 2)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
    返回true只要显示的边界发生改变就重新布局:(默认是false)
    内部会重新调用prepareLayout和调用
    layoutAttributesForElementsInRect方法获得部分cell的布局属性
    */
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let sizeWidth = WIDTH - 84
        let sizeHeight = collectionView.bounds.size.height
        return CGSize(width: sizeWidth, height: sizeHeight)
    }
    
    /**
    用来计算出rect这个范围内所有cell的UICollectionViewLayoutAttributes，
    并返回。
    */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //取出rect范围内所有的UICollectionViewLayoutAttributes，然而
        //我们并不关心这个范围内所有的cell的布局，我们做动画是做给人看的，
        //所以我们只需要取出屏幕上可见的那些cell的rect即可
        let array = super.layoutAttributesForElements(in: rect)
        
        //可见矩阵
        let visiableRect = CGRect(x: self.collectionView!.contentOffset.x, y: self.collectionView!.contentOffset.y, width: self.collectionView!.frame.width, height: self.collectionView!.frame.height)
        
        //接下来的计算是为了动画效果
        let maxCenterMargin = self.collectionView!.bounds.width * 0.5 + itemW * 0.5;
        //获得collectionVIew中央的X值(即显示在屏幕中央的X)
        let centerX = self.collectionView!.contentOffset.x + self.collectionView!.frame.size.width * 0.5;
        for attributes in array! {
            //如果不在屏幕上，直接跳过
            if !visiableRect.intersects(attributes.frame) {continue}
            let scale = 1 + (0.8 - abs(centerX - attributes.center.x) / maxCenterMargin)
            print("%lf", scale)
            attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        
//        for attributes in array! {
//            // 不在可见区域的attributes不变化
//            if !visiableRect.intersects(attributes.frame) {continue}
//            let frame = attributes.frame
//            let distance = abs(collectionView!.contentOffset.x + collectionView!.contentInset.left - frame.origin.x)
//            let scale = min(max(1 - distance/(collectionView!.bounds.width), 0.85), 1)
//            print("%lf", 1 - distance/(collectionView!.bounds.width))
//            
//            attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
//        }
        
        return array
    }
    
    /**
    用来设置collectionView停止滚动那一刻的位置
    
    - parameter proposedContentOffset: 原本collectionView停止滚动那一刻的位置
    - parameter velocity:              滚动速度
    
    - returns: 最终停留的位置
    */
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

        let lastRect = CGRect(x: proposedContentOffset.x, y: proposedContentOffset.y, width: self.collectionView!.frame.width, height: self.collectionView!.frame.height)
        //获得collectionVIew中央的X值(即显示在屏幕中央的X)
        let centerX = proposedContentOffset.x + self.collectionView!.frame.width * 0.5;
        //这个范围内所有的属性
        let array = self.layoutAttributesForElements(in: lastRect)
        //需要移动的距离
        var adjustOffsetX = CGFloat(MAXFLOAT);
        for attri in array! {
            if abs(attri.center.x - centerX) < abs(adjustOffsetX) {
                adjustOffsetX = attri.center.x - centerX;
            }
        }
        return CGPoint(x:(proposedContentOffset.x + adjustOffsetX), y:proposedContentOffset.y)
    }
}
