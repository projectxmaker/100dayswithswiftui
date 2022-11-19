//
//  RollingLogView.swift
//  Dice
//
//  Created by Pham Anh Tuan on 11/19/22.
//

import SwiftUI

struct RollingLogListView: View {
    private var rollingLogManager = RollingLogManager.shared
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 20) {
                ForEach(rollingLogManager.getLogs(), id: \.createdAt) { eachLog in
                    LogView(of: eachLog)
                }
            }
            .padding()
        }
        .foregroundColor(.white)
        .background(.black)
    }
}

struct RollingLogListView_Previews: PreviewProvider {
    static var previews: some View {
        RollingLogListView()
    }
}
