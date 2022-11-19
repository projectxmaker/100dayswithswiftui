//
//  RollingLogView.swift
//  Dice
//
//  Created by Pham Anh Tuan on 11/19/22.
//

import SwiftUI

struct RollingLogListView: View {
    @Environment(\.presentationMode) var presentationMode

    private var rollingLogManager = RollingLogManager.shared
    
    var body: some View {
        VStack {
            HStack(alignment: .center){
                Text("HISTORY")
                    .font(.title.bold())
                
                Spacer()
                
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
            }
            
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 20) {
                    ForEach(rollingLogManager.getLogs(), id: \.createdAt) { eachLog in
                        LogView(of: eachLog)
                            .padding(10)
                            .background(.gray.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            
        }
        .background(.black)
        .foregroundColor(.white)
    }
}

struct RollingLogListView_Previews: PreviewProvider {
    static var previews: some View {
        RollingLogListView()
    }
}
