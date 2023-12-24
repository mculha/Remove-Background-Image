//
//  ImagesView.swift
//  Remove-Background-Image
//
//  Created by Melih Çulha on 19.12.2023.
//

import SwiftUI

struct ImagesView: View {
    let output: UIImage?
    let image: UIImage?
    @Binding var position: CGPoint?
    
    var body: some View {
        VStack {
            if let output {
                GeometryReader { geometry in
                    Image(uiImage: output)
                        .defaultImageModifier()
                        .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
                        .onTapGesture { location in
                            position = CGPoint(
                                x: location.x / geometry.size.width,
                                y: location.y / geometry.size.height)
                        }
                }
            } else if let image {
                Image(uiImage: image)
                    .defaultImageModifier()
            } else {
                AddImageView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(LinearGradient(colors: [Color(.borderGradientStart), Color(.borderGradientEnd)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
        }
    }
}

#Preview {
    ImagesView(output: nil, image: nil, position: .constant(nil))
}
