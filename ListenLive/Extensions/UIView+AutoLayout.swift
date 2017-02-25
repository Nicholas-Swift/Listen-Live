//
//  UIView+AutoLayout.swift
//  HumansOfSF
//
//  Created by Jake on 1/22/17.
//  Copyright © 2017 Jake. All rights reserved.
//

import UIKit

extension UIView {
    class func newAutoLayoutView() -> Self {
        let view = self.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }
}
