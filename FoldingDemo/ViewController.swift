//
//  ViewController.swift
//  FoldingDemo
//
//  Created by 张海南 on 2016/11/3.
//  Copyright © 2016年 枫韵海. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var foldingView: FoldIngView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //self.foldingView = FoldIngView(frame: CGRect(x: 50, y: 100, width: 300, height: Int(IMAGE_PER_HEIGIT * 4)))
        self.foldingView = FoldIngView(frame: CGRect(x: 10, y: 100, width: Int(ScreenWidth - 20), height: Int(IMAGE_PER_HEIGIT * 4)), foldingDirection: .horizontal)
        self.foldingView.backgroundColor = UIColor.purple
        self.view.addSubview(self.foldingView)
        
        

        
    }
    func nextVCClick() {
        
        
        let vc = NextViewController()
        self.present(vc, animated: true) { 
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

