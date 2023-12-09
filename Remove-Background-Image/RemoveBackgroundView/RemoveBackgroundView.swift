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
        VStack(spacing: 30) {
            
            VStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .padding(10)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(contentMode: .fit)
                        
                } else {
                    ZStack(alignment: .center) {
                        Color.gray
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Image(systemName: "photo.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.white)
                            .padding(70)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 50)
            
            Spacer()
            
            Button(action: self.presentBottomSheet) {
                Text("Upload a Photo")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.vertical, 15)
                    .padding(.horizontal, 25)
                    .background(Color.black)
                    .clipShape(Capsule())
                    .padding(.bottom, 30)
            }
            
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
    
    func presentBottomSheet() {
        self.viewModel.presentSelection = true
    }
}

#Preview {
    RemoveBackgroundView()
}
