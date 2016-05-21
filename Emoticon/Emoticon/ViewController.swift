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
        
        var str = String()
        //转成发送给服务器的str
        self.textView.attributedText.enumerateAttributesInRange(NSMakeRange(0, self.textView.attributedText.length), options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (objc, range, _) -> Void in
            /*
            // 遍历的时候传递给我们的objc是一个字典, 如果字典中的NSAttachment这个key有值
            // 那么就证明当前是一个图片
            print(objc["NSAttachment"])
            // range就是纯字符串的范围
            // 如果纯字符串中间有图片表情, 那么range就会传递多次
            print(range)
            let res = (self.customTextView.text as NSString).substringWithRange(range)
            print(res)
            print("++++++++++++++++++++++++++")
            */
            
            if objc["NSAttachment"] != nil
            {
                let attatchment = objc["NSAttachment"] as! EmoticonTextAttachment
                str += attatchment.chs!
            }else{
                str += (self.textView.text as NSString).substringWithRange(range)
            }
        }
        
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

