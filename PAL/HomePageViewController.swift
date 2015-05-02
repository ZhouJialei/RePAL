//
//  HomePageViewController.swift
//  PAL
//
//  Created by ZhouJialei on 15/2/4.
//  Copyright (c) 2015年 ZhouJialei. All rights reserved.
//

import UIKit

//页面跳转已经在storyboard中做了 不要再画蛇添足了！！！
//否则会引发window hierarchy问题

var searchKey = ""

class RecommandTeacher {
    // MARK: TODO: change the portraitName to the url
    var portraitName: String = ""
    var name: String = ""
    var school: String = ""
    var course: String = ""
    var experience: String = ""
    // MARK: TODO: change the gradeName to the url
    var gradeName: String = ""
    var availableImageName: String = ""
}

class HomePageViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource{

    //////////////////////////////////////////
    // Array to fill the recommand tableView
    var recommandArray: [RecommandTeacher] = [RecommandTeacher]()
    
    
    
    ////////////////////////////////////
    // MARK: bounce
    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []
    var timer: NSTimer!
    
    @IBOutlet weak var recommandTableView: UITableView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    // Array to save the filter results
    var filterArray: [NSDictionary] = []
    
    // Array to save the results for the cell
    var teacherArray: [Teacher] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //////////////////////////////
        var recommandTeacher = RecommandTeacher()
        recommandTeacher.portraitName = "1.jpg"
        recommandTeacher.name = "赵小龙"
        recommandTeacher.school = "西安电子科技大学"
        recommandTeacher.course = "高中英语 初中数学"
        recommandTeacher.gradeName = "4_9.png"
        recommandTeacher.experience = "家教经验 一年"
        recommandTeacher.availableImageName = "available.png"
        recommandArray.append(recommandTeacher)
        
        var recommandTeacher1 = RecommandTeacher()
        recommandTeacher1.portraitName = "2.jpg"
        recommandTeacher1.name = "王小兵"
        recommandTeacher1.school = "西安电子科技大学"
        recommandTeacher1.course = "初中英语 高中数学"
        recommandTeacher1.gradeName = "4_9.png"
        recommandTeacher1.experience = "家教经验 一年"
        recommandTeacher1.availableImageName = "available.png"
        recommandArray.append(recommandTeacher1)
        
        var recommandTeacher2 = RecommandTeacher()
        recommandTeacher2.portraitName = "3.jpg"
        recommandTeacher2.name = "王小琦"
        recommandTeacher2.school = "西安电子科技大学"
        recommandTeacher2.course = "高中化学 初中英语"
        recommandTeacher2.gradeName = "4_9.png"
        recommandTeacher2.experience = "家教经验 二年"
        recommandTeacher2.availableImageName = "available.png"
        recommandArray.append(recommandTeacher2)
        
        /////////////////////////////////////////////////


    }
   
    override func viewDidAppear(animated: Bool) {
        //首页滑动广告栏，已完成了自动滑动的图片，仍需添加gesturerecognizer并增加相应的跳转路径
        let imageW: CGFloat = self.scrollView.frame.size.width
        let imageH: CGFloat = self.scrollView.frame.size.height
        let imageY: CGFloat = 0
        var imageX: CGFloat
        var name: String
        var timer: NSTimer!
        
        let totalCount: Int = 3
        
        for var index = 0; index < totalCount; index++ {
            imageX = CGFloat(index) * imageW
            let imageView = UIImageView(image: UIImage(named: "ad\(index+1)_320.png"))
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
        if page == 2 {
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
    
    ////////////////////////////////////////////////////

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {

        return true
    }
    
    //MARK: recommandTableView delegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommandArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: TODO
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecommandPerson") as RecommandCell
        
        let index = indexPath.row
        println(index)
        
        cell.portraitImage.image = UIImage(named: recommandArray[index].portraitName)
        cell.nameLabel.text = recommandArray[index].name
        cell.schoolLabel.text = recommandArray[index].school
        cell.courseLabel.text = recommandArray[index].course
        cell.experienceLabel.text = recommandArray[index].experience
        cell.gradeImage.image = UIImage(named: recommandArray[index].gradeName)
        cell.availableImage.image = UIImage(named: recommandArray[index].availableImageName)
        
        return cell
    }
    
    
    // MARK: Quick search methods
    
    @IBAction func goChineseSearch(sender: UIButton) {
        searchKey = "语文"
        self.performSegueWithIdentifier("goQuickSearch", sender: self)
    }
    
    
    //use dispatch to do the segue after the viewDidLoad

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
