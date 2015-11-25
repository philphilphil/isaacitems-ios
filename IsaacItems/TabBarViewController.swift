//
//  TabBarViewController.swift
//  IsaacItems
//
//  Created by Philipp Baum on 05/11/15.
//  Copyright © 2015 Thinkcoding. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set TabBarItem Images and greyedout images
        for item in self.tabBar.items! {
            if(item.title == "Items") {
                let imgActive = UIImage(named: "items_active")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                let imgPassive = UIImage(named: "items_inactive")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                item.selectedImage = imgActive;
                item.image = imgPassive;
            }else if (item.title == "Trinkets") {
                let imgActive = UIImage(named: "trinkets_active")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                let imgPassive = UIImage(named: "trinkets_inactive")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                item.selectedImage = imgActive;
                item.image = imgPassive;
            }else if (item.title == "Cards/Runes") {
                let imgActive = UIImage(named: "cards_active")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                let imgPassive = UIImage(named: "cards_inactive")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                item.selectedImage = imgActive;
                item.image = imgPassive;
            }else if (item.title == "Tracker") {
                let imgActive = UIImage(named: "run_active")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                let imgPassive = UIImage(named: "run_inactive")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                item.selectedImage = imgActive;
                item.image = imgPassive;
            }

        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
