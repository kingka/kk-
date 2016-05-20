//
//  ViewController.swift
//  Emoticon
//
//  Created by Imanol on 16/5/13.
//  Copyright © 2016年 Imanol. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //将表情键盘控制器添加为当前控制器的子控制器
       addChildViewController(emoticonVC)
        //将表情键盘控制器的view设置为UITextView的inputView
        textView.inputView = emoticonVC.view
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    lazy var emoticonVC : EmoticonViewController = EmoticonViewController { (emoticon) -> () in
        
        if emoticon.emojiStr != nil
        {
            print(emoticon.emojiStr)
            
        }else if emoticon.png != nil
        {
            print(emoticon.png)
        }

    }

}

