//
//  PhotoPickerSelectionView.swift
//  Remove-Background-Image
//
//  Created by Melih Çulha on 9.12.2023.
//

import SwiftUI

struct PhotoPickerSelectionView: View {
    
    @Binding var imageSource: ImageSourceType?
    @Binding var present: Bool
    
    var body: some View {
        VStack {
            Button {
                self.present = false
                self.imageSource = .gallery
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "photo.stack")
                        .foregroundStyle(.black)
                    
                    Text("Gallery")
                        .font(.system(size: 16, weight: .bold))
                        .padding(.vertical, 10)
                        .foregroundStyle(.black)
                }
            }
            
            Divider()
                .padding(.horizontal, 20)
            
            Button {
                self.present = false
                self.imageSource = .camera
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "camera.on.rectangle")
                        .foregroundStyle(.black)
                    
                    Text("Camera")
                        .font(.system(size: 16, weight: .bold))
                        .padding(.vertical, 10)
                        .foregroundStyle(.black)
                }
            }
            
        }
        .padding(.top, 20)
    }
}


#Preview {
    PhotoPickerSelectionView(imageSource: .constant(nil), present: .constant(false))
}
