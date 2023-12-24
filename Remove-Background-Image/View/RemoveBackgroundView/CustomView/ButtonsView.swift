//
//  ButtonsView.swift
//  Remove-Background-Image
//
//  Created by Melih Çulha on 19.12.2023.
//

import SwiftUI

struct ButtonsView: View {
    let removeButtonAction: () -> ()
    let uploadPhotoAction: () -> ()
    
    var body: some View {
        VStack(spacing: 24) {
            Button(action: uploadPhotoAction) {
                HStack(spacing: 16) {
                    Image(.uploadImageCamera)
                        .frame(width: 20, height: 20)
                    
                    Text("Upload a Photo")
                        .boldModifier(size: 16)
                        .foregroundStyle(Color.white)
                }
                .actionButtonModifier(backgroundColor: Color(.uploadPhotoBG))
            }
            
            Divider()
                .background(Color(.uploadPhotoBG))
            
            Button(action: removeButtonAction) {
                Text("Remove Background")
                    .boldModifier(size: 16)
                    .foregroundStyle(Color.white)
                    .actionButtonModifier(backgroundColor: Color(.removeBG))
            }
            
        }
    }
}

#Preview {
    ButtonsView(removeButtonAction: {}, uploadPhotoAction: {})
}
