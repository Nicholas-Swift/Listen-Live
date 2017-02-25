//
//  UIImage+Color.swift
//  ListenLive
//
//  Created by Nicholas Swift on 2/25/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func withColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
}
