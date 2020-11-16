//  UIViewController+Extension.swift
//  MovieFlix
//  Created by Ranjeet Raushan on 22/06/2020.
//  Copyright © 2020 Ranjeet Raushan. All rights reserved.

import Foundation
import UIKit

extension UIViewController {
    
    // Not using static as it wont be possible to override to provide custom storyboardID then
    class var storyboardID : String {
        
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
    
    class func loadFromNib<T: UIViewController>() -> T {
        return T(nibName: String(describing: self), bundle: nil)
    }
}


enum AppStoryboard : String {
    case Main
    case PreLogin
    case OnBoarding
    case Brand
    case Influencer
    case Settings
    case Inbox
    case Proposal
    case Contract
    case Campaign
    
    var instance : UIStoryboard {
        
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        
        return instance.instantiateInitialViewController()
    }
} // USAGE : let storyboard = AppStoryboard.Main.instance
