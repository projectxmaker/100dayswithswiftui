//
//  HTTextField.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/16/22.
//

import SwiftUI

struct HTTextField: View {
    var title: String
    var prompt: String
    var iconSystemName: String = "figure.walk"

    @Binding var value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                HStack {
                    Image(systemName: iconSystemName)
                    TextField(title, text: $value)
                    Spacer()
                }
                .padding(Edge.Set.leading, 10)
            }
            .frame(height: 40)
            .border(.gray, width: 0.5)
            .clipShape(RoundedRectangle(cornerRadius: 2))
            
            Text(prompt)
                .fixedSize(horizontal: false, vertical: true)
                .font(.caption)
        }
    }
}
