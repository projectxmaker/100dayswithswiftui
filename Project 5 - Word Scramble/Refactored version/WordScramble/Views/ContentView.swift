//
//  ContentView.swift
//  WordScramble
//
//  Created by Pham Anh Tuan on 9/30/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = ContentViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $vm.newWord)
                        .textInputAutocapitalization(.never)
                }

                UsedWordsSectionView()
            }
            .navigationTitle(vm.rootWord)
            .onSubmit {
                vm.addNewWord()
            }
            .task {
                vm.startGame()
            }
            .animation(.default, value: vm.usedWords)
            .animation(.default, value: vm.totalLetters)
            .alert(vm.errorTitle, isPresented: $vm.showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(vm.errorMessage)
            }
            .toolbar {
                Button("Restart") {
                    vm.restartGame()
                }
            }
        }
        .environmentObject(vm)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environment(\.locale, Locale(identifier: "vi_VN"))
        }
    }
}
