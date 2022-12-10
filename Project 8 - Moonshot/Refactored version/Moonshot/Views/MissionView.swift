//
//  MissionView.swift
//  Moonshot
//
//  Created by Pham Anh Tuan on 10/12/22.
//

import SwiftUI

struct MissionView: View {

    @StateObject var missionVM: MissionViewModel

    init(mission: Mission, astronauts: [String: Astronaut]) {
        _missionVM = StateObject(wrappedValue: MissionViewModel(mission: mission, astronauts: astronauts))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Image(missionVM.mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.6)
                        .padding(.top)
                    
                    Text(missionVM.mission.formattedLaunchDate)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                    
                    VStack(alignment: .leading) {
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(.lightBackground)
                            .padding(.vertical)
                        
                        Text("Mission Highlights")
                            .font(.title.bold())
                            .padding(.bottom, 5)
                        
                        Text(missionVM.mission.description)
                        
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(.lightBackground)
                            .padding(.vertical)
                        
                        Text("Crew")
                            .font(.title.bold())
                            .padding(.bottom, 5)
                    }
                    .padding(.horizontal)
                    
                    CrewView(crew: missionVM.crew)
                }
                .padding(.bottom)
            }
        }
        .navigationTitle(missionVM.mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

    static var previews: some View {
        NavigationView {
            MissionView(mission: missions[0], astronauts: astronauts)
                .preferredColorScheme(.dark)
        }
    }
}
