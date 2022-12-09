//
//  FlagImagesSectionView.swift
//  GuessTheFlag
//
//  Created by Pham Anh Tuan on 12/9/22.
//

import SwiftUI

struct FlagImagesSectionView: View {
    @EnvironmentObject var vm: ContentViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            VStack {
                Text("Tap the flag of")
                    .font(.subheadline.weight(.heavy))
                    .foregroundStyle(.secondary)

                Text(vm.countries[vm.correctAnswer])
                    .font(.largeTitle.weight(.semibold))
            }

            ForEach(0..<3) { number in
                Button {
                    vm.flagTapped(number)
                } label: {
                    FlagImageView(showAnimation: vm.showFlagAnimations[number], isNotChosen: vm.flagsNotChosen[number], imageName: vm.countries[number])
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct FlagImagesSectionView_Previews: PreviewProvider {
    static var previews: some View {
        FlagImagesSectionView()
            .environmentObject(ContentViewModel())
    }
}
