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
            packages.append(package)
        }
        return packages
    }
    
    func loadEmoticons(){
        let dict = NSDictionary(contentsOfFile: infoPlistPath())
        group_name_cn = dict!["group_name_cn"] as? String
        let dictArray = dict!["emoticons"] as! [[String : String]]
        emoticons = [Emoticon]()
        for dict in dictArray
        {
            let emoticon = Emoticon(dict: dict, id: self.id!)
            emoticons?.append(emoticon)
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
    var png: String?
    /// emoji表情对应的十六进制字符串
    var code: String?
    /// 当前表情对应的文件夹
    var id: String?
    
    init(dict : [String : String], id : String) {
        super.init()
        self.id = id
        setValuesForKeysWithDictionary(dict)
        
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
