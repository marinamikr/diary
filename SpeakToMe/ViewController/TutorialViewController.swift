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
    
    //戻る方向にスワイプされた場合の条件わけ
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //3番目の場合は2番目を表示。以下同様
        if viewController.isKind(of:ThirdExplainViewController.self){
            return getSecond()
        }else if viewController.isKind(of:SecondExplainViewController.self){
            return getFirst()
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
        }else{
            return nil
        }
    }
}
