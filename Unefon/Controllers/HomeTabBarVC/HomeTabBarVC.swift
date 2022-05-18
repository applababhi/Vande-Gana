//
//  BaseTabbarController.swift
//  ZertuNew
//
//  Created by Shalini Sharma on 19/11/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class HomeTabBarVC: UITabBarController, UITabBarControllerDelegate {
    
    let gradientlayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        self.selectedIndex = 0
        
        // To set the background colour of TabBar, first set it's isTranslucent to false then set color, same for set Image
        self.tabBar.isTranslucent = false
        //   self.tabBar.backgroundColor = UIColor.red
        //   setGradientBackground(colorOne: .yellow, colorTwo: .red)        
        setGradientBackground(colorOne: UIColor(named: "App_LightBlack")!, colorTwo: UIColor(named: "App_DarkBlack")!)
        
        
        UITabBar.appearance().tintColor = UIColor(named: "App_Blue") // selected Tab Color
        self.tabBar.unselectedItemTintColor = UIColor(named: "App_LightGrey") // UnSelected Tab Color
        
        // change font for TabItem
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: CustomFont.regular, size: 12)!], for: .normal)
        
        // for equal spacing between Tabs
        tabBar.itemPositioning = .fill
        
        // from below 2 lines we can remove the LINE which comes on top of TabBar
        //   UITabBar.appearance().layer.borderWidth = 0.0
        //    UITabBar.appearance().clipsToBounds = true
        
        // setUpTitleInBottomBar()
        
        /*
         1: Activaciones_NewVC_ID
         2: Rankings_NewVC_ID
         3: Recompensas_NewVC
         4: Anuncios_NewVC_ID
         5: EmailSupport_NewVC_ID
         */
    }
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor)  {
        gradientlayer.frame = tabBar.bounds
        gradientlayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientlayer.locations = [0, 1]
        gradientlayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientlayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        self.tabBar.layer.insertSublayer(gradientlayer, at: 0)
    }
    
    func setUpTitleInBottomBar()
    {
        // in this app, we are basically moving titles very down, which ll not be visible, and only appear on Tap, as 3rd party Lib, on selection raise the imaage and Title
        
        let strModel = getDeviceModel()
        if strModel == "iPhone XS"
        {
            UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 17.5) // Change Position of title
        }
        else if strModel == "iPhone Max"
        {
            UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 17.5) // Change Position of title
        }
        else if strModel == "iPhone 6+"
        {
            UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 20) // Change Position of title
        }
        else if strModel == "iPhone 6"
        {
            UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 20) // Change Position of title
        }
        else if strModel == "iPhone 5"
        {
            UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 22) // Change Position of title
        }
        else if strModel == "iPhone XR"
        {
            UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 17.5) // Change Position of title
        }
    }
    
    //MARK: Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool
    {
        
        if viewController is UINavigationController
        {
            // let vc:UIViewController = ((viewController as? UINavigationController)?.viewControllers.first!)!
        }
        return true;
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        k_SelectedTabBarIndex = tabBarController.selectedIndex
    }
}

extension HomeTabBarVC
{
    // MARK: - Lock Orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return .portrait
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        print("--> iPAD Screen Orientation")
        if UIDevice.current.orientation.isLandscape {
            print("landscape")
        } else {
            print("portrait")
        }
    }
}
