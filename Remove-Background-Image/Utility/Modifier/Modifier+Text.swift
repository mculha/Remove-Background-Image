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

struct BoldTextModifier: ViewModifier {
    
    let size: CGFloat
    
    func body(content: Content) -> some View {
        content.font(FontFactory.font(font: .bold, size: size))
    }
    
}

extension Text {
    
    func actionButtonModifier(backgroundColor: Color) -> some View {
        self
            .modifier(ActionButtonModifier(backgroundColor: backgroundColor))
    }
    
    func boldModifier(size: CGFloat) -> some View {
        self.modifier(BoldTextModifier(size: size))
    }
}
