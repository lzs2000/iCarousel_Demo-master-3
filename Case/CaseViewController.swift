//
//  ViewController.swift
//  LineLayout
//
//  Created by wl on 15/11/6.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit


public enum kScrollDirection {
    case kScrollDirectionLeft
    case kScrollDirectionRight
   
}

var isScroll : Bool!
var scrollState: kScrollState!
var scrollDirection: kScrollDirection!//记录上面的collectionview往左滑动还是往右滑动

class CaseViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    var collectionviewH: CGFloat = UIScreen.main.bounds.size.height * 3 / 5
    
    var caseDetailV = CaseDetailViewController()
    var currentIndexPath = 0
    var introVFrame:CGRect?
    
    var imageViewAvatar = UIImageView()
    var nameLabel = UILabel()
    var tempTitleView = UIView()
    var lastIndex:NSInteger?
    lazy var imageArray: [String] = {
        
        var array: [String] = []

        for i in 1...20 {
            array.append("\(i)-1")
        }
        
        return array
    }()
    
    var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lastIndex = 0
        let collectionView =  UICollectionView(frame: CGRect(x: 0, y: 100, width: self.view.bounds.width, height: collectionviewH), collectionViewLayout: LineLayout())
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource  = self
        collectionView.delegate = self
    
        collectionView.register(ImageTextCell.self, forCellWithReuseIdentifier: "ImageTextCell")
        self.view.addSubview(collectionView)
        
        caseDetailV.view.frame = CGRect(x: 0, y: collectionviewH + 100, width: self.view.frame.size.width, height: self.view.frame.size.height)
         self.view.addSubview(caseDetailV.view)
        //caseDetailV.view.alpha = 0.5
        
         scrollState = .kScrollStateNormol
        self.collectionView = collectionView
        
        let notificationName = Notification.Name(rawValue: "changeNavigationBar")
        NotificationCenter.default.addObserver(self, selector: #selector(CaseViewController.changeNav(notification:)), name: notificationName, object: nil)
        
        self.automaticallyAdjustsScrollViewInsets = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // self.tempTitleView = self.navigationItem.titleView!

    }
    func changeNav(notification:Notification)  {
        let userInfo = notification.userInfo as! [String: Bool]
        let value1 = userInfo["changeNav"]!
        if value1 {
            self.setupNavigationBar()
        } else {
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: 200, height: 20)
            label.text = "选择案例"
            label.textAlignment = .center
            label.textColor = UIColor.black
            label.font = UIFont.systemFont(ofSize: 18)
            self.navigationItem.titleView = label
        }
         }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func setupNavigationBar() {
        
        imageViewAvatar.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 30, y: 10, width: 30, height: 30)
        imageViewAvatar.layer.cornerRadius = 15
        imageViewAvatar.layer.masksToBounds = true
        imageViewAvatar.image = UIImage(named: "14")
        
        nameLabel.frame = CGRect(x: UIScreen.main.bounds.width / 2 + 10, y: 15, width: 150, height: 15)
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 13)
        nameLabel.text = "楚乔"
        nameLabel.center.y = imageViewAvatar.center.y
        nameLabel.textColor = UIColor.black
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 54))
        titleView.addSubview(imageViewAvatar)
        titleView.addSubview(nameLabel)
        // titleView会自动被系统设置大小.
        // 使用imageViewAvatar的大小需要调整
        self.navigationItem.titleView = titleView
 
    }

    
    
    // MARK: - collectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageTextCell", for: indexPath) as! ImageTextCell
        cell.imageStr = self.imageArray[indexPath.item] as NSString

        return cell
    }
    // MARK: - collectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        
        //self.imageArray.remove(at: indexPath.item)
        
        //collectionView.deleteItems(at: [indexPath])
    }
    
   

    //Mark--获取当前collectionview中间那个cell所在的下标
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pInView = self.view.convert((self.collectionView?.center)!, to: self.collectionView)
        let indexPathNow = self.collectionView?.indexPathForItem(at: pInView)
        if (indexPathNow?.row)! > self.lastIndex! {
            scrollDirection = .kScrollDirectionRight
        } else {
            scrollDirection = .kScrollDirectionLeft
        }
        self.lastIndex = indexPathNow?.row
        if indexPathNow?.row == self.currentIndexPath {
            return
        } else {
             self.currentIndexPath = (indexPathNow?.row)!
        }
        self.caseDetailV.introducTopCons.constant += 100
        self.caseDetailV.introductionV.alpha = 0.0
        UIView.animate(withDuration: 0.01, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
            self.view.layoutIfNeeded()
        }) { (result) in
            if (result) {
                self.caseDetailV.introducTopCons.constant -= 100
                self.caseDetailV.introductionV.alpha = 1.0
                UIView.animate(withDuration: 0.99, delay: 0.0, usingSpringWithDamping:0.8, initialSpringVelocity: 0.0,  options: [], animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)

            }
        }
        if self.caseDetailV.portraitImg.isHidden {
            self.caseDetailV.portraitImg.isHidden = false
        }
        if self.caseDetailV.portraitRightImg.isHidden {
            self.caseDetailV.portraitRightImg.isHidden = false
        }
       
        if (self.caseDetailV.portraitRightImg.center.x < self.caseDetailV.portraitImg.center.x) {
            //让portraitImg从左到右
            self.caseDetailV.portraitImgCenter.constant = 0.0
        } else {
            //让portraitImgRight从左到右
            self.caseDetailV.portraitImgCenter.constant += self.caseDetailV.portraitImg.frame.size.width
        }
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping:0.8, initialSpringVelocity: 0.0,  options: [], animations: {
            self.view.layoutIfNeeded()
        }, completion: { (_) in
             //portraitRightImg在pportraitImg左边 显示的是portraitRightImg
            if (self.caseDetailV.portraitImg.center.x < self.caseDetailV.portraitRightImg.center.x && self.caseDetailV.portraitRightImg.center.x == self.caseDetailV.bgPortraintImg.center.x) {
                //让不显示的portraitRightImg跑到右边
                    self.caseDetailV.portraitImg.isHidden = true
                    self.caseDetailV.leftMargin.constant -= 2 * self.caseDetailV.portraitImg.frame.size.width
                    self.caseDetailV.portraitImgCenter.constant -= 2 * self.caseDetailV.portraitImg.frame.size.width
            }
            //portraitImg在portraitRightImg左边 显示的是portraitImg
            if(self.caseDetailV.portraitImg.center.x == self.caseDetailV.bgPortraintImg.center.x && self.caseDetailV.portraitRightImg.center.x < self.caseDetailV.portraitImg.center.x) {
                //让不显示的portraitImg跑到右边
                 self.caseDetailV.leftMargin.constant = 0.0
            }
           UIView.animate(withDuration: 0.01, delay: 0.0, usingSpringWithDamping:0.8, initialSpringVelocity: 0.0,  options: [], animations: {
            self.view.layoutIfNeeded()
                        }, completion: nil)
            
        })
       
        
        
    }
    
  

}

