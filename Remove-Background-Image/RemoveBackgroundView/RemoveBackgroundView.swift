//
//  ContentView.swift
//  Remove-Background-Image
//
//  Created by Melih Çulha on 4.12.2023.
//

import SwiftUI

struct RemoveBackgroundView: View {
    
    @State private var viewModel: RemoveBackgroundViewModel = .init()
    
    var body: some View {
        VStack {
            Text("Tap and choose an Image")
                .font(.system(size: 20, weight: .bold))
                .onTapGesture {
                    self.viewModel.presentImagePicker = true
                }
        }
        .padding()
        .fullScreenCover(isPresented: $viewModel.presentImagePicker) {
            ImagePickerCamera(image: $viewModel.image)
                .background(.black)
        }
    }
}

#Preview {
    RemoveBackgroundView()
}
