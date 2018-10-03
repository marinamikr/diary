//
//  FirstExplainViewController.swift
//  SpeakToMe
//
//  Created by User on 2018/10/03.
//  Copyright © 2018年 Marina Harada. All rights reserved.
//

import UIKit

class TutorialViewController: UIPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([getFirst()], direction: .forward, animated: true, completion: nil)
        self.dataSource = self
        self.navigationItem.title = "使い方"
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "Mamelon", size: 20)]
    }
}

extension TutorialViewController : UIPageViewControllerDataSource {
    
    //ここに画面の数だけViewControllerを取得するメソッドを用意する
    func getFirst() -> FirstExplainViewController {
        return storyboard!.instantiateViewController(withIdentifier: "FirstExplainViewController") as! FirstExplainViewController
    }
    
    func getSecond() -> SecondExplainViewController {
        return storyboard!.instantiateViewController(withIdentifier: "SecondExplainViewController") as! SecondExplainViewController
    }
    
    func getThird() -> ThirdExplainViewController {
        return storyboard!.instantiateViewController(withIdentifier: "ThirdExplainViewController") as! ThirdExplainViewController
    }
    
    func getFourth() -> FourthViewController {
        return storyboard!.instantiateViewController(withIdentifier: "FourthViewController") as!
        FourthViewController
    }
    
    func getFifth() -> FifthViewController {
        return storyboard!.instantiateViewController(withIdentifier: "FifthViewController") as!
        FifthViewController
    }
    
    func getSixth() -> SixthViewController {
        return storyboard!.instantiateViewController(withIdentifier: "SixthViewController") as!
        SixthViewController
    }
    
    func getSeventh() -> SeventhViewController {
        return storyboard!.instantiateViewController(withIdentifier: "SeventhViewController") as!
        SeventhViewController
    }
    
    func getEighth() -> EighthViewController {
        return storyboard!.instantiateViewController(withIdentifier: "EighthViewController") as!
        EighthViewController
    }
    
    //戻る方向にスワイプされた場合の条件わけ
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //3番目の場合は2番目を表示。以下同様
        if viewController.isKind(of:ThirdExplainViewController.self){
            return getSecond()
        }else if viewController.isKind(of:SecondExplainViewController.self){
            return getFirst()
        }else if viewController.isKind(of:FourthViewController.self){
            return getThird()
        }else if viewController.isKind(of:FifthViewController.self){
            return getFourth()
        }else if viewController.isKind(of:SixthViewController.self){
            return getFifth()
        }else if viewController.isKind(of:SeventhViewController.self){
            return getSixth()
        }else if viewController.isKind(of:EighthViewController.self){
            return getSeventh()
        }else{
            return nil
        }
    }
    
    //進む方向にスワイプされた場合の条件わけ
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        //1番目の場合は2番目を表示。以下同様
        if viewController.isKind(of: FirstExplainViewController.self){
            return getSecond()
        }else if viewController.isKind(of: SecondExplainViewController.self){
            return getThird()
        }else if viewController.isKind(of: ThirdExplainViewController.self){
            return getFourth()
        }else if viewController.isKind(of: FourthViewController.self){
            return getFifth()
        }else if viewController.isKind(of: FifthViewController.self){
            return getSixth()
        }else if viewController.isKind(of: SixthViewController.self){
            return getSeventh()
        }else if viewController.isKind(of: SeventhViewController.self){
            return getEighth()
        }else{
            return nil
        }
    }
}

