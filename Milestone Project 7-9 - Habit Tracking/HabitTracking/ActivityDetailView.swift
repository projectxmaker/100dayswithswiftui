//
//  ActivityDetailView.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/15/22.
//

import SwiftUI

struct ActivityDetailView: View {
    @State private var counter = 0
    
    func increaseActivityCounting() {
        counter += 1
    }
    
    var body: some View {
        VStack {
            Text("Counting \(counter)")
            Button {
                increaseActivityCounting()
            } label: {
                Text("+ 1")
                    .foregroundColor(Color.white)
                    .frame(width: 100, height: 40)
                    .background(Capsule())
            }
        }
        .navigationTitle("Activity Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ActivityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailView()
    }
}
