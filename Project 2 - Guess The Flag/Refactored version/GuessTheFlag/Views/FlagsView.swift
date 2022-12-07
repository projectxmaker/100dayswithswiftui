//
//  FlagsView.swift
//  GuessTheFlag
//
//  Created by Pham Anh Tuan on 12/7/22.
//

import SwiftUI

struct FlagsView: View {
    @EnvironmentObject var contentVM: ContentViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            VStack {
                Text("Tap the flag of")
                    .font(.subheadline.weight(.heavy))
                    .foregroundStyle(.secondary)

                Text(contentVM.correctAnswerTitle)
                    .font(.largeTitle.weight(.semibold))
            }

            ForEach(0..<3) { number in
                Button {
                    contentVM.flagTapped(number)
                } label: {
                    FlagImageView(imageName: contentVM.countries[number].imageName)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct FlagsView_Previews: PreviewProvider {
    static var previews: some View {
        FlagsView()
            .environmentObject(ContentViewModel())
    }
}
