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
        ZStack {
            Color(.bg)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                
                Text("Upload a photo and we will remove the background for you")
                    .boldModifier(size: 32)
                    .foregroundStyle(.white)
                
                ImagesView(output: viewModel.output, image: viewModel.image, position: $viewModel.subjectPosition)
                
                Spacer()
                
                ButtonsView(image: viewModel.image, removeButtonAction: self.removeBackground, uploadPhotoAction: self.presentBottomSheet)
                
            }
            .sheet(isPresented: $viewModel.presentSelection) {
                PhotoPickerSelectionView(imageSource: $viewModel.source, present: $viewModel.presentSelection)
                    .presentationDetents([.height(90)])
            }
            .fullScreenCover(item: $viewModel.source) { source in
                switch source {
                case .camera:
                    ImagePickerCamera(image: $viewModel.image)
                        .background(.black)
                case .gallery:
                    ImagePickerGallery(image: $viewModel.image)
                                    .background(.white)
                }
            }
        }
    }
    
    func presentBottomSheet() {
        self.viewModel.presentSelection = true
    }
    
    func removeBackground() {
        viewModel.removeBackground()
    }
}

#Preview {
    RemoveBackgroundView()
}

