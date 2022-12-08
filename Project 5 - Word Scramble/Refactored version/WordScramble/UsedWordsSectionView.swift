//
//  UsedWordsSectionView.swift
//  WordScramble
//
//  Created by Pham Anh Tuan on 12/8/22.
//

import SwiftUI

struct UsedWordsSectionView: View {
    @EnvironmentObject var vm: ContentViewModel
    
    var body: some View {
        Section ("Score: \(vm.usedWords.count) words | \(vm.totalLetters) letters") {
            ForEach(vm.usedWords, id: \.self) { word in
                HStack {
                    Image(systemName: "\(word.count).circle")
                    Text(word)
                }
            }
        }
    }
}

struct UsedWordsSectionView_Previews: PreviewProvider {
    struct SampleView: View {
        @StateObject var vm = ContentViewModel()
        
        var body: some View {
            Form {
                UsedWordsSectionView()
            }
            .task {
                vm.startGame()
            }
            .environmentObject(vm)
        }
    }
    
    static var previews: some View {
        SampleView()
    }
}
