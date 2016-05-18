//
//  EmoticonViewController.swift
//  Emoticon
//
//  Created by Imanol on 16/5/13.
//  Copyright © 2016年 Imanol. All rights reserved.
//

import UIKit

let customCollectionViewCellIdentifer = "customCollectionViewCellIdentifer"
class EmoticonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }

    func setupUI(){
        view.addSubview(collectionV)
        view.addSubview(toolBar)
        
        //layout
        collectionV.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        let dict = ["collectionVeiw": collectionV, "toolbar": toolBar]
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionVeiw]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[toolbar]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionVeiw]-[toolbar(44)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        
        view.addConstraints(cons)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark: - lazyLoading
    private lazy var collectionV : UICollectionView = {
        let collection = UICollectionView(frame: CGRectZero, collectionViewLayout: CustomFlowLayout())
        collection.registerClass(CustomCollectionViewCell.self, forCellWithReuseIdentifier: customCollectionViewCellIdentifer)
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    private lazy var emoticonPackages : [EmoticonPackage] = EmoticonPackage.loadAllPacakges()!
    
    private lazy var toolBar : UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.backgroundColor = UIColor.whiteColor()
        var items = [UIBarButtonItem]()
        let titles = ["最近","emoji","默认","浪小花"]
        var index : Int = 0
        for title in titles
        {
            let item = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
            item.tag = index++
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolbar.items = items
        toolbar.tintColor = UIColor.blackColor()
        return toolbar
    }()
}

extension EmoticonViewController:UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(customCollectionViewCellIdentifer, forIndexPath: indexPath) as! CustomCollectionViewCell
        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.redColor() : UIColor.greenColor()
        let package = emoticonPackages[indexPath.section]
        cell.emotion = package.emoticons![indexPath.row]
        
        if(cell.emotion!.isDeleteBtn){
            cell.iconButton.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
            cell.iconButton.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: UIControlState.Highlighted)
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return emoticonPackages[section].emoticons!.count ?? 0
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return emoticonPackages.count
    }
}

//Mark: -CustomCollectionViewCell
class CustomCollectionViewCell : UICollectionViewCell
{
    var emotion : Emoticon?{
        didSet{
            if emotion?.chs != nil{
                iconButton.setImage(UIImage(contentsOfFile: (emotion?.imagePath)!), forState: UIControlState.Normal)
            }else{
                //清空，防止重用的时候会出现emoji表情跟其他表情重叠
                iconButton.setImage(nil, forState: UIControlState.Normal)
            }
            
            // 设置emoji表情
            // 注意: 加上??可以防止重用
            iconButton.setTitle(emotion?.emojiStr ?? "", forState: UIControlState.Normal)
            iconButton.titleLabel?.font = UIFont.systemFontOfSize(32)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI(){
        contentView.addSubview(iconButton)
        iconButton.backgroundColor = UIColor.whiteColor()
        iconButton.frame = CGRectInset(contentView.bounds, 4, 4)
    }

    private lazy var iconButton: UIButton = UIButton()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//Mark: -CustomFlowLayout
class CustomFlowLayout : UICollectionViewFlowLayout
{
    override func prepareLayout() {
        super.prepareLayout()
        //设置cell相关属性
        let width = (collectionView?.bounds.width)! / 7
        itemSize = CGSize(width: width, height: width)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 设置collectionview相关属性
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        
        //以下设置是为了让item 距离顶部和底部出现间隙，然后把中间原本的间隙挤掉
        // 注意:最好不要乘以0.5, 因为CGFloat不准确, 所以如果乘以0.5在iPhone4/4身上会有问题
        let y = (collectionView!.bounds.height - 3*width) * 0.45
        collectionView?.contentInset = UIEdgeInsetsMake(y, 0, y, 0)
    }
}
