//
//  UIResponder+Utilities.swift
//  HumansOfSF
//
//  Created by Jake on 1/22/17.
//  Copyright © 2017 Jake. All rights reserved.
//

import UIKit

extension UIView {
    class func toString() -> String {
        let name = NSStringFromClass(self)
        let components = name.components(separatedBy: ".")
        
        guard let classString = components.last
            else { fatalError("Error: couldn't convert class name to string.") }
        
        return classString
    }
    
    class func nibNamed(nibName: String) -> UINib {
        return UINib(nibName: nibName, bundle: Bundle.main)
    }
    
    class func nib() -> UINib {
        return nibNamed(nibName: self.toString())
    }
    
    class func instanceFromNib() -> UIView {
        
        let view = nib().instantiate(withOwner: nil, options: nil)[0] as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }
}

extension UIViewController {
    
    class func toString() -> String {
        let name = NSStringFromClass(self)
        let components = name.components(separatedBy: ".")
        
        guard let classString = components.last
            else { fatalError("Error: couldn't convert class name to string.") }
        
        return classString
    }
    
    class func nibNamed(nibName: String) -> UINib {
        return UINib(nibName: nibName, bundle: Bundle.main)
    }
    
    class func nib() -> UINib {
        return nibNamed(nibName: self.toString())
    }
    
    class func instanceFromNib() -> UIViewController {
        
        let viewController = nib().instantiate(withOwner: nil, options: nil)[0] as! UIViewController
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
    }
    
}
