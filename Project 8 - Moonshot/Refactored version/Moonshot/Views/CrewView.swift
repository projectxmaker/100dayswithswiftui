//
//  CrewView.swift
//  Moonshot
//
//  Created by Pham Anh Tuan on 10/12/22.
//

import SwiftUI

struct CrewView: View {
    let crew: [MissionViewModel.CrewMember]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(crew, id: \.role) { crewMember in
                    NavigationLink {
                        AstronautView(astronaut: crewMember.astronaut)
                    } label: {
                        HStack {
                            Image(crewMember.astronaut.id)
                                .resizable()
                                .frame(width: 104, height: 72)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .strokeBorder(.white, lineWidth: 1)
                                )

                            VStack(alignment: .leading) {
                                Text(crewMember.astronaut.name)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                Text(crewMember.role)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

struct CrewView_Previews: PreviewProvider {
    static let contentVM = ContentViewModel()
    
    static var previews: some View {
        let crewMembers:[MissionViewModel.CrewMember] = contentVM.missions[0].crew.map { member in
            if let astronaut = contentVM.astronauts[member.name] {
                return MissionViewModel.CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missing \(member.name)")
            }
        }
        CrewView(crew: crewMembers)
            .background(.darkBackground)
    }
}
