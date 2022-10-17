//
//  HTTextField.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/16/22.
//

import SwiftUI

enum TextInputType {
    case textField
    case textEditor
}

struct HTTextInput: View {
    var title: String
    var prompt: String
    var iconSystemName: String = "figure.walk"
    var textInputType = TextInputType.textField

    @Binding var value: String
    @FocusState private var focusOnTextEditor: Bool
    
    func getFrameHeight() -> CGFloat {
        switch textInputType {
        case .textField:
            return 40
        case .textEditor:
            return 100
        }
    }
    
    func getIconPaddingTop() -> CGFloat {
        switch textInputType {
        case .textField:
            return 0
        case .textEditor:
            return 10
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                HStack(alignment: .top) {
                    Image(systemName: iconSystemName)
                        .padding(Edge.Set.top, getIconPaddingTop())
                    
                    switch textInputType {
                    case .textField:
                        TextField(title, text: $value)
                            .padding(Edge.Set.leading, 5)
                    case .textEditor:
                        TextEditor(text: $value)
                            .overlay(alignment: .top) {
                                HStack(alignment: .top) {
                                    value.isEmpty ? Text(title) : Text("")
                                    Spacer()
                                }
                                .foregroundColor(Color.primary.opacity(0.25))
                                .padding(EdgeInsets(top: 8, leading: 3, bottom: 7, trailing: 0))
                                .onTapGesture {
                                    focusOnTextEditor = true
                                }
                            }
                            .focused($focusOnTextEditor)
                    }
                    
                    Spacer()
                }
                .padding(Edge.Set.leading, 10)
            }
            .frame(height: getFrameHeight())
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            )
            
            Text(prompt)
                .fixedSize(horizontal: false, vertical: true)
                .font(.caption)
        }
    }
}
