//
//  CaseDetailViewController.swift
//  LineLayout
//
//  Created by 刘璐璐 on 2017/6/19.
//  Copyright © 2017年 wl. All rights reserved.
//

import UIKit

public enum kScrollState {
    case kScrollStateNormol
    case kScrollStateUp
    case kScrollStateDown
}



class CaseDetailViewController: UIViewController {
    @IBOutlet weak var introductionV: UIView!
    @IBOutlet weak var portraitRightImg: UIImageView!
    @IBOutlet weak var portraitImg: UIImageView!
    @IBOutlet weak var bgPortraintImg: UIImageView!
    @IBOutlet weak var locationL: UILabel!
    @IBOutlet weak var moneyL: UILabel!
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var leftMargin: NSLayoutConstraint!
   
   
    
    
    let changeNavigationBar = "changeNavigationBar"
    var changeNav : Bool = false
    

var collectionviewH: CGFloat = UIScreen.main.bounds.size.height * 3 / 5
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
    }
  
    convenience  init() {
        var nibNameOrNil = String?("CaseDetailViewController")
        //考虑到xib文件可能不存在或被删，故加入判断
        if Bundle.main.path(forResource: "CaseDetailViewController", ofType: "xib") == nil
            
        {
            
            nibNameOrNil = nil
            
        }
        self.init(nibName: nibNameOrNil, bundle: nil)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        self.view.addGestureRecognizer(panGesture)
        
        portraitImg.layer.cornerRadius = portraitImg.frame.size.width / 2
        portraitImg.clipsToBounds = true
        portraitRightImg.layer.cornerRadius = portraitRightImg.frame.size.width / 2
        portraitRightImg.clipsToBounds = true
        
       // navigationView = self.navigationItem.titleView!
    }
   
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension CaseDetailViewController {
    func setCollectionViewAlPha(alpha: CGFloat) {
     let collectionView =  self.view.superview?.subviews[2]
        collectionView?.alpha = alpha
        if alpha == 1.0 {

            
            collectionView?.isHidden = false
            
     
        } else {
            collectionView?.isHidden = true
        }
    }

    func didPan(_ panGesture: UIPanGestureRecognizer) {
        
        switch panGesture.state {
        case .began:
          
            if self.portraitImg.center.x != self.bgPortraintImg.center.x {
               // self.leftMargin.constant = -self.portraitImg.frame.size.width
                self.portraitImg.isHidden = true
            }
            if self.portraitRightImg.center.x != self.bgPortraintImg.center.x {
               
                self.portraitRightImg.isHidden = true
            }
           // self.portraitRightImg.isHidden = true
            self.bgPortraintImg.backgroundColor = UIColor.clear
            self.introductionV.backgroundColor = UIColor.clear
            self.view.superview?.subviews[3].backgroundColor = UIColor.clear
            self.bgPortraintImg.image = UIImage(named: "alpha0-1")
            self.setNavState()
            isScroll = true
            scrollState = .kScrollStateNormol
            break
        case .ended:
            isScroll = false
            if scrollState ==  .kScrollStateUp {
                //高度超过200
                if self.collectionviewH + 100 - self.view.frame.origin.y  > 200 {

                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                        //self.setCollectionViewAlPha(alpha: 1.0)
                    }, completion: { (_ ) in
                        self.setNavState()
                    })
                    
                } else {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.frame = CGRect(x: 0, y: (self.collectionviewH + 100), width: self.view.frame.size.width, height: self.view.frame.size.height)
                      
                        self.setCollectionViewAlPha(alpha: 1.0)
                    },  completion: { (_) in
                        
                        self.introductionV.backgroundColor = UIColor.white
                        self.view.superview?.subviews[3].backgroundColor = UIColor.white
                        self.bgPortraintImg.image = UIImage(named: "1234")
                        if self.portraitRightImg.center.x != self.bgPortraintImg.center.x {
                             self.leftMargin.constant = 0
                        }
                    })
                }
                
            } else if scrollState == .kScrollStateDown {
                if self.collectionviewH + 100 - self.view.frame.origin.y > 200 {
                    UIView.animate(withDuration: 0.5, animations: { 
                        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                        self.setCollectionViewAlPha(alpha: 1.0)
                    }, completion: { (_ ) in
                         self.setNavState()
                                            })
                   
                } else {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.frame = CGRect(x: 0, y: (self.collectionviewH + 100), width: self.view.frame.size.width, height: self.view.frame.size.height)
                       
                        self.setCollectionViewAlPha(alpha: 1.0)
                    },  completion: { (_) in
                        if self.portraitRightImg.center.x != self.bgPortraintImg.center.x {
                            self.leftMargin.constant = 0
                        }

                        
                        self.view.superview?.subviews[3].backgroundColor = UIColor.white
                        self.bgPortraintImg.image = UIImage(named: "1234")
                          //self.leftMargin.constant = 0
                    })
                }
            }
            scrollState = .kScrollStateNormol
            
            break
            
        case .cancelled:
            self.setNavState()
            isScroll = false
            break
        case .changed:
            self.setNavState()
            let translation = panGesture.translation(in: self.view).y
            
            if (translation == 0 && panGesture.translation(in: self.view).x != 0) {
                return;
            }
            if isScroll {
                let tempView = panGesture.view
                
                if translation > 0  {
                     //print(self.view.frame.origin.y)
                    scrollState = .kScrollStateDown
                   self.view.superview?.subviews[2].alpha = 1 - abs(self.view.frame.origin.y - (collectionviewH + 100))/250

                } else {
                    scrollState = .kScrollStateUp
                    self.view.superview?.subviews[2].alpha = 1 - abs(self.view.frame.origin.y - (collectionviewH + 100))/250
                    
                }
               
                
                let translation = panGesture.translation(in: tempView?.superview)
                tempView?.center = CGPoint(x: (tempView?.center.x)!, y: (tempView?.center.y)! + translation.y)
                panGesture.setTranslation( CGPoint(x: 0, y: 0), in: view.superview)
            }
            break
        default: break
            
            
        }
        
    }
    //scrollViewDidEndDecelerating
    
    func setNavState()  {
        print(self.view.frame.origin.y)
        if self.view.frame.origin.y < 10 {
            if !changeNav {
                changeNav = true
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: changeNavigationBar), object: self, userInfo: ["changeNav": changeNav])
            }
            
        } else {
            if changeNav {
                changeNav = false
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: changeNavigationBar), object: self, userInfo: ["changeNav": changeNav])
            }
            
            
        }
       
    }
    
    
    }


