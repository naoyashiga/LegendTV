//
//  ContainerViewController.swift
//  Gaki
//
//  Created by naoyashiga on 2015/07/25.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, KikakuCollectionViewControllerDelegate {
    var pageMenu : CAPSPageMenu?
    var controllerArray : [BaseCollectionViewController] = []
    
    private struct NibNameSet {
        static let homeVC = "HomeCollectionViewController"
        static let kikakuVC = "KikakuCollectionViewController"
        static let favVC = "FavoriteCollectionViewController"
        static let historyVC = "HistoryCollectionViewController"
        static let settingVC = "SettingCollectionViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = HomeCollectionViewController(nibName: NibNameSet.homeVC, bundle: nil)
        let kikakuVC = KikakuCollectionViewController(nibName: NibNameSet.kikakuVC, bundle: nil)
        let favVC = FavoriteCollectionViewController(nibName: NibNameSet.favVC, bundle: nil)
        let historyVC = HistoryCollectionViewController(nibName: NibNameSet.historyVC, bundle: nil)
        let settingVC = SettingCollectionViewController(nibName: NibNameSet.settingVC, bundle: nil)
        
        
        homeVC.title = "ピックアップ"
        kikakuVC.title = "企画"
        favVC.title = "お気に入り"
        historyVC.title = "履歴"
        settingVC.title = "その他"
        
        kikakuVC.kikakuDelegate = self
        
        controllerArray.append(homeVC)
        controllerArray.append(kikakuVC)
        controllerArray.append(favVC)
        controllerArray.append(historyVC)
        controllerArray.append(settingVC)
        
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor.scrollMenuBackgroundColor()),
            .ViewBackgroundColor(UIColor.viewBackgroundColor()),
            .SelectionIndicatorColor(UIColor.selectionIndicatorColor()),
//            .BottomMenuHairlineColor(UIColor.bottomMenuHairlineColor()),
            .SelectedMenuItemLabelColor(UIColor.selectedMenuItemLabelColor()),
            .UnselectedMenuItemLabelColor(UIColor.unselectedMenuItemLabelColor()),
            .SelectionIndicatorHeight(2.0),
            .MenuItemFont(UIFont(name: FontSet.bold, size: 12.0)!),
            .MenuHeight(30.0),
            .MenuItemWidth(80.0),
            .MenuMargin(0.0),
//            "useMenuLikeSegmentedControl": true,
            .MenuItemSeparatorRoundEdges(true),
//            "enableHorizontalBounce": true,
//            "scrollAnimationDurationOnMenuItemTap": 300,
            .CenterMenuItems(true)]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, view.frame.width, view.frame.height), pageMenuOptions: parameters)
        
        if let pageMenu = pageMenu {
            view.addSubview(pageMenu.view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: KikakuCollectionViewControllerDelegate
    func transitionViewController(ToVC ToVC: BaseTableViewController) {
        navigationController?.pushViewController(ToVC, animated: true)
    }
}
