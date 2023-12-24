//
//  FontFactory.swift
//  Remove-Background-Image
//
//  Created by Melih Çulha on 24.12.2023.
//

import Foundation
import SwiftUI

enum AppFont {
   case black
   case blackItalic
   case bold
   case boldItalic
   case extraBold
   case extraBoldItalic
   case extraLight
   case extraLightItalic
   case italic
   case light
   case lightItalic
   case medium
   case mediumItalic
   case regular
   case semiBold
   case semiBoldItalic
   case thin
   case thinItalic
}

struct FontFactory {
    
    static func font(font: AppFont, size: CGFloat) -> Font {
        switch font {
        case .black:
            Font.custom("Urbanist-Black", size: size)
        case .blackItalic:
            Font.custom("Urbanist-BlackItalic", size: size)
        case .bold:
            Font.custom("Urbanist-Bold", size: size)
        case .boldItalic:
            Font.custom("Urbanist-BoldItalic", size: size)
        case .extraBold:
            Font.custom("Urbanist-ExtraBold", size: size)
        case .extraBoldItalic:
            Font.custom("Urbanist-ExtraBoldItalic", size: size)
        case .extraLight:
            Font.custom("Urbanist-ExtraLight", size: size)
        case .extraLightItalic:
            Font.custom("Urbanist-ExtraLightItalic", size: size)
        case .italic:
            Font.custom("Urbanist-Italic", size: size)
        case .light:
            Font.custom("Urbanist-Light", size: size)
        case .lightItalic:
            Font.custom("Urbanist-LightItalic", size: size)
        case .medium:
            Font.custom("Urbanist-Medium", size: size)
        case .mediumItalic:
            Font.custom("Urbanist-MediumItalic", size: size)
        case .regular:
            Font.custom("Urbanist-Regular", size: size)
        case .semiBold:
            Font.custom("Urbanist-SemiBold", size: size)
        case .semiBoldItalic:
            Font.custom("Urbanist-SemiBoldItalic", size: size)
        case .thin:
            Font.custom("Urbanist-Thin", size: size)
        case .thinItalic:
            Font.custom("Urbanist-ThinItalic", size: size)
        }
    }
}
