//
//  RemoveBackgroundViewModel.swift
//  Remove-Background-Image
//
//  Created by Melih Çulha on 6.12.2023.
//

import Foundation
import SwiftUI

@Observable final class RemoveBackgroundViewModel {
    var image: UIImage?
    var source: ImageSourceType?
    var presentSelection: Bool = false
}

enum ImageSourceType: Identifiable {
    
    var id: Self {
        return self
    }
    case gallery
    case camera
}
