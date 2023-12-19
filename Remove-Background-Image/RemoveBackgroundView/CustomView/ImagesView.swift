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
    
    var body: some View {
        VStack {
            if let output {
                Image(uiImage: output)
                    .defaultImageModifier()
            } else if let image {
                Image(uiImage: image)
                    .defaultImageModifier()
            } else {
                AddImageView()
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 50)
    }
}

#Preview {
    ImagesView(output: nil, image: nil)
}
