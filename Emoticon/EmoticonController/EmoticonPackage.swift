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
        //packages 用来存放最后需要返回的值
        var packages = [EmoticonPackage]()
        
        //初始化最近使用过的表情
        let recentPackage = EmoticonPackage(id: "")
        recentPackage.group_name_cn = "最近"
        recentPackage.emoticons = [Emoticon]()
        recentPackage.appendEmptyEmoticons()
        packages.append(recentPackage)
        
        let path = NSBundle.mainBundle().pathForResource("emoticons", ofType: "plist", inDirectory: "Emoticons.bundle")
        let dict = NSDictionary(contentsOfFile: path!)
        //packageArray的数据类型是字典数组 ([],[])
        let packageArray = dict!["packages"]  as! [[String:AnyObject]]
        
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
    
    func appendCurrentUsedEmoticons(emoticon : Emoticon){
        
        //判断是否delete btn
        if emoticon.isDeleteBtn{
            return
        }
        
        let contains = emoticons!.contains(emoticon)
        
        //如果没有包含，则先把delete 按钮移除
        if !contains
        {
            emoticons?.removeLast()
            //把 emoticon append 进来
            emoticons?.append(emoticon)
        }
        
        //通过 times 属性的使用次数进行排序
        var result = emoticons?.sort({ (el1, el2) -> Bool in
            el1.times > el2.times
        })
        
        //把次数使用少的那个移除,然后再把delete加进来
        if !contains
        {
            result?.removeLast()
            result?.append(Emoticon(isDeleteBtn: true))
        }

        //重新指向
        emoticons = result
        
        print(emoticons?.count)
        
    }
    
    func appendEmptyEmoticons(){
        //取余，如果count 不为0 ，那么就 补全 20 - count 的数量，然后再添加一个delete btn
        let count = emoticons!.count % 21
        
            for _ in count..<20
            {
                emoticons?.append(Emoticon(isDeleteBtn: false))
            }
            
            emoticons?.append(Emoticon(isDeleteBtn: true))
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
    
    ///使用次数
    var times : Int = 0
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
