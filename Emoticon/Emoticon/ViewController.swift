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
    
    @IBAction func Sent(sender: AnyObject) {
        
       let str = textView.emoticonStr()
        print(str)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //将表情键盘控制器添加为当前控制器的子控制器
       addChildViewController(emoticonVC)
        //将表情键盘控制器的view设置为UITextView的inputView
        textView.inputView = emoticonVC.view
        textView.font = UIFont.systemFontOfSize(20)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

    // weak 相当于OC中的 __weak , 特点对象释放之后会将变量设置为nil
    // unowned 相当于OC中的 unsafe_unretained, 特点对象释放之后不会将变量设置为nil
    lazy var emoticonVC : EmoticonViewController = EmoticonViewController { [weak self](emoticon) -> () in
        
        self!.textView.insertEmoticons(emoticon, fontSize: 20)

    }

}

