//
//  ButtonsView.swift
//  Remove-Background-Image
//
//  Created by Melih Çulha on 19.12.2023.
//

import SwiftUI

struct ButtonsView: View {
    let image: UIImage?
    let removeButtonAction: () -> ()
    let uploadPhotoAction: () -> ()
    
    var body: some View {
        VStack {
            Button(action: removeButtonAction) {
                Text("Remove Background")
                    .actionButtonModifier(backgroundColor: image == nil ? Color.gray : Color.black)
            }
            .disabled(image == nil)
            
            Button(action: uploadPhotoAction) {
                Text("Upload a Photo")
                    .actionButtonModifier(backgroundColor: Color.black)
            }
        }
        .padding(.bottom, 30)
    }
}

#Preview {
    ButtonsView(image: nil, removeButtonAction: {}, uploadPhotoAction: {})
}
