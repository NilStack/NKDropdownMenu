//
//  ViewController.swift
//  NKDropdownMenuDemo
//
//  Created by Peng on 11/3/15.
//  Copyright © 2015 Peng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let items = ["Most Popular", "Latest", "Trending", "Nearest", "Top Picks"]
        
        let dropdownMenu: NKDropdownMenu = NKDropdownMenu(items: items)
        
        dropdownMenu.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dropdownMenu)
        
        self.view.backgroundColor = UIColor(red: 244.0 / 255.0, green: 244.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
    }

  
}

