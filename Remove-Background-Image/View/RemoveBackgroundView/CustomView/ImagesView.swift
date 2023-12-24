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
    
    @State private var outputViewSize = CGSize.zero
    @Binding var position: CGPoint?
    
    var body: some View {
        VStack {
            if let output {
                GeometryReader { geometry in
                    
                    Image(uiImage: output)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .background(Color.blue)
                        .onAppear {
                            outputViewSize = geometry.size
                        }
                        .onTapGesture { location in
                            // Normalize the tap position.
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
    }
}

#Preview {
    ImagesView(output: nil, image: nil, position: .constant(nil))
}
