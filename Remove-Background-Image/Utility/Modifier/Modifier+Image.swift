//
//  Modifier+Image.swift
//  Remove-Background-Image
//
//  Created by Melih Çulha on 15.12.2023.
//

import Foundation
import SwiftUI

extension Image {
    
    func defaultImageModifier() -> some View{
        self
            .resizable()
            .padding(10)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(contentMode: .fit)
    }
    
}
