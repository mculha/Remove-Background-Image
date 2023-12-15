//
//  Modifier+Text.swift
//  Remove-Background-Image
//
//  Created by Melih Çulha on 15.12.2023.
//

import Foundation
import SwiftUI

struct ActionButtonModifier: ViewModifier {
    
    let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .bold))
            .foregroundStyle(.white)
            .padding(.vertical, 15)
            .padding(.horizontal, 25)
            .background(backgroundColor)
            .clipShape(Capsule())
    }
    
    
}


extension Text {
    
    func actionButtonModifier(backgroundColor: Color) -> some View {
        self
            .modifier(ActionButtonModifier(backgroundColor: backgroundColor))
    }
}
