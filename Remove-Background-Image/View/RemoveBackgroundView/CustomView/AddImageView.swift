//
//  AddImageView.swift
//  Remove-Background-Image
//
//  Created by Melih Çulha on 19.12.2023.
//

import SwiftUI

struct AddImageView: View {
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack(spacing: 16) {
                Image(.addImagePlaceholder)
                    .resizable()
                    .frame(width: 28, height: 28)
                
                Text("No Image Selected")
                    .mediumModifier(size: 16)
                    .foregroundStyle(Color(.addImageText))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    AddImageView()
}
