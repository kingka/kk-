//
//  EmoticonPackage.swift
//  Emoticon
//
//  Created by Imanol on 16/5/18.
//  Copyright © 2016年 Imanol. All rights reserved.
//

import UIKit

class EmoticonPackage: NSObject {
    /// 当前组表情文件夹的名称
    var id: String?
    /// 组的名称
    var group_name_cn : String?
    /// 当前组所有的表情对象
    var emoticons: [Emoticon]?
    
    class func loadAllPacakges()->[EmoticonPackage]?{
        let path = NSBundle.mainBundle().pathForResource("emoticons", ofType: "plist", inDirectory: "Emoticons.bundle")
        let dict = NSDictionary(contentsOfFile: path!)
        //packageArray的数据类型是字典数组 ([],[])
        let packageArray = dict!["packages"]  as! [[String:AnyObject]]
        //packages 用来存放最后需要返回的值
        var packages = [EmoticonPackage]()
        for d in packageArray
        {
            let package = EmoticonPackage(id: d["id"]! as! String)
            package.loadEmoticons()
            package.appendEmptyEmoticons()
            packages.append(package)
        }
        return packages
    }
    
    func loadEmoticons(){
        let dict = NSDictionary(contentsOfFile: infoPlistPath())
        group_name_cn = dict!["group_name_cn"] as? String
        let dictArray = dict!["emoticons"] as! [[String : String]]
        emoticons = [Emoticon]()
        var index = 0
        for dict in dictArray
        {
            //使每一页最后一个btn 为 删除按钮
            if (index == 20){
                emoticons?.append(Emoticon(isDeleteBtn: true))
                index = 0
            }
            let emoticon = Emoticon(dict: dict, id: self.id!)
            emoticons?.append(emoticon)
            index++
        }
    }
    
    func appendEmptyEmoticons(){
        //取余，如果count 不为0 ，那么就 补全 20 - count 的数量，然后再添加一个delete btn
        let count = emoticons!.count % 21
        print("count = \(count)")
        //因为loadEmoticons（）方法里面已经控制了第21个肯定是delete
        if count > 0
        {
            for _ in count..<20
            {
                emoticons?.append(Emoticon(isDeleteBtn: false))
            }
            
            emoticons?.append(Emoticon(isDeleteBtn: true))
        }

    }
    
    
    func infoPlistPath() -> String{
          let path =  (EmoticonPackage.emoticonsBundlePath().stringByAppendingPathComponent(id!) as NSString).stringByAppendingPathComponent("info.plist")
        return path
    }
    
    class func emoticonsBundlePath()->NSString{
        return (NSBundle.mainBundle().bundlePath as NSString).stringByAppendingPathComponent("Emoticons.bundle")
    }
    
    init(id : String) {
        super.init()
        self.id = id
    }
    
    

}

class Emoticon : NSObject {
    /// 表情对应的文字
    var chs: String?
    /// 表情对应的图片
    var png: String?{
        didSet{
            imagePath = (EmoticonPackage.emoticonsBundlePath().stringByAppendingPathComponent(id!) as NSString).stringByAppendingPathComponent(png!)
        }
    }
    /// emoji表情对应的十六进制字符串
    var code: String?{
        didSet{
            let scanner = NSScanner(string: code!)
            var result : UInt32 = 0
            scanner.scanHexInt(&result)
            emojiStr = "\(Character(UnicodeScalar(result)))"
        }
    }
    
    var emojiStr : String?
    /// 当前表情对应的文件夹
    var id: String?
    
    ///表情图片path
    var imagePath : String?
    
    var isDeleteBtn : Bool = false
    
    init(isDeleteBtn : Bool) {
        super.init()
        self.isDeleteBtn = isDeleteBtn
    }
    
    init(dict : [String : String], id : String) {
        super.init()
        self.id = id
        setValuesForKeysWithDictionary(dict)
        
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
