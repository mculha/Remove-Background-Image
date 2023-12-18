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
            
            ImagesView(output: viewModel.output, image: viewModel.image)
            
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

struct AddImageView: View {
    var body: some View {
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
