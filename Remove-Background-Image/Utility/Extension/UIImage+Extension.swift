//
//  UIImage+Extension.swift
//  Remove-Background-Image
//
//  Created by Melih Çulha on 9.01.2024.
//

import Foundation
import UIKit

extension UIImage {
    
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        self.draw(in: CGRectMake(0, 0, self.size.width, self.size.height))
        
        let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return normalizedImage;
        
    }
    
}
