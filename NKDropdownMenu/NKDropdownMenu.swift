//
//  NKDropdownMenu.swift
//  NKDropdownMenuDemo
//
//  Created by Peng on 11/3/15.
//  Copyright © 2015 Peng. All rights reserved.
//

import UIKit

func delay(seconds seconds: Double, completion:()->()) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
    
    dispatch_after(popTime, dispatch_get_main_queue()) {
        completion()
    }
}


class NKDropdownMenu: UIView {
    
    let statusbarHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
    
    var didSelectItemAtIndexHandler: ((indexPath: Int) -> ())?
    
    private var navigationController: UINavigationController?
    private var configuration = NKDropdownMenuConfiguration()
    private var items: [String]!
    private var menuWrapper: UIView!
    private var backgroundView: UIView!
    private var hamburgerView: NKHamburgerView!
    private var linesView: NKDropdownMenuLinesView!
    private var menuView: NKDropdownMenuTableView!

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(items: [String]) {
        
        // Navigation controller
        self.navigationController = UIApplication.sharedApplication().keyWindow?.rootViewController?.topMostViewController?.navigationController
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // init left bar button item
        let hamburgerMenuFrame = CGRectMake(0.0, 0.0, configuration.barButtonItemWidth, configuration.barButtonItemHeight)
        super.init(frame:hamburgerMenuFrame)
        self.hamburgerView = NKHamburgerView(frame: hamburgerMenuFrame)
        addSubview(self.hamburgerView)
    
        backgroundColor = .clearColor()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("showMenu"))
        addGestureRecognizer(tapGesture)
        
        self.items = items
        
        let window = UIApplication.sharedApplication().keyWindow!
        let menuWrapperBounds = window.bounds
        
        // Set up DropdownMenu
        self.menuWrapper = UIView(frame: CGRectMake(menuWrapperBounds.origin.x, 0, menuWrapperBounds.width, menuWrapperBounds.height))
        self.menuWrapper.clipsToBounds = true
        self.menuWrapper.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        
        // Init background view (under table view)
        self.backgroundView = UIView(frame: menuWrapperBounds)

        self.backgroundView.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        self.menuWrapper.addSubview(self.backgroundView)
        
        let menuViewFrame = CGRectMake(0.0, self.statusbarHeight,  menuWrapperBounds.width, configuration.menuCellHeight * CGFloat(self.items.count))
        self.menuView = NKDropdownMenuTableView(frame: menuViewFrame, items: self.items, configuration: NKDropdownMenuConfiguration())
        self.menuView.selectRowAtIndexPathHandler = { (indexPath: Int) -> () in
            
            if let didSelecthandler = self.didSelectItemAtIndexHandler {
                didSelecthandler(indexPath: indexPath)
            }
            
            self.hideMenu()
        }
        self.menuWrapper.addSubview(menuView)
        
        self.linesView = NKDropdownMenuLinesView(frame: CGRectMake(0, statusbarHeight, menuWrapperBounds.width, configuration.menuCellHeight))
        self.menuWrapper.addSubview(linesView)

        window.addSubview(self.menuWrapper)
        
