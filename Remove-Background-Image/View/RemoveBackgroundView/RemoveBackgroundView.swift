//
//  ContentView.swift
//  Remove-Background-Image
//
//  Created by Melih Çulha on 4.12.2023.
//

import SwiftUI

struct RemoveBackgroundView: View {
    
    @State private var viewModel: RemoveBackgroundViewModel = .init()
    @State var yOffset: CGFloat = 0
    
    
    var body: some View {
        ZStack {
            Color(.bg)
                .ignoresSafeArea()
            
            Divider()
                .frame(height: 2)
                .overlay(Color.white)
                .padding(.horizontal, 24)
                .offset(y: yOffset)
            
            VStack(spacing: 32) {
                
                Text("Upload a photo and we will remove the background for you")
                    .boldModifier(size: 32)
                    .foregroundStyle(.white)
                
                GeometryReader { geometry in
                    ImagesView(output: viewModel.output, image: viewModel.image, position: $viewModel.subjectPosition)
                        .onAppear {
                            self.yOffset = -(geometry.size.height/2) - 25
                            withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: true)) {
                                self.yOffset = geometry.size.height/2 - 35
                            }
                        }
                        .padding(.bottom, 10)
                }
                
                ButtonsView(removeButtonAction: self.removeBackground, uploadPhotoAction: self.presentBottomSheet)
                
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
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

