//
//  HomePageViewController.swift
//  PAL
//
//  Created by ZhouJialei on 15/2/4.
//  Copyright (c) 2015年 ZhouJialei. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController, UIScrollViewDelegate{

    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []
    var timer: NSTimer!
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //首页滑动广告栏，已完成了自动滑动的图片，仍需添加gesturerecognizer并增加相应的跳转路径
        let imageW: CGFloat = self.scrollView.frame.size.width
        let imageH: CGFloat = self.scrollView.frame.size.height
        let imageY: CGFloat = 0
        var imageX: CGFloat
        var name: String
        var timer: NSTimer!
        
        let totalCount: Int = 5
        
        for var index = 0; index < totalCount; index++ {
            imageX = CGFloat(index) * imageW
            let imageView = UIImageView(image: UIImage(named: "photo\(index+1).png"))
            imageView.frame = CGRectMake(imageX, imageY, imageW, imageH)
            
            self.scrollView.showsHorizontalScrollIndicator = false
            self.scrollView.addSubview(imageView)
        }
        
        var contentW: CGFloat = CGFloat(totalCount) * imageW
        self.scrollView.contentSize = CGSizeMake(contentW, 0)
        
        self.scrollView.pagingEnabled = true
        self.scrollView.delegate = self
        
        self.addTimer()
    }
    
    // function for the bounce
    func nextImage() {
        
        var page: Int = self.pageControl.currentPage
        if page == 4 {
            page = 0
        }else{
            page++
        }
        
        var x: CGFloat = CGFloat(page) * self.scrollView.frame.size.width
        self.scrollView.contentOffset = CGPointMake(x, 0)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var scrollViewW: CGFloat = scrollView.frame.size.width
        var x: CGFloat = scrollView.contentOffset.x
        var page: Int = Int((x + scrollViewW / 2) / scrollViewW)
        self.pageControl.currentPage = page
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.removeTimer()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.addTimer()
    }
    
    func addTimer() {
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "nextImage", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(self.timer, forMode: NSRunLoopCommonModes)
    }
    
    func removeTimer() {
        self.timer.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if viewController.isKindOfClass(TimeViewController){
            return false
        }
        return true
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}