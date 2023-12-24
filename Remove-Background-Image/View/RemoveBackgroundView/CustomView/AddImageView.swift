//
//  AddImageView.swift
//  Remove-Background-Image
//
//  Created by Melih Çulha on 19.12.2023.
//

import SwiftUI

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

#Preview {
    AddImageView()
}