        // By default, hide menu view
        self.menuWrapper.hidden = true
    }
    
    func showMenu() {
        // hide hamburger lines
        self.hamburgerView.hidden = true
        
        // hide menu table view at first
        self.menuView.hidden = true
        
        // Visible menu view
        self.menuWrapper.hidden = false
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: [], animations: { () -> Void in
            
            self.linesView.topLine.frame.origin.x = 0.0
            self.linesView.middleLine.frame.origin.x = 0.0
            self.linesView.bottomLine.frame.origin.x = 0.0
            
            self.linesView.topLine.frame.size.width = self.linesView.frame.size.width
            self.linesView.middleLine.frame.size.width = self.linesView.frame.size.width
            self.linesView.bottomLine.frame.size.width = self.linesView.frame.size.width
            
            for hiddenLine in self.linesView.hiddenLines {
                hiddenLine.frame.origin.x = 0.0
                hiddenLine.frame.size.width = self.linesView.frame.size.width
            }
            
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.5, options: [], animations: { () -> Void in
            
            self.linesView.frame.size.height = 3 * self.configuration.menuCellHeight
            
            self.linesView.topLine.frame.origin.y = self.configuration.menuCellHeight - 1.0 // seperator height
            self.linesView.middleLine.frame.origin.y = 2 * self.configuration.menuCellHeight - 1.0
            self.linesView.bottomLine.frame.origin.y = 3 * self.configuration.menuCellHeight - 1.0
            
            for (index, hiddenLine) in self.linesView.hiddenLines.enumerate() {
                hiddenLine.frame.origin.y = CGFloat(4+index)*self.configuration.menuCellHeight - 1.0
            }
           
            }) { _ in
                
                self.menuView.hidden = false
                self.menuView.animate = true
                self.menuView.reloadData()
                
                // workaround to cover the flicer when reloadData()
                delay(seconds: 1.0, completion: { () -> () in
                    self.linesView.alpha = 0.0
                  
                })
                
            }
    }
    
    func hideMenu() {
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            for cell in self.menuView.visibleCells {
                
                cell.frame.origin.x -= 10
                cell.textLabel?.alpha = 0
                
            }
        
            }, completion: nil)
      
        UIView.animateKeyframesWithDuration(0.5, delay: 1.0, options: [], animations: { () -> Void in
            
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.01, animations: { () -> Void in
                self.menuView.alpha = 0.0
                self.linesView.alpha = 1.0
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.01, relativeDuration: 1, animations: { () -> Void in
                
                self.linesView.topLine.frame = CGRectMake(16.0, 7.0 + self.configuration.barButtonItemHeight / 4, self.configuration.barButtonItemWidth, 1.0)
                self.linesView.middleLine.frame = CGRectMake(16.0, 7.0 +  self.configuration.barButtonItemHeight / 2, self.configuration.barButtonItemWidth, 1.0)
                self.linesView.bottomLine.frame = CGRectMake(16.0, 7.0 +  self.configuration.barButtonItemHeight*3 / 4, self.configuration.barButtonItemWidth, 1.0)
                
                for hiddenLine in self.linesView.hiddenLines {
                    hiddenLine.frame = CGRectMake(16.0, 7.0 +  self.configuration.barButtonItemHeight*3 / 4, self.configuration.barButtonItemWidth, 1.0)
                }
                
            })
            
            }, completion: {_ in
                self.hamburgerView.hidden = false
                self.menuView.alpha = 1.0
                self.menuWrapper.hidden = true
        })
        
    }
}

public class NKDropdownMenuConfiguration {
    
    var barButtonItemWidth: CGFloat!
    var barButtonItemHeight: CGFloat!
    
    var lineColor: UIColor?
    
    var menuCellHeight: CGFloat! {
        didSet {
            if menuCellHeight < barButtonItemHeight / 4.0 {
                print("menuCellHeight can't be less than barButtonItemHeight/4.0")
                menuCellHeight = 44.0
            }
            
        }

    }
    var menuCellBackgroundColor: UIColor?
    var menuCellTextLabelColor: UIColor?
    var menuCellTextLabelFont: UIFont!
    var menuCellSelectionColor: UIColor?
    
    init() {
        self.defaultValue()
    }
    
    func defaultValue() {
        
        self.barButtonItemWidth = 30.0
        self.barButtonItemHeight = 30.0
        self.menuCellHeight = 44.0
        self.menuCellBackgroundColor = UIColor.whiteColor()
        self.lineColor = UIColor.grayColor()
        self.menuCellTextLabelColor = UIColor.blackColor()
        self.menuCellTextLabelFont = UIFont.systemFontOfSize(17.0)
        self.menuCellSelectionColor = UIColor.grayColor()
        
    }
}

class NKHamburgerView: UIView {
    
    var configuration = NKDropdownMenuConfiguration()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let topLine: UIView = UIView(frame: CGRectMake(0, bounds.size.height / 4, bounds.size.width, 1.0))
        topLine.backgroundColor = configuration.lineColor
        addSubview(topLine)
        
        let middleLine: UIView = UIView(frame: CGRectMake(0, bounds.size.height / 2, bounds.size.width, 1.0))
        middleLine.backgroundColor = configuration.lineColor
        addSubview(middleLine)
        
        let bottomLine: UIView = UIView(frame: CGRectMake(0, bounds.size.height*3 / 4, bounds.size.width, 1.0))
        bottomLine.backgroundColor = configuration.lineColor
        addSubview(bottomLine)
        
    }
    
}

class NKDropdownMenuLinesView: UIView {
    
    let topLine: UIView = UIView()
    let middleLine: UIView = UIView()
    let bottomLine: UIView = UIView()
    
    var hiddenLines: [UIView] = [UIView]()
    var configuration = NKDropdownMenuConfiguration()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        topLine.frame = CGRectMake(16.0, 7.0 + configuration.barButtonItemHeight / 4, configuration.barButtonItemWidth, 1.0)
        topLine.backgroundColor = configuration.lineColor
        self.addSubview(topLine)
        
        middleLine.frame = CGRectMake(16.0, 7.0 +  configuration.barButtonItemHeight / 2, configuration.barButtonItemWidth, 1.0)
        middleLine.backgroundColor = configuration.lineColor
        self.addSubview(middleLine)
        
