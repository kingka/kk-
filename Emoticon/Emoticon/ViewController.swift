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
        
        //判断当前点击的是否是emoji表情
        if emoticon.emojiStr != nil
        {
            self!.textView.replaceRange(self!.textView.selectedTextRange!, withText: emoticon.emojiStr!)
            
         // 判断当前点击的是否是表情图片
        }else if emoticon.png != nil
        {
            // 创建附件
            let attatchment = EmoticonTextAttachment()
            attatchment.chs = emoticon.chs
            attatchment.image = UIImage(contentsOfFile: emoticon.imagePath!)
            // 设置附件大小
            attatchment.bounds = CGRectMake(0, -4, 20, 20)
            //创建附件对应属性的字符串
            let imgText = NSAttributedString(attachment: attatchment)
            //拿到textView content
            let textViewStr = NSMutableAttributedString(attributedString: self!.textView.attributedText)
            //insert emoticon to curse location
            let range = self!.textView.selectedRange
            textViewStr.replaceCharactersInRange(range, withAttributedString: imgText)
            //因为创建的字符串有自己默认的size ，所以需要改变，这里的NSMakeRange(range.location, 1)，之所以是1，是因为上面已经insert了表情进来，这里要改变字体，是因为如果前一个inser了图片，接着insert emoji 表情，如果不改字体大小，emoji表情的大小会不正确
            textViewStr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(19), range: NSMakeRange(range.location, 1))
            //替换 textView content
            self!.textView.attributedText = textViewStr
            //恢复光标位置
            // 两个参数: 第一个是指定光标所在的位置, 第二个参数是选中文本的个数
            self!.textView.selectedRange = NSMakeRange(range.location + 1, 0)
        }

    }

}

