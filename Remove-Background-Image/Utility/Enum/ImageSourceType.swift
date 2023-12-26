//
//  ImageSourceType.swift
//  Remove-Background-Image
//
//  Created by Melih Çulha on 26.12.2023.
//

import Foundation

enum ImageSourceType: Identifiable {
    
    var id: Self {
        return self
    }
    case gallery
    case camera
}