        bottomLine.frame = CGRectMake(16.0, 7.0 +  configuration.barButtonItemHeight*3 / 4, configuration.barButtonItemWidth, 1.0)
        bottomLine.backgroundColor = configuration.lineColor
        self.addSubview(bottomLine)
        
        let hiddenLine1: UIView = UIView(frame: CGRectMake(16.0, 7.0 +  configuration.barButtonItemHeight*3 / 4, configuration.barButtonItemWidth, 1.0))
        hiddenLine1.backgroundColor = configuration.lineColor
        hiddenLines.append(hiddenLine1)
        self.addSubview(hiddenLine1)
        
        let hiddenLine2: UIView = UIView(frame: CGRectMake(16.0, 7.0 +  configuration.barButtonItemHeight*3 / 4, configuration.barButtonItemWidth, 1.0))
        hiddenLine2.backgroundColor = configuration.lineColor
        hiddenLines.append(hiddenLine2)
        self.addSubview(hiddenLine2)
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NKDropdownMenuTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    let statusbarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
    let sceenWidth = UIScreen.mainScreen().bounds.size.width
    
    var configuration: NKDropdownMenuConfiguration!
    var selectRowAtIndexPathHandler: ((indexPath: Int) -> ())?
    
    var animate: Bool = false
    
    // Private properties
    private var items: [String]!
    private var selectedIndexPath: Int!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(frame: CGRect, items: [String], configuration: NKDropdownMenuConfiguration) {
        super.init(frame: frame, style: UITableViewStyle.Plain)
        
        self.items = items
        self.selectedIndexPath = 0
        self.configuration = configuration
        
        // Setup table view
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.clearColor()
        self.separatorStyle = UITableViewCellSeparatorStyle.None
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
    }
    
    // Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.animate {
            return self.items.count

        } else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.configuration.menuCellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = NKDropdownMenuViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell", configuration: self.configuration)
        cell.textLabel?.text = self.items[indexPath.row]
        cell.textLabel?.font = self.configuration.menuCellTextLabelFont
        cell.textLabel?.textColor = self.configuration.menuCellTextLabelColor
        cell.selectionStyle = .None
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
        
        if animate {
            
            cell.alpha = 0
            
            let cellOriginalX = cell.frame.origin.x
            cell.frame.origin.x -= 10
            cell.textLabel?.alpha = 0

        
            UIView.animateWithDuration(1.0, delay: 0.0, options: [], animations: { () -> Void in
            
                cell.alpha = 1.0
            }, completion: nil)
        
            UIView.animateWithDuration(1.0, delay:1.0+Double(indexPath.row)*0.5, options: [], animations: { () -> Void in
            
                cell.textLabel?.alpha = 1.0
                cell.frame.origin.x = cellOriginalX
            
            
            }, completion: nil)
        
        }
    }
    
    // Table view delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath.row
        self.selectRowAtIndexPathHandler!(indexPath: indexPath.row)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? NKDropdownMenuViewCell
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            cell?.contentView.backgroundColor = self.configuration.menuCellSelectionColor
            }) { _ in
                cell?.contentView.backgroundColor = UIColor.clearColor()
        }
        
    }

}

class NKDropdownMenuViewCell: UITableViewCell {
    
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    
    var configuration: NKDropdownMenuConfiguration!
    var seperator: UIView!
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, configuration: NKDropdownMenuConfiguration) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configuration = configuration
        
        self.seperator = UIView(frame: CGRectMake(0.0, self.configuration.menuCellHeight - 1.0, screenWidth + 10.0, 1.0))
        
        self.seperator.backgroundColor = UIColor.grayColor()
        self.addSubview(seperator)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIViewController {
    // Get ViewController in top present level
    var topPresentedViewController: UIViewController? {
        var target: UIViewController? = self
        while (target?.presentedViewController != nil) {
            target = target?.presentedViewController
        }
        return target
    }
    
    // Get top VisibleViewController from ViewController stack in same present level.
    // It should be visibleViewController if self is a UINavigationController instance
    // It should be selectedViewController if self is a UITabBarController instance
    var topVisibleViewController: UIViewController? {
        if let navigation = self as? UINavigationController {
            if let visibleViewController = navigation.visibleViewController {
                return visibleViewController.topVisibleViewController
            }
        }
        if let tab = self as? UITabBarController {
            if let selectedViewController = tab.selectedViewController {
                return selectedViewController.topVisibleViewController
            }
        }
        return self
    }
    
    // Combine both topPresentedViewController and topVisibleViewController methods, to get top visible viewcontroller in top present level
    var topMostViewController: UIViewController? {
        return self.topPresentedViewController?.topVisibleViewController
    }
}
