//
//  Modifier+Text.swift
//  Remove-Background-Image
//
//  Created by Melih Çulha on 15.12.2023.
//

import Foundation
import SwiftUI

struct BoldTextModifier: ViewModifier {
    
    let size: CGFloat
    
    func body(content: Content) -> some View {
        content.font(FontFactory.font(font: .bold, size: size))
    }
    
}
struct MediumTextModifier: ViewModifier {
    
    let size: CGFloat
    
    func body(content: Content) -> some View {
        content.font(FontFactory.font(font: .medium, size: size))
    }
    
}

extension Text {
    
    func boldModifier(size: CGFloat) -> some View {
        self.modifier(BoldTextModifier(size: size))
    }
    
    func mediumModifier(size: CGFloat) -> some View {
        self.modifier(MediumTextModifier(size: size))
    }
}
