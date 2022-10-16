//
//  HTTextField.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/16/22.
//

import SwiftUI

struct HTTextField: View {
    @Binding var value: String
    var prompt: String
    
    var title: String
    
    var body: some View {
        TextField(title, text: $value)
        Text(prompt)
            .fixedSize(horizontal: false, vertical: true)
            .font(.caption)
    }
}
