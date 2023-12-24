//
//  Modifier+View.swift
//  Remove-Background-Image
//
//  Created by Melih Çulha on 25.12.2023.
//

import Foundation
import SwiftUI

struct ActionButtonModifier: ViewModifier {
    
    let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 25)
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background(backgroundColor)
            .clipShape(Capsule())
    }
}

extension View {
    
    func actionButtonModifier(backgroundColor: Color) -> some View {
        self
            .modifier(ActionButtonModifier(backgroundColor: backgroundColor))
    }
    
}

