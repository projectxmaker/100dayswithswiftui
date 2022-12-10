//
//  ContentView.swift
//  Moonshot
//
//  Created by Pham Anh Tuan on 10/11/22.
//

import SwiftUI


struct ContentView: View {
    @StateObject var vm = ContentViewModel()
    
    let columnsOfGrid = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    let columnsOfList = [
        GridItem(.flexible(minimum: 150))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: vm.showingGrid ? columnsOfGrid : columnsOfList) {
                    ForEach(vm.missions) { mission in
                        NavigationLink {
                            MissionView(mission: mission, astronauts: vm.astronauts)
                        } label: {
                            VStack {
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .padding()
                                
                                VStack {
                                    Text(mission.displayName)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text(mission.formattedLaunchDate)
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.5))
                                }
                                .padding(.vertical)
                                .frame(maxWidth: .infinity)
                                .background(.lightBackground)
                                
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.lightBackground)
                            )
                        }
                    }
                }
                .padding([.horizontal, .bottom])
            }
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
            .toolbar {
                Button {
                    vm.showingGrid.toggle()
                } label: {
                    Text(vm.showingGrid ? "List" : "Grid")
                }

            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
