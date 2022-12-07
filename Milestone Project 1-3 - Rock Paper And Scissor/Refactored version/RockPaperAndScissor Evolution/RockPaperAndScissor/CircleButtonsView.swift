//
//  CircleButtonsView.swift
//  RockPaperAndScissor
//
//  Created by Pham Anh Tuan on 12/7/22.
//

import SwiftUI

struct CircleButtonsView: View {
    @EnvironmentObject var vm: ContentViewModel
    
    var body: some View {
        VStack (spacing: 20) {
            ForEach($vm.items, id: \.self) { item in
                CircleButtonView(
                    item: item.wrappedValue,
                    backgroundColors: [.gray, .blue, .white],
                    shadowColor: .yellow)
                .disabled(vm.deactivateButtons)
            }
        }
    }
}

struct CircleButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonsView()
            .environmentObject(ContentViewModel())
    }
}
