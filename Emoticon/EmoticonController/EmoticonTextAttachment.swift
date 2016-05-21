//
//  EmoticonTextAttachment.swift
//  Emoticon
//
//  Created by Imanol on 16/5/20.
//  Copyright © 2016年 Imanol. All rights reserved.
//

import UIKit

class EmoticonTextAttachment: NSTextAttachment {
    var chs: String?
    
    class func createImageText(emoticon : Emoticon,fontSize : CGFloat)->NSAttributedString{
        // 创建附件
        let attatchment = EmoticonTextAttachment()
        attatchment.chs = emoticon.chs
        attatchment.image = UIImage(contentsOfFile: emoticon.imagePath!)
        // 设置附件大小
        attatchment.bounds = CGRectMake(0, -4, fontSize+2, fontSize+2)
        //创建附件对应属性的字符串
        return NSAttributedString(attachment: attatchment)
    }
}
